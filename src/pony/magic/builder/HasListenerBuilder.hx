package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

import pony.ds.Triple;

using pony.macro.Tools;
using pony.text.TextTools;

private typedef Handler = Triple<FunctionArg, FunctionArg, Array<Expr>>;
#end

/**
 * HasListenerBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasListenerBuilder {

	@SuppressWarnings('checkstyle:MethodLength', 'checkstyle:CyclomaticComplexity')
	macro public static function build(): Array<Field> {
		final fields: Array<Field> = Context.getBuildFields();
		final handlers: Map<String, Handler> = [];
		final listen: Array<Expr> = [];
		final unlisten: Array<Expr> = [];
		var hasNew: Bool = false;
		var hasDestroy: Bool = false;
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
			case { name: 'destroy', kind: FFun(f) }:
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
					if (isListen || isOnce) {
						final expr: Null<Expr> = m.params.shift();
						final cond: Null<Expr> = m.params.shift();
						if (expr != null) {
							if (cond != null) {
								listen.push(isOnce ?
									macro if ($cond) $expr.once($i{field.name}) :
									macro if ($cond) $expr.add($i{field.name})
								);
								unlisten.push(macro if ($cond) $expr.remove($i{field.name}));
								switch cond.expr {
									case EBinop(_, { expr: EField({expr: EConst(CIdent(parent))}, s, _) }, _):
										final name: String = 'change${s.bigFirst()}';
										final listenerName: String = '${parent}_${name}Handler';
										listen.push(macro $i{parent}.$name.add($i{listenerName}));
										unlisten.push(macro $i{parent}.$name.remove($i{listenerName}));
										final prevName: String = 'prev${s.bigFirst()}';
										var handler: Null<Handler> = handlers[listenerName];
										if (handler == null) {
											final type: ComplexType = getType(s);
											handler = new Triple({ name: s, type: type }, { name: prevName, type: type }, []);
											handlers[listenerName] = handler;
										}
										handler.c.push(
											macro if ($cond) {
												$i{s} = $i{prevName};
												if (!($cond)) $e{isOnce ? macro $expr.once($i{field.name}) : macro $expr.add($i{field.name})};
											} else {
												$i{s} = $i{prevName};
												if (!($cond)) $expr.remove($i{field.name});
											}
										);

									case EBinop(_, { expr: EConst(CIdent(s)) }, _):
										final name: String = 'change${s.bigFirst()}';
										final listenerName: String = '${name}Handler';
										listen.push(macro $i{name}.add($i{listenerName}));
										unlisten.push(macro $i{name}.remove($i{listenerName}));
										final prevName: String = 'prev${s.bigFirst()}';
										var handler: Null<Handler> = handlers[listenerName];
										if (handler == null) {
											final type: ComplexType = getType(s);
											handler = new Triple({ name: s, type: type }, { name: prevName, type: type }, []);
											handlers[listenerName] = handler;
										}
										handler.c.push(
											macro if ($cond) {
												$i{s} = $i{prevName};
												if (!($cond)) $e{isOnce ? macro $expr.once($i{field.name}) : macro $expr.add($i{field.name})};
											} else {
												$i{s} = $i{prevName};
												if (!($cond)) $expr.remove($i{field.name});
											}
										);
									case _:
										throw 'Unsupported const';
								}
							} else {
								listen.push(isOnce ? macro $expr.once($i{field.name}) : macro $expr.add($i{field.name}));
							}
						} else {
							throw 'Expr not set';
						}
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

		if (!hasDestroy && !ext) {
			if (checkDestroy(Context.getLocalClass().get()))
				fields.push((macro class {
					override public function destroy(): Void {
						super.destroy();
						unlisten();
					}
				}).fields.pop());
			else
				fields.push((macro class {
					public function destroy(): Void unlisten();
				}).fields.pop());
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
	private static function checkDestroy(ct: ClassType): Bool {
		var sc: Null<{t:Ref<ClassType>, params:Array<Type>}> = ct.superClass;
		if (sc != null) {
			for (f in sc.t.get().fields.get()) if (f.name == 'destroy') return true;
			return checkDestroy(sc.t.get());
		} else {
			return false;
		}
	}
	#end

}