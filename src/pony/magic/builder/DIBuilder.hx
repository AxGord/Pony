package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type.ClassType;
import haxe.macro.TypeTools;

using Lambda;
using haxe.macro.ComplexTypeTools;
using pony.macro.Tools;
#end

/**
 * DIBuilder
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:CyclomaticComplexity', 'checkstyle:MethodLength')
final class DIBuilder {

	private static inline final UNEXPECTED_ERROR: String = 'Unexpected error';
	private static inline final DI: String = 'pony.magic.DI';
	private static inline final WR: String = 'pony.magic.WR';
	private static final diList: Array<String> = [];

	macro public static function build(): Array<Field> {
		final localClass: ClassType = Context.getLocalClass().get();
		final isExt: Bool = !localClass.interfaces.exists(f -> f.t.toString() == DI);
		if (isExt) diList.push(Context.getLocalClass().toString());
		final ctp: TypePath = @:privateAccess TypeTools.toTypePath(localClass, []);
		final ct: ComplexType = TPath(ctp);
		final fields: Array<Field> = Context.getBuildFields();
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
		final destructor: Null<Field> = fields.find(f -> f.name == 'destroy');
		final loads: Array<Expr> = [];
		final creates: Array<Expr> = [];
		final blocks: Array<Expr> = [];
		final destroys: Array<Expr> = [isExt ? macro super.destroy() : macro provider.destroy()];
		for (field in fields) switch field.kind {
			case FVar(t, e) if (t != null && field.meta.checkMeta([':service'])):
				if (isExt && localClass.superClass.t.get().fields.get().exists(f -> f.name == field.name))
					fields.remove(field);
				else
					blocks.unshift(macro $i{field.name} = provider.get($v{field.name}));
				if (e != null) {
					switch e.expr {
						case ENew(t, args):
							final t: ComplexType = TPath(t);
							switch t.toType() {
								case TInst(inst, _) if (diList.contains(inst.toString()) || inst.get().interfaces.exists(f -> f.t.toString() == DI)):
									loads.push(macro provider.load($v{field.name}));
									destroys.push(macro $i{field.name}.destroy());
									creates.push(macro tasks.add());
									final cr = if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
										macro $i{t.toString()}.create(provider, instance -> {
											provider.set($v{field.name}, instance);
											instance.waitReady(tasks.end);
										});
									else
										macro $i{t.toString()}.create(provider, instance -> {
											provider.set($v{field.name}, instance);
											tasks.end();
										});
									switch cr.expr {
										case ECall(_, params): for (arg in args) params.push(arg);
										case _: throw UNEXPECTED_ERROR;
									}
									creates.push(cr);
								case _:
									loads.push(macro provider.set($v{field.name}, $e));
							}
						case _: throw 'Not supported';
					}
					field.kind = FVar(t, null);
				} else {
					switch t.toType() {
						case TInst(inst, _) if (diList.contains(inst.toString()) || inst.get().interfaces.exists(f -> f.t.toString() == DI)):
							creates.push(macro tasks.add());
							if (inst.get().interfaces.exists(f -> f.t.toString() == WR))
								creates.push(macro provider.waitReady($v{field.name}, instance -> instance.waitReady(tasks.end)));
							else
								creates.push(macro provider.waitReady($v{field.name}, tasks.end));
						case _: // skip
					}
				}
			case _:
		}
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
						if (!isExt) lines.unshift(macro this.provider = provider);
					case _: throw UNEXPECTED_ERROR;
				}
			case _: throw UNEXPECTED_ERROR;
		}
		if (destructor != null) switch destructor.kind {
			case FFun(fun):
				fun.expr = fun.expr.replaceToBlock();
				switch fun.expr.expr {
					case EBlock(lines): lines.unshift(macro $b{destroys});
					case _: throw UNEXPECTED_ERROR;
				}
			case _: throw UNEXPECTED_ERROR;
		} else {
			if (isExt)
				fields.push((macro class {
					override public function destroy(): Void $b{destroys};
				}).fields.pop());
			else
				fields.push((macro class {
					public function destroy(): Void $b{destroys};
				}).fields.pop());
		}
		if (!isExt) fields.unshift((macro class {
			private final provider: pony.ServiceProvider;
		}).fields.pop());
		return fields;
	}

}