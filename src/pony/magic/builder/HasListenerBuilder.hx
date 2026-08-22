package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.ds.Triple;

using haxe.macro.ExprTools;
using pony.macro.Tools;
using pony.text.TextTools;

private typedef Handler = Triple<FunctionArg, FunctionArg, Array<Expr>>;

/** One bindable a condition reads: `name`, or `parent.name` when reached through a field. */
private typedef CondRef = { parent: Null<String>, name: String };
#end

/**
 * HasListenerBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasListenerBuilder {

	#if macro
	private static final RESERVED: Array<String> = ['true', 'false', 'null', 'this'];
	#end

	@SuppressWarnings('checkstyle:MethodLength', 'checkstyle:CyclomaticComplexity')
	macro public static function build(): Array<Field> {
		final fields: Array<Field> = Context.getBuildFields();
		final handlers: Map<String, Handler> = [];
		final listen: Array<Expr> = [];
		final unlisten: Array<Expr> = [];
		var hasNew: Bool = false;
		var hasDestroy: Bool = false;
		// DI-classes delegate destroy-method generation and teardown to DIBuilder, which also
		// inserts unlisten() into its teardown chain. HasListenerBuilder stays out of destroy
		// entirely for DI classes to avoid double-unlisten and order-dependent bugs.
		final hasDI: Bool = checkDI(Context.getLocalClass().get());
		function getType(name: String): Null<ComplexType> {
			for (field in fields) if (field.name == name) {
				return switch field.kind {
					case FVar(t, _): t;
					case FProp(_, _, t, _): t;
					case FFun(f): f.ret;
				}
			}
			return null;
		}
		for (field in fields) switch field {
			case { name: 'new', kind: FFun(f) }:
				hasNew = true;
				f.expr = f.expr.replaceToBlock();
				switch f.expr.expr {
					case EBlock(exprs): exprs.push(macro listen());
					case _: throw 'Constructor type error';
				}
			case { name: 'destroy', kind: FFun(f) } if (!hasDI):
				hasDestroy = true;
				f.expr = f.expr.replaceToBlock();
				switch f.expr.expr {
					case EBlock(exprs): exprs.unshift(macro unlisten());
					case _: throw 'Constructor type error';
				}
			case { meta: meta } if (meta != null):
				for (m in meta) {
					final isListen: Bool = m.name == ':listen';
					final isOnce: Bool = m.name == ':listenOnce';
					if (!isListen && !isOnce) continue;
					// `priority = N` is pulled out before the positional params, so it reads as a named
					// argument and works with or without a condition. A condition is never an
					// assignment, so the two forms cannot be confused.
					final priority: Null<Expr> = takeNamed(m.params, 'priority');
					final expr: Null<Expr> = m.params.shift();
					final cond: Null<Expr> = m.params.shift();
					if (expr != null) {
						// Priority-less codegen stays byte for byte what it was: the signal's own
						// default (0, insertion order within it) is not spelled out.
						final subscribe: Expr = if (priority == null) {
							isOnce ? macro $expr.once($i{field.name}) : macro $expr.add($i{field.name});
						} else {
							isOnce ? macro $expr.once($i{field.name}, $priority) : macro $expr.add($i{field.name}, $priority);
						}
						if (cond != null) {
							listen.push(macro if ($cond) $subscribe);
							unlisten.push(macro if ($cond) $expr.remove($i{field.name}));
							// Every bindable the condition reads gets its own change handler. A dispatch
							// carries exactly one field, so inside a handler the OTHER fields still hold
							// the value the condition last saw: re-evaluating the whole condition with
							// only this field swapped back to its previous value says whether the
							// condition itself flipped — however many fields it names.
							//
							// Substituting into the condition (rather than shadowing the field with a
							// local) is also what makes the `parent.field` form work at all: unlike a
							// bare identifier, a field access cannot be shadowed.
							final tracked: Array<CondRef> = [];
							collect(cond, tracked, fields);
							if (tracked.length == 0) {
								Context.error('@:listen condition must read at least one @:bindable field', cond.pos);
							}
							for (ref in tracked) {
								final parent: Null<String> = ref.parent;
								final s: String = ref.name;
								final name: String = 'change${s.bigFirst()}';
								final argName: String = parent == null ? s : '${parent}_$s';
								final prevName: String = parent == null ? 'prev${s.bigFirst()}' : 'prev_${parent}_$s';
								final listenerName: String = parent == null ? '${name}Handler' : '${parent}_${name}Handler';
								var handler: Null<Handler> = handlers[listenerName];
								if (handler == null) {
									// One add/remove pair per tracked field, however many conditions read it.
									final signal: Expr = parent == null ? macro $i{name} : macro $i{parent}.$name;
									listen.push(macro $signal.add($i{listenerName}));
									unlisten.push(macro $signal.remove($i{listenerName}));
									// A field of another class is not among this class' build fields, so its
									// type stays unset and unifies with the signal's listener instead.
									final type: Null<ComplexType> = parent == null ? getType(s) : null;
									handler = new Triple({ name: argName, type: type }, { name: prevName, type: type }, []);
									handlers[listenerName] = handler;
								}
								final newCond: Expr = rewrite(cond, parent, s, macro $i{argName});
								final prevCond: Expr = rewrite(cond, parent, s, macro $i{prevName});
								handler.c.push(macro if ($newCond) {
									if (!$prevCond) $subscribe;
								} else {
									if ($prevCond) $expr.remove($i{field.name});
								});
							}
						} else {
							listen.push(subscribe);
							// Null-guard: @:auto signals on the listened object may have been
							// destroyed (eName = null) by an earlier teardown step before this
							// unlisten() runs (e.g. owner.close() destroys the socket, then
							// owner.destroy() generates the unlisten). @:auto getter does not
							// recreate the signal, so a direct .remove on null would crash.
							unlisten.push(macro {
								final s = $expr;
								if (s != null) s.remove($i{field.name});
							});
						}
					} else {
						throw 'Expr not set';
					}
				}
			case _:
		}
		var ext: Bool = true;
		for (i in Context.getLocalClass().get().interfaces) if (i.t.toString() == 'pony.magic.HasListener') {
			ext = false;
			break;
		}

		// todo: check listeners exists before create methods?
		if (ext) listen.unshift(macro super.listen());
		final listenMethod: Field = (macro class {
			public function listen(): Void $b{listen}
		}).fields.pop();

		if (ext) listenMethod.access.push(AOverride);
		fields.push(listenMethod);

		if (ext) unlisten.unshift(macro super.unlisten());
		final unlistenMethod: Field = (macro class {
			public function unlisten(): Void $b{unlisten}
		}).fields.pop();
		if (ext) unlistenMethod.access.push(AOverride);
		fields.push(unlistenMethod);

		if (!hasNew && !ext) {
			fields.push((macro class {
				public function new(): Void listen();
			}).fields.pop());
		}

		if (!hasDestroy && !ext && !hasDI) {
			if (checkDestroy(Context.getLocalClass().get())) {
				fields.push((macro class {
					override public function destroy(): Void {
						super.destroy();
						unlisten();
					}
				}).fields.pop());
			} else {
				fields.push((macro class {
					public function destroy(): Void unlisten();
				}).fields.pop());
			}
		}

		for (name => checks in handlers) {
			final field: Field = (macro class {
				public function _(): Void $b{checks.c}
			}).fields.pop();
			field.name = name;
			switch field.kind {
				case FFun(f):
					f.args.push(checks.a);
					f.args.push(checks.b);
				case _:
					throw 'Something wrong';
			}
			fields.push(field);
		}
		return fields;
	}

	#if macro
	/**
	 * Collects every bindable the condition reads. Identifiers starting with an upper case
	 * letter are types and enum constructors, never fields, so `Phase.Air` and `Assets.HORSE`
	 * are skipped; a field declared in this class without `@:bindable` has no change signal and
	 * is skipped too. Anything else is taken as a bindable, and a wrong guess fails loudly on
	 * the missing `changeX`.
	 */
	private static function collect(e: Expr, into: Array<CondRef>, fields: Array<Field>): Void {
		switch e.expr {
			case EField({ expr: EConst(CIdent(parent)) }, name, _) if (isMemberName(parent)):
				pushRef(into, parent, name);
			case EConst(CIdent(name)) if (isMemberName(name) && !RESERVED.contains(name) && isBindable(fields, name)):
				pushRef(into, null, name);
			case _:
				e.iter(collect.bind(_, into, fields));
		}
	}

	private static function isBindable(fields: Array<Field>, name: String): Bool {
		for (f in fields) if (f.name == name) {
			if (f.meta != null) for (m in f.meta) if (m.name == ':bindable') return true;
			return false;
		}
		return true;
	}

	private static function pushRef(into: Array<CondRef>, parent: Null<String>, name: String): Void {
		for (ref in into) if (ref.parent == parent && ref.name == name) return;
		into.push({ parent: parent, name: name });
	}

	private static inline function isMemberName(name: String): Bool {
		final c: String = name.charAt(0);
		return c == c.toLowerCase();
	}

	/**
	 * Removes the first `name = value` parameter from a metadata parameter list and returns its
	 * value, so the rest of the list can be read positionally.
	 */
	private static function takeNamed(params: Array<Expr>, name: String): Null<Expr> {
		for (i in 0...params.length) switch params[i].expr {
			case EBinop(OpAssign, { expr: EConst(CIdent(n)) }, value) if (n == name):
				params.splice(i, 1);
				return value;
			case _:
		}
		return null;
	}

	/**
	 * Replaces every read of the bindable the condition watches — `name` or `parent.name` —
	 * with `to`, so the same condition can be evaluated against the new and the previous value.
	 */
	private static function rewrite(e: Expr, parent: Null<String>, name: String, to: Expr): Expr {
		return switch e.expr {
			case EConst(CIdent(s)) if (parent == null && s == name): to;
			case EField({ expr: EConst(CIdent(p)) }, s, _) if (p == parent && s == name): to;
			case _: e.map(rewrite.bind(_, parent, name, to));
		}
	}

	private static function checkDestroy(ct: ClassType): Bool {
		final sc: Null<{ t: Ref<ClassType>, params: Array<Type> }> = ct.superClass;
		if (sc == null) return false;
		for (f in sc.t.get().fields.get()) if (f.name == 'destroy') return true;
		return checkDestroy(sc.t.get());
	}

	private static function checkDI(ct: ClassType): Bool {
		for (i in ct.interfaces) if (i.t.toString() == 'pony.magic.DI') return true;
		return ct.superClass != null && checkDI(ct.superClass.t.get());
	}
	#end

}
