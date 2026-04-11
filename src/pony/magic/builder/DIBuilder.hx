package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;

import pony.magic.builder.DIVerifier.DIClassSummary;

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
	private static inline final SERVICE: String = ':service';
	private static inline final IMPORT_SERVICE: String = 'imprt';
	private static inline final EXPORT_SERVICE: String = 'exprt';

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
		final diSuperTypeName: Null<String> = isExt && localClass.superClass != null
			? typeNameOf(localClass.superClass.t.get()) : null;
		final diSummary: DIClassSummary = DIVerifier.beginClass(
			typeNameOf(localClass), localClass.pos, diSuperTypeName
		);
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
		for (field in fields) switch field.kind {
			case FVar(t, e) if (t != null):
				final meta: Null<MetadataEntry> = field.meta.getMeta(SERVICE);
				if (meta == null) continue;
				var importService: Bool = false;
				var exportService: Bool = false;
				for (param in meta.params) switch param.expr {
					case EConst(CIdent(IMPORT_SERVICE)): importService = true;
					case EConst(CIdent(EXPORT_SERVICE)): exportService = true;
					case _: throw 'Unsupported flag';
				}
				// Field's declared type — used as the lookup key on the consumer side. The resolver
				// walks the scope chain and finds any registered instance assignable to this type.
				final fieldTypeName: String = complexTypeName(t);
				final isSubclassShadow: Bool = isExt
					&& localClass.superClass.t.get().fields.get().exists(f -> f.name == field.name);
				if (isSubclassShadow)
					fields.remove(field);
				else
					blocks.unshift(macro $i{field.name} = provider.get($v{fieldTypeName}, $v{field.name}));
				if (e != null) {
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
							// Producer collection runs even for subclass-shadow fields: the runtime
							// load/register logic still fires, only the Haxe field declaration is dropped.
							final childDITypeName: Null<String> = switch t.toType() {
								case TInst(inst, _) if (checkDI(inst)): typeNameOf(inst.get());
								case _: null;
							};
							DIVerifier.addProducer(diSummary, {
								fieldName: field.name,
								producerTypeNames: producerTypeNames,
								childDITypeName: childDITypeName,
								imprt: importService,
								exprt: exportService,
								pos: field.pos
							});
							function checkExpr(expr: Expr): Expr {
								return importService ? macro if (!provider.existsInParents($v{primaryTypeName}, $v{field.name})) $expr : expr;
							}
							switch t.toType() {
								case TInst(inst, _) if (checkDI(inst)):
									final childIsAsync: Bool = checkAsyncDestroy(inst);
									if (childIsAsync && !isAsync)
										Context.error('Service "${field.name}" implements AsyncDestroy, but this class does not. Add `implements pony.magic.AsyncDestroy` to this class.', field.pos);
									loads.push(checkExpr(macro provider.load($v{producerTypeNames}, $v{field.name}, $v{exportService})));
									if (childIsAsync) {
										destroysAsync.unshift(importService && exportService ?
											macro if (provider.isExported($v{primaryTypeName}, $v{field.name})) {
												tasks.add();
												$i{field.name}.destroyAsync(function(): Void tasks.end());
											}
											: macro {
												tasks.add();
												$i{field.name}.destroyAsync(function(): Void tasks.end());
											}
										);
									} else {
										destroys.unshift(importService && exportService ?
											macro if (provider.isExported($v{primaryTypeName}, $v{field.name})) $i{field.name}.destroy()
											: macro $i{field.name}.destroy()
										);
									}
									creates.push(checkExpr(macro tasks.add()));
									final cr = if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
										macro $i{t.toString()}.create(provider, instance -> {
											provider.register($v{producerTypeNames}, $v{field.name}, instance, $v{exportService});
											instance.waitReady(tasks.end);
										});
									else
										macro $i{t.toString()}.create(provider, instance -> {
											provider.register($v{producerTypeNames}, $v{field.name}, instance, $v{exportService});
											tasks.end();
										});
									switch cr.expr {
										case ECall(_, params): for (arg in args) params.push(arg);
										case _: throw UNEXPECTED_ERROR;
									}
									creates.push(checkExpr(cr));
								case _:
									loads.push(checkExpr(macro provider.register($v{producerTypeNames}, $v{field.name}, $e, $v{exportService})));
							}
						case _: throw 'Not supported';
					}
					field.kind = FVar(t, null);
				} else if (importService) {
					throw 'Expr not set';
				} else {
					if (!isSubclassShadow) DIVerifier.addConsumer(diSummary, {
						fieldName: field.name,
						consumerTypeName: fieldTypeName,
						pos: field.pos
					});
					switch t.toType() {
						case TInst(inst, _) if (checkDI(inst)):
							creates.push(macro tasks.add());
							if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
								creates.push(macro provider.waitReady($v{fieldTypeName}, $v{field.name}, instance -> instance.waitReady(tasks.end)));
							else
								creates.push(macro provider.waitReady($v{fieldTypeName}, $v{field.name}, tasks.end));
						case _: // skip
					}
				}
			case _:
		}
		// DIBuilder owns the unlisten() call in teardown (rather than HasListenerBuilder prepending
		// it to user destroy) so builder order becomes irrelevant and async classes compose cleanly.
		if (hasListener) destroys.unshift(macro unlisten());
		switch constuctor.kind {
			case FFun(fun):
				fun.expr = fun.expr.replaceToBlock();

				if (isExt) {
					loads.push(macro {
						tasks.add();
						$i{localClass.superClass.t.toString()}.load(provider, tasks.end);
					});
				}

				final nw = macro new $ctp(provider);

				switch nw.expr {
					case ENew(_, params):
						for (arg in fun.args) params.push(macro $i{arg.name});
					case _:
						throw UNEXPECTED_ERROR;
				}

				final load: Field = (macro class {
					public static function load(provider: pony.ServiceProvider, cb: () -> Void): Void {
						final tasks: pony.Tasks = new pony.Tasks(cb);
						tasks.add();
						$b{loads.concat(creates)}
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
					case FFun(f): for (arg in fun.args) f.args.push(arg);
					case _: throw UNEXPECTED_ERROR;
				}
				// trace(new haxe.macro.Printer().printField(create));
				fields.unshift(load);
				fields.unshift(create);

				fun.args.unshift(switch (macro function(provider: pony.ServiceProvider) {}).expr {
					case EFunction(_, v): v.args.pop();
					case _: throw UNEXPECTED_ERROR;
				});
				switch fun.expr.expr {
					case EBlock(lines):
						for (block in blocks) lines.unshift(block);
						if (!isExt) {
							lines.unshift(macro this.provider = provider);
						} else {
							for (line in lines) switch line.expr {
								case ECall({expr: EConst(CIdent('super'))}, params):
									params.unshift(macro provider);
								case _:
							}
						}
					case _: throw UNEXPECTED_ERROR;
				}
			case _: throw UNEXPECTED_ERROR;
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
		final needsGuard: Bool = !(isAsync && !hasChildren);
		// Guard field is unique per class level (__diDestroyed_<ClassName>). Subclasses need
		// their own flag because a shared inherited flag would block super.destroy() chain:
		// when child.destroy sets the flag before calling super, parent.destroy's own guard
		// check would see the flag set and early-return, skipping parent's cleanup.
		final guardFieldName: String = '__diDestroyed_' + localClass.name;
		if (needsGuard) fields.push({
			name: guardFieldName,
			access: [APrivate],
			kind: FVar(macro: Bool, macro false),
			pos: Context.currentPos()
		});
		// Framework-owned idempotency: user can write `if (something) return;` freely, the guard
		// ensures teardown runs exactly once regardless. This makes user-written `_destroyed`
		// flags redundant — their branch will never fire because the guard short-circuits first.
		final guardPrefix: Expr = if (needsGuard) {
			if (isAsync)
				macro {
					if ($i{guardFieldName}) { cb(); return; }
					$i{guardFieldName} = true;
				};
			else
				macro {
					if ($i{guardFieldName}) return;
					$i{guardFieldName} = true;
				};
		} else macro {};
		if (destructor != null) switch destructor.kind {
			case FFun(fun):
				if (isAsync && !hasChildren) {
					// Async leaf: user owns destroyAsync and cb. Only inject unlisten() for HasListener
					// so subscriptions are released before user's async work begins.
					if (hasListener) {
						fun.expr = fun.expr.replaceToBlock();
						switch fun.expr.expr {
							case EBlock(lines): lines.unshift(macro unlisten());
							case _: throw UNEXPECTED_ERROR;
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
			case _: throw UNEXPECTED_ERROR;
		} else {
			if (isAsync) {
				if (isExt)
					fields.push((macro class {
						override public function destroyAsync(cb: () -> Void): Void { $guardPrefix; $teardownExpr; }
					}).fields.pop());
				else
					fields.push((macro class {
						public function destroyAsync(cb: () -> Void): Void { $guardPrefix; $teardownExpr; }
					}).fields.pop());
			} else {
				if (isExt)
					fields.push((macro class {
						override public function destroy(): Void { $guardPrefix; $teardownExpr; }
					}).fields.pop());
				else
					fields.push((macro class {
						public function destroy(): Void { $guardPrefix; $teardownExpr; }
					}).fields.pop());
			}
		}
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
		return type.interfaces.exists(f -> f.t.toString() == ASYNC_DESTROY) || (type.superClass != null && checkAsyncDestroy(type.superClass.t));
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
			visited.set(name, true);
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
		return c.name == lastSeg ? c.module : (c.module + '.' + c.name);
	}

	private static function complexTypeName(t: ComplexType): String {
		return switch t.toType() {
			case TInst(inst, _): typeNameOf(inst.get());
			case _: throw 'Cannot resolve type name from non-class ComplexType';
		};
	}

	#end

}