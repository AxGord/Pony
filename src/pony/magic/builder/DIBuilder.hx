package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;
import pony.magic.builder.DIVerifier;

using Lambda;
using haxe.macro.ComplexTypeTools;
using pony.macro.Tools;
#end

/**
 * DIBuilder
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:CyclomaticComplexity', 'checkstyle:MethodLength', 'checkstyle:InnerAssignment')
final class DIBuilder {

	#if macro
	private static inline final UNEXPECTED_ERROR: String = 'Unexpected error';
	private static inline final DI: String = 'pony.magic.DI';
	private static inline final WR: String = 'pony.magic.WR';
	private static inline final ASYNC_DESTROY: String = 'pony.magic.AsyncDestroy';
	private static inline final HAS_LISTENER: String = 'pony.magic.HasListener';
	private static inline final OWN: String = ':own';
	private static inline final SHARE: String = ':share';
	private static inline final USE: String = ':use';
	private static inline final LEGACY_SERVICE: String = ':service';
	#end

	macro public static function build(): Array<Field> {
		final localClass: ClassType = Context.getLocalClass().get();
		final isExt: Bool = !localClass.interfaces.exists(f -> f.t.toString() == DI);
		final superIsAsync: Bool = localClass.superClass != null && checkAsyncDestroy(localClass.superClass.t);
		// Auto-promote to async if super is async: a sync child cannot destroy an async parent correctly.
		final isAsync: Bool = localClass.interfaces.exists(f -> f.t.toString() == ASYNC_DESTROY) || superIsAsync;
		// Direct interface check only — inherited HasListener is handled via super.destroy() chain,
		// adding unlisten() at every level would double-dispatch it.
		final hasListener: Bool = localClass.interfaces.exists(f -> f.t.toString() == HAS_LISTENER);
		final ctp: TypePath = @:privateAccess TypeTools.toTypePath(localClass, []);
		final ct: ComplexType = TPath(ctp);
		final fields: Array<Field> = Context.getBuildFields();
		final diSuperTypeName: Null<String> = isExt && localClass.superClass != null ? typeNameOf(localClass.superClass.t.get()) : null;
		var constuctor: Null<Field> = fields.find(f -> f.name == 'new');
		if (constuctor == null) {
			if (Context.getLocalClass().get().superClass == null) {
				constuctor = (macro class {
					public function new() {}
				}).fields.pop();
				fields.unshift(constuctor);
			} else {
				throw 'Constructor not exists';
			}
		}
		// Detect user-code references to `provider` (before framework modifications).
		var usesProvider: Bool = false;
		switch constuctor.kind {
			case FFun(fun) if (fun.expr != null):
				usesProvider = fun.expr.containsIdent('provider');
			case _:
		}
		if (!usesProvider) for (f in fields) if (f.name != 'new') switch f.kind {
			case FFun(fun) if (fun.expr != null && fun.expr.containsIdent('provider')):
				usesProvider = true;
				break;
			case _:
		}
		final diSummary: DIClassSummary = DIVerifier.beginClass(typeNameOf(localClass), localClass.pos, diSuperTypeName, usesProvider);
		final destructor: Null<Field> = fields.find(f -> f.name == 'destroy' || f.name == 'destroyAsync');
		if (destructor != null) {
			if (isAsync && destructor.name != 'destroyAsync')
				Context.error('Class implements AsyncDestroy, destroy method must be destroyAsync(cb: () -> Void)', destructor.pos);
			if (!isAsync && destructor.name != 'destroy')
				Context.error('Class does not implement AsyncDestroy, destroy method must be destroy() not destroyAsync', destructor.pos);
		}
		final loads: Array<Expr> = [];
		final creates: Array<Expr> = [];
		final blocks: Array<Expr> = [];
		final destroys: Array<Expr> = [];
		final destroysAsync: Array<Expr> = [];
		if (isExt) {
			if (superIsAsync)
				destroysAsync.push(macro {
					tasks.add();
					super.destroyAsync(tasks.end);
				});
			else
				destroys.push(macro super.destroy());
		} else {
			destroys.push(macro provider.destroy());
		}
		// Pre-scan: collect @:own producers for local var optimization in createFast calls.
		// ownNonDIVars — non-DI types (L2 optimization).
		// ownStaticDIVars — L3-eligible DI types (no @:share, no WR, no provider refs).
		final ownNonDIVars: Map<String, { varName: String, typeNames: Array<String> }> = [];
		final ownStaticDIVars: Map<String, { varName: String, typeNames: Array<String> }> = [];
		for (field in fields) switch field.kind {
			case FVar(t, {
				expr: ENew(tp, _)
			}) if (t != null && field.meta.getMeta(OWN) != null && field.meta.getMeta(SHARE) == null && field.meta.getMeta(USE) == null):
				switch TPath(tp).toType() {
					case TInst(inst, _) if (!checkDI(inst)):
						ownNonDIVars[field.name] = {
							varName: '_di_${field.name}',
							typeNames: collectAssignableTypeNames(inst)
						};
					case TInst(inst, _) if (checkDI(inst) && !checkWR(inst) && DIVerifier.isStaticEligible(typeNameOf(inst.get()))):
						ownStaticDIVars[field.name] = {
							varName: '_di_${field.name}',
							typeNames: collectAssignableTypeNames(inst)
						};
					case _:
				}
			case _:
		}
		final depDescriptors: Array<{ paramName: String, type: ComplexType }> = [];
		// L3-stage4: @:own static-eligible DI fields passed as constructor params.
		// Unlike depDescriptors (@:use, external input), these are self-created in load().
		final ownStaticDepDescriptors: Array<{ paramName: String, type: ComplexType }> = [];
		for (field in fields) switch field.kind {
			case FVar(t, e) if (t != null):
				if (field.meta.getMeta(LEGACY_SERVICE) != null)
					Context.error('DI: @:service is replaced. Use @:own, @:share, or @:use.', field.pos);
				final ownMeta: Null<MetadataEntry> = field.meta.getMeta(OWN);
				final shareMeta: Null<MetadataEntry> = field.meta.getMeta(SHARE);
				final useMeta: Null<MetadataEntry> = field.meta.getMeta(USE);
				final presentCount: Int = (ownMeta != null ? 1 : 0) + (shareMeta != null ? 1 : 0) + (useMeta != null ? 1 : 0);
				if (presentCount == 0) continue;
				if (presentCount > 1)
					Context.error('DI: field has multiple service attributes. Pick one of @:own, @:share, @:use.', field.pos);
				if ((ownMeta != null || shareMeta != null) && e == null)
					Context.error('DI: @:${ownMeta != null ? 'own' : 'share'} requires an initializer.', field.pos);
				if (ownMeta != null || shareMeta != null) {
					final blocked: Null<String> = instanceReference(e, fields, constuctor);
					if (blocked != null)
						Context.error(
							'DI: @:${ownMeta != null ? 'own' : 'share'} initializer is evaluated in the generated '
							+ 'static load(), so it cannot use "$blocked". Depend on another service with @:use, '
							+ 'or build from a static, a constant or a literal.',
							field.pos
						);
				}
				if (useMeta != null && e != null)
					Context.error('DI: @:use must not have an initializer. Use @:own or @:share to create the instance.', field.pos);
				// Field's declared type — used as the lookup key on the consumer side. The resolver
				// walks the scope chain and finds any registered instance assignable to this type.
				final fieldTypeName: String = complexTypeName(t);
				if (isExt && localClass.superClass.t.get().fields.get().exists(f -> f.name == field.name))
					Context.error('DI: field "${field.name}" shadows parent field. Rename or remove.', field.pos);
				if (useMeta != null) {
					final depParamName: String = '_di_${field.name}';
					depDescriptors.push({ paramName: depParamName, type: t });
					blocks.unshift(
						macro $i{field.name} = $i{depParamName} != null ? $i{depParamName} : provider.get($v{fieldTypeName}, $v{field.name})
					);
					DIVerifier.addConsumer(diSummary, {
						fieldName: field.name,
						consumerTypeName: fieldTypeName,
						pos: field.pos
					});
					// L3-stage3: skip waitReady for static-eligible DI deps — passed directly via createFast.
					switch t.toType() {
						case TInst(inst, _) if (checkDI(inst)):
							final depIsStatic: Bool = !checkWR(inst) && DIVerifier.isStaticEligible(typeNameOf(inst.get()));
							if (!depIsStatic) {
								creates.push(macro tasks.add());
								if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
									creates.push(macro provider.waitReady(
										$v{fieldTypeName}, $v{field.name}, instance -> instance.waitReady(tasks.end)
									));
								else
									creates.push(macro provider.waitReady($v{fieldTypeName}, $v{field.name}, tasks.end));
							}
						case _: // skip
					}
				} else {
					// L3-stage4: static-eligible @:own DI fields use constructor param with provider.get fallback
					// (create path passes null, createFast path passes load-local var).
					final isOwnStaticDI: Bool = ownStaticDIVars.exists(field.name);
					if (isOwnStaticDI) {
						final depParamName: String = '_di_${field.name}';
						ownStaticDepDescriptors.push({ paramName: depParamName, type: t });
						blocks.unshift(
							macro $i{field.name} = $i{depParamName} != null
								? $i{depParamName}
								: provider.get($v{fieldTypeName}, $v{field.name})
						);
					} else {
						blocks.unshift(macro $i{field.name} = provider.get($v{fieldTypeName}, $v{field.name}));
					}
					final kind: ProducerKind = shareMeta != null ? Share : Own;
					// Share = imprt + exprt: guarded on ancestor fallback, published to root.
					final importService: Bool = kind == Share;
					final exportService: Bool = kind == Share;
					switch e.expr {
						case ENew(t, args):
							final t: ComplexType = TPath(t);
							// Producer registers the instance under all type names it is assignable to,
							// so a consumer asking for any super class or interface still finds it.
							final producerTypeNames: Array<String> = switch t.toType() {
								case TInst(inst, _): collectAssignableTypeNames(inst);
								case _: [fieldTypeName];
							};
							final primaryTypeName: String = producerTypeNames[0];
							final childDITypeName: Null<String> = switch t.toType() {
								case TInst(inst, _) if (checkDI(inst)): typeNameOf(inst.get());
								case _: null;
							};
							DIVerifier.addProducer(diSummary, {
								fieldName: field.name,
								producerTypeNames: producerTypeNames,
								childDITypeName: childDITypeName,
								kind: kind,
								pos: field.pos
							});
							function checkExpr(expr: Expr): Expr {
								return importService ? macro if (!provider.existsInParents(
									$v{primaryTypeName}, $v{field.name}
								)) $expr : expr;
							}
							switch t.toType() {
								case TInst(inst, _) if (checkDI(inst)):
									final childIsAsync: Bool = checkAsyncDestroy(inst);
									if (childIsAsync && !isAsync)
										Context.error(
											'Service "${field.name}" implements AsyncDestroy, but this class does not. Add `implements '
											+ 'pony.magic.AsyncDestroy` to this class.',
											field.pos
										);
									// L3: skip provider.load for static-eligible DI children; declare local var instead.
									final staticDIVar: Null<{ varName: String, typeNames: Array<String> }> = ownStaticDIVars[field.name];
									loads.push(
										if (staticDIVar != null)
											{
												expr: EVars([
													{
														name: staticDIVar.varName,
														type: TPath({ pack: [], name: 'Null', params: [TPType(t)] }),
														expr: macro null,
														isFinal: false
													}
												]),
												pos: Context.currentPos()
											}
										else
											checkExpr(macro provider.load($v{producerTypeNames}, $v{field.name}, $v{exportService}))
									);
									if (childIsAsync) {
										destroysAsync.unshift(importService && exportService
											? macro if (provider.isExported($v{primaryTypeName}, $v{field.name})) {
												tasks.add();
												$i{field.name}.destroyAsync(function(): Void tasks.end());
											}
											: macro {
												tasks.add();
												$i{field.name}.destroyAsync(function(): Void tasks.end());
											});
									} else {
										destroys.unshift(importService && exportService ? macro if (provider.isExported(
											$v{primaryTypeName}, $v{field.name}
										))
											$i{field.name}.destroy() : macro $i{field.name}.destroy());
									}
									creates.push(checkExpr(macro tasks.add()));
									// L3: for static-eligible DI children, store instance in local var.
									// Register kept for create() backward compat; createFast skips it.
									final cr = if (staticDIVar != null)
										macro $i{t.toString()}.create(provider, instance -> {
											$i{staticDIVar.varName} = instance;
											provider.register($v{producerTypeNames}, $v{field.name}, instance, $v{exportService});
											tasks.end();
										})
									else if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
										macro $i{t.toString()}.create(provider, instance -> {
											provider.register($v{producerTypeNames}, $v{field.name}, instance, $v{exportService});
											instance.waitReady(tasks.end);
										})
									else
										macro $i{t.toString()}.create(provider, instance -> {
											provider.register($v{producerTypeNames}, $v{field.name}, instance, $v{exportService});
											tasks.end();
										});
									final childConsumers: Array<ConsumerEntry> = DIVerifier.getConsumers(typeNameOf(inst.get()));
									switch cr.expr {
										case ECall(callTarget, params):
											if (childConsumers.length > 0) {
												switch callTarget.expr {
													case EField(obj, _):
														callTarget.expr = EField(obj, 'createFast');
													case _:
														throw UNEXPECTED_ERROR;
												}
												var insertIdx: Int = 1;
												for (consumer in childConsumers) {
													final matchedVar: Null<String> = resolveLocalVar(
														consumer, ownNonDIVars, ownStaticDIVars
													);
													params.insert(
														insertIdx,
														matchedVar != null
															? macro $i{matchedVar}
															: macro provider.get($v{consumer.consumerTypeName}, $v{consumer.fieldName})
													);
													insertIdx++;
												}
											}
											for (arg in args) params.push(arg);
										case _:
											throw UNEXPECTED_ERROR;
									}
									creates.push(checkExpr(cr));
								case _:
									final localVar: Null<{ varName: String, typeNames: Array<String> }> = ownNonDIVars[field.name];
									if (localVar != null) {
										loads.push({
											expr: EVars([
												{
													name: localVar.varName,
													type: t,
													expr: e,
													isFinal: true
												}
											]),
											pos: Context.currentPos()
										});
										loads.push(checkExpr(macro provider.register(
											$v{producerTypeNames}, $v{field.name}, $i{localVar.varName}, $v{exportService}
										)));
									} else {
										loads.push(
											checkExpr(
												macro provider.register($v{producerTypeNames}, $v{field.name}, $e, $v{exportService})
											)
										);
									}
							}
						case _:
							throw 'Not supported';
					}
					field.kind = FVar(t, null);
				}
			case _:
		}
		// DIBuilder owns the unlisten() call in teardown (rather than HasListenerBuilder prepending
		// it to user destroy) so builder order becomes irrelevant and async classes compose cleanly.
		if (hasListener) destroys.unshift(macro unlisten());
		// L3-stage3: self is static-eligible when all conditions met.
		final selfIsStatic: Bool = !usesProvider && !isAsync && DIVerifier.isStaticEligible(typeNameOf(localClass));
		switch constuctor.kind {
			case FFun(fun):
				fun.expr = fun.expr.replaceToBlock();

				if (isExt) {
					loads.push(macro {
						tasks.add();
						$i{localClass.superClass.t.toString()}.load(provider, tasks.end);
					});
				}

				final nw: Expr = macro new $ctp(provider);
				switch nw.expr {
					case ENew(_, params):
						for (_ in depDescriptors) params.push(macro null);
						for (_ in ownStaticDepDescriptors) params.push(macro null);
						for (arg in fun.args) params.push(macro $i{arg.name});
					case _:
						throw UNEXPECTED_ERROR;
				}

				final loadBody: Array<Expr> = loads.concat(creates);
				final load: Field = (macro class {
					public static function load(provider: pony.ServiceProvider, cb: () -> Void): Void {
						final tasks: pony.Tasks = new pony.Tasks(cb);
						tasks.add();
						$b{loadBody}
						tasks.end();
					}
				}).fields.pop();
				final create: Field = (macro class {
					public static function create(?serviceProvider: pony.ServiceProvider, cb: $ct -> Void): Void {
						final provider: pony.ServiceProvider = serviceProvider != null ? serviceProvider.sub() : new pony.ServiceProvider();
						load(provider, () -> cb($nw));
					}
				}).fields.pop();
				switch create.kind {
					case FFun(f):
						for (arg in fun.args) f.args.push(arg);
					case _:
						throw UNEXPECTED_ERROR;
				}
				// trace(new haxe.macro.Printer().printField(create));
				fields.unshift(load);
				fields.unshift(create);
				final hasDepDescriptors: Bool = depDescriptors.length > 0 || ownStaticDepDescriptors.length > 0;
				if (hasDepDescriptors) {
					// nwFast for non-selfIsStatic: @:use deps from createFast params, @:own static as null (fallback).
					// nwFastInlined for selfIsStatic: all deps from scope (params + load-local vars).
					final nwFast: Expr = macro new $ctp(provider);
					switch nwFast.expr {
						case ENew(_, params):
							for (dep in depDescriptors) params.push(macro $i{dep.paramName});
							for (_ in ownStaticDepDescriptors) params.push(macro null);
							for (arg in fun.args) params.push(macro $i{arg.name});
						case _:
							throw UNEXPECTED_ERROR;
					}
					final nwFastInlined: Expr = if (selfIsStatic) {
						final e: Expr = macro new $ctp(provider);
						switch e.expr {
							case ENew(_, params):
								for (dep in depDescriptors) params.push(macro $i{dep.paramName});
								for (dep in ownStaticDepDescriptors)
									params.push({ expr: EConst(CIdent(dep.paramName)), pos: Context.currentPos() });
								for (arg in fun.args) params.push(macro $i{arg.name});
							case _:
								throw UNEXPECTED_ERROR;
						}
						e;
					} else
						macro null; // unused
					// L3-stage3+4: static-eligible classes skip provider.sub() and inline load
					// body into createFast so @:own static local vars are in scope for nwFast.
					// Loads (var declarations) go before Tasks so closures can capture them.
					// All exprs in one flat block to keep var scoping correct.
					final createFast: Field = if (selfIsStatic) {
						// L3-stage5: when no async work remains (no non-EVars loads, no creates),
						// skip Tasks wrapper entirely and call cb synchronously.
						final hasNonEVarLoads: Bool = loads.exists(e -> switch e.expr {
							case EVars(_): false;
							case _: true;
						});
						final body: Array<Expr> = [macro final provider: pony.ServiceProvider = cast serviceProvider];
						for (e in loads) switch e.expr {
							case EVars(_):
								body.push(e);
							case _:
						}
						if (!hasNonEVarLoads && creates.length == 0) {
							body.push(macro cb($nwFastInlined));
						} else {
							body.push(macro final tasks: pony.Tasks = new pony.Tasks(() -> cb($nwFastInlined)));
							body.push(macro tasks.add());
							for (e in loads) switch e.expr {
								case EVars(_):
								case _:
									body.push(e);
							}
							for (e in creates) body.push(e);
							body.push(macro tasks.end());
						}
						final f: Field = (macro class {
							public static function createFast(?serviceProvider: pony.ServiceProvider, cb: $ct -> Void): Void {}
						}).fields.pop();
						switch f.kind {
							case FFun(fun):
								fun.expr = macro $b{body};
							case _:
								throw UNEXPECTED_ERROR;
						}
						f;
					} else {
						(macro class {
							public static function createFast(?serviceProvider: pony.ServiceProvider, cb: $ct -> Void): Void {
								final provider: pony.ServiceProvider = serviceProvider != null
									? serviceProvider.sub()
									: new pony.ServiceProvider();
								load(provider, () -> cb($nwFast));
							}
						}).fields.pop();
					};
					switch createFast.kind {
						case FFun(f):
							var depIdx: Int = 1;
							for (dep in depDescriptors) {
								f.args.insert(depIdx, { name: dep.paramName, type: dep.type });
								depIdx++;
							}
							for (arg in fun.args) f.args.push(arg);
						case _:
							throw UNEXPECTED_ERROR;
					}
					fields.unshift(createFast);
				}

				fun.args.unshift( switch (macro function(provider: pony.ServiceProvider) {}).expr {
					case EFunction(_, v): v.args.pop();
					case _: throw UNEXPECTED_ERROR;
				});
				var depArgIdx: Int = 1;
				for (dep in depDescriptors) {
					fun.args.insert(depArgIdx, {
						name: dep.paramName,
						type: TPath({ pack: [], name: 'Null', params: [TPType(dep.type)] }),
						value: macro null
					});
					depArgIdx++;
				}
				// L3-stage4: @:own static DI fields as constructor params (after @:use deps).
				for (dep in ownStaticDepDescriptors) {
					fun.args.insert(depArgIdx, {
						name: dep.paramName,
						type: TPath({ pack: [], name: 'Null', params: [TPType(dep.type)] }),
						value: macro null
					});
					depArgIdx++;
				}
				switch fun.expr.expr {
					case EBlock(lines):
						for (block in blocks) lines.unshift(block);
						if (isExt) {
							for (line in lines) switch line.expr {
								case ECall({ expr: EConst(CIdent('super')) }, params):
									params.unshift(macro provider);
								case _:
							}
						} else {
							lines.unshift(macro this.provider = provider);
						}
					case _: throw UNEXPECTED_ERROR;
				}
			case _:
				throw UNEXPECTED_ERROR;
		}
		// A class counts as having children if it declares services, extends a DI parent,
		// or has async children routed through destroysAsync. Leaves (no children) skip
		// framework teardown — their provider is empty anyway.
		final hasChildren: Bool = destroys.length > 1 || destroysAsync.length > 0 || isExt;
		final teardownExpr: Expr = if (isAsync) {
			if (destroysAsync.length > 0)
				// Tasks coordinator: kick off all async children in parallel, run sync teardown
				// and fire cb in the final callback after every async child has completed.
				macro {
					final tasks: pony.Tasks = new pony.Tasks(() -> {
						$b{destroys}
						cb();
					});
					tasks.add();
					$b{destroysAsync}
					tasks.end();
				};
			else
				// Async class with only sync children — no coordinator needed, cb fires inline.
				macro {
					$b{destroys}
					cb();
				};
		} else {
			macro $b{destroys};
		};
		// Async leaves have no framework teardown (user owns the body), so there is nothing
		// to guard against re-running — skip the guard to avoid polluting user's destroyAsync
		// with a flag that would also swallow their own early-return logic.
		final needsGuard: Bool = !isAsync || hasChildren;
		// Guard field is unique per class level (__diDestroyed_<ClassName>). Subclasses need
		// their own flag because a shared inherited flag would block super.destroy() chain:
		// when child.destroy sets the flag before calling super, parent.destroy's own guard
		// check would see the flag set and early-return, skipping parent's cleanup.
		final guardFieldName: String = '__diDestroyed_${localClass.name}';
		if (needsGuard) fields.push({
			name: guardFieldName,
			access: [APrivate],
			kind: FVar(macro :Bool, macro false),
			pos: Context.currentPos()
		});
		// Framework-owned idempotency: user can write `if (something) return;` freely, the guard
		// ensures teardown runs exactly once regardless. This makes user-written `_destroyed`
		// flags redundant — their branch will never fire because the guard short-circuits first.
		final guardPrefix: Expr = if (needsGuard) {
			if (isAsync)
				macro {
					if ($i{guardFieldName}) {
						cb();
						return;
					}
					$i{guardFieldName} = true;
				};
			else
				macro {
					if ($i{guardFieldName}) return;
					$i{guardFieldName} = true;
				};
		} else
			macro {};
		if (destructor != null)
			switch destructor.kind {
				case FFun(fun):
					if (isAsync && !hasChildren) {
						// Async leaf: user owns destroyAsync and cb. Only inject unlisten() for HasListener
						// so subscriptions are released before user's async work begins.
						if (hasListener) {
							fun.expr = fun.expr.replaceToBlock();
							switch fun.expr.expr {
								case EBlock(lines):
									lines.unshift(macro unlisten());
								case _:
									throw UNEXPECTED_ERROR;
							}
						}
					} else {
						// rewriteReturns inserts teardown before every `return` in user body so early
						// returns still trigger cleanup (C1 fix). The trailing push handles fall-through.
						fun.expr = fun.expr.replaceToBlock();
						fun.expr = pony.macro.Tools.rewriteReturns(fun.expr, teardownExpr);
						switch fun.expr.expr {
							case EBlock(lines):
								lines.unshift(guardPrefix);
								lines.push(teardownExpr);
							case _: throw UNEXPECTED_ERROR;
						}
					}
				case _:
					throw UNEXPECTED_ERROR;
			}
		else if (isAsync) {
			fields.push(isExt
				? (macro class {
					override public function destroyAsync(cb: () -> Void): Void {
						$guardPrefix;
						$teardownExpr;
					}
				}).fields.pop()
				: (macro class {
					public function destroyAsync(cb: () -> Void): Void {
						$guardPrefix;
						$teardownExpr;
					}
				}).fields.pop());
		} else if (isExt)
			fields.push((macro class {
				override public function destroy(): Void {
					$guardPrefix;
					$teardownExpr;
				}
			}).fields.pop());
		else
			fields.push((macro class {
				public function destroy(): Void {
					$guardPrefix;
					$teardownExpr;
				}
			}).fields.pop());
		if (!isExt) fields.unshift((macro class {
			private final provider: pony.ServiceProvider;
		}).fields.pop());
		return fields;
	}

	#if macro
	private static function checkDI(inst: haxe.macro.Type.Ref<ClassType>): Bool {
		final type: ClassType = inst.get();
		return type.interfaces.exists(f -> f.t.toString() == DI) || (type.superClass != null && checkDI(type.superClass.t));
	}

	private static function checkAsyncDestroy(inst: haxe.macro.Type.Ref<ClassType>): Bool {
		final type: ClassType = inst.get();
		return type.interfaces.exists(f -> f.t.toString() == ASYNC_DESTROY)
			|| (type.superClass != null && checkAsyncDestroy(type.superClass.t));
	}

	/**
	 * Collect all type names that the given class is assignable to: itself, all super classes,
	 * all directly and transitively implemented interfaces. Used for type-based service registration:
	 * one instance gets registered under every assignable type so consumers can request any of them.
	 */
	private static function collectAssignableTypeNames(inst: haxe.macro.Type.Ref<ClassType>): Array<String> {
		final result: Array<String> = [];
		final visited: Map<String, Bool> = [];
		function add(c: ClassType): Void {
			final name: String = typeNameOf(c);
			if (visited.exists(name)) return;
			visited[name] = true;
			result.push(name);
			for (i in c.interfaces) add(i.t.get());
			if (c.superClass != null) add(c.superClass.t.get());
		}
		add(inst.get());
		return result;
	}

	private static function typeNameOf(c: ClassType): String {
		final segs: Array<String> = c.module.split('.');
		final lastSeg: String = segs[segs.length - 1];
		return c.name == lastSeg ? c.module : '${c.module}.${c.name}';
	}

	private static function complexTypeName(t: ComplexType): String {
		return switch t.toType() {
			case TInst(inst, _): typeNameOf(inst.get());
			case _: throw 'Cannot resolve type name from non-class ComplexType';
		};
	}

	/**
	 * Name of the first instance-scoped identifier an @:own / @:share initializer reaches
	 * for, or null when the initializer is static-safe.
	 *
	 * Initializers are spliced into the generated static load(), where `this`, instance
	 * members and constructor arguments do not exist. Haxe reports that as a bare
	 * "Cannot access X in static function" pointing at the user's initializer, which says
	 * nothing about why the context is static — so it is caught here instead.
	 */
	private static function instanceReference(e: Null<Expr>, fields: Array<Field>, constuctor: Field): Null<String> {
		if (e == null) return null;
		if (e.containsIdent('this')) return 'this';
		for (f in fields) if (f.name != 'new' && (f.access == null || !f.access.contains(AStatic)) && e.containsIdent(f.name))
			return f.name;
		switch constuctor.kind {
			case FFun(fun):
				for (arg in fun.args) if (e.containsIdent(arg.name))
					return arg.name;
			case _:
		}
		return null;
	}

	/**
	 * Find a same-level @:own producer matching a child consumer by type.
	 * Checks both non-DI local vars (L2) and static-eligible DI local vars (L3).
	 * Mirrors ServiceProvider.get resolution: single type match returns directly,
	 * multiple matches disambiguate by field name, no match returns null.
	 */
	private static function resolveLocalVar(
		consumer: ConsumerEntry, ownNonDIVars: Map<String, { varName: String, typeNames: Array<String> }>,
		ownStaticDIVars: Map<String, { varName: String, typeNames: Array<String> }>
	): Null<String> {
		var matched: Null<String> = null;
		var count: Int = 0;
		for (fieldName => info in ownNonDIVars) if (info.typeNames.contains(consumer.consumerTypeName)) {
			count++;
			if (count == 1) matched = info.varName;
			if (fieldName == consumer.fieldName) return info.varName;
		}
		for (fieldName => info in ownStaticDIVars) if (info.typeNames.contains(consumer.consumerTypeName)) {
			count++;
			if (count == 1) matched = info.varName;
			if (fieldName == consumer.fieldName) return info.varName;
		}
		return count == 1 ? matched : null;
	}

	private static function checkWR(inst: haxe.macro.Type.Ref<ClassType>): Bool {
		final type: ClassType = inst.get();
		return type.interfaces.exists(f -> f.t.toString() == WR) || (type.superClass != null && checkWR(type.superClass.t));
	}
	#end

}
