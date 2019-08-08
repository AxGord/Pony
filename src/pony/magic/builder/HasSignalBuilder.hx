package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.text.TextTools;

using pony.macro.Tools;
#end

/**
 * HasSignalBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasSignalBuilder {
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var pack = ['pony', 'events'];
		#if (js||flash) //for interfaces work only js or flash
		var ext = [ { name:':extern', pos: Context.currentPos() } ];
		#else
		var ext = [];
		#end
		var destrStatic:Array<Expr> = [];
		var destr:Array<Expr> = [];
		
		for (f in fields) switch f.kind {
			case FProp(g, s, TPath(p), _) if (p.name.substr(0, 6) == 'Signal' && f.meta.checkMeta([":auto", ":lazy"])):
				Context.error(f.name + " - can't be property", f.pos);
			case FVar(TPath(p), _) if (p.name.substr(0, 6) == 'Signal'):
				var on = !(f.name.substr(0, 2) != 'on' && f.name.charAt(3).toLowerCase() == f.name.charAt(3));
				//Context.error('Incorrect signal name: ${f.name}', f.pos);
				var isStatic = f.access.indexOf(AStatic) != -1;
				var ast = !isStatic ? [] : [AStatic];
				var eName = 'e' + TextTools.bigFirst(f.name.substr(on ? 2 : 0));
				var tp = { name: 'Event' + p.name.substr(6), pack: pack, params: p.params };
				var flag = false;
				var a = (isStatic ? destrStatic : destr);
				if (f.meta.checkMeta([":auto"])) {
					flag = true;
					fields.push( { name: eName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(
						TPath( tp ),
						{pos:f.pos, expr: ENew(tp, [])}//fail if use EReturn
					)});
					fields.push( { name:'get_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: null, expr: macro return $i { eName }}
					) } );
					a.push(macro $i { eName }.destroy());
				} else if (f.meta.checkMeta([":lazy"])) {
					flag = true;
					fields.push( { name: eName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(
						TPath( {name: 'Null', pack: [], params: [TPType(TPath(tp))]} )
					) } );
					var ex:Expr = { pos:f.pos, expr: ENew(tp, []) };
					fields.push( { name:'get_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: null, expr: macro return $i { eName } == null ? $i { eName } = ${ex} : $i { eName }}
					) } );
					a.push(macro if ($i { eName } != null) $i { eName }.destroy());
				}
				if (flag) {
					f.kind = FProp('get', 'never', TPath(p));
					f.meta = [];
					a.push(macro @:nullSafety(Off) $i { eName } = null);
				}
				
			case FVar(TPath(p), val) if (f.meta.checkMeta([":bindable", "bindable"])):
				var isStatic = f.access.indexOf(AStatic) != -1;
				var ast = !isStatic ? [] : [AStatic];
				var changeName = 'change' + TextTools.bigFirst(f.name);
				f.kind = FProp('default', 'set', TPath(p), val);
				var ttp = TPath(p);
				var tp = { pack:pack, name:'Event2', params:[ TPType(ttp), TPType(ttp) ] };
				
				var ex:Expr = { pos:f.pos, expr: ENew(tp, []) };
				var tps = TPath( { pack:pack, name:'Signal2', params:[ TPType(TPath(p)), TPType(TPath(p)) ] });
				var m = f.meta.getMeta(':bindable');
				if (m == null) m = f.meta.getMeta('bindable');
				
				var lazy = true;
				var priv = false;
				var setcontroll = false;
				for (p in m.params) switch p.expr {
					case EConst(CString('notlazy')): lazy = false;
					case EConst(CString('private')): priv = true;
					case EConst(CString('setcontroll')): setcontroll = true;
					case _: Context.error('Incorrect bindable parameter', f.pos);
				}
				
				var a = (isStatic ? destrStatic : destr);
				var eventName = 'e'+TextTools.bigFirst(changeName);
				fields.push( { name: changeName, access:ast.concat([priv?APrivate:APublic]), pos:f.pos, kind:FProp(
					'get', 'never', TPath( { pack:pack, name:'Signal2', params:[ TPType(ttp), TPType(ttp) ] } )
				) } );
				if (lazy) {
					fields.push({ name:'set_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						setcontroll ?
							{args: [ { name:'v', type:null } ], ret: null, expr: macro return $i { eventName } == null || v != $i { f.name } && !$i { eventName }.dispatch(v, $i { f.name }, true ) ?  $i { f.name } = v : $i { f.name } }
							:
							{args: [ { name:'v', type:null } ], ret: null, expr: macro { if ($i { eventName } == null || v != $i { f.name }) {var prev = $i { f.name }; @:nullSafety(Off) $i { eventName }.dispatch($i { f.name } = v, prev, true );} return $i { f.name }; } }
					) } );
					fields.push( { name: eventName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(
						TPath( {name: 'Null', pack: [], params: [TPType(TPath(tp))]} )
					) } );
					fields.push( { name:'get_' + changeName, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: tps, expr: macro return $i { eventName } == null ? $i { eventName } = ${ex} : @:nullSafety(Off) $i { eventName }}
					) } );
					a.push(macro if ($i { eventName } != null) @:nullSafety(Off) $i { eventName }.destroy());
					a.push(macro @:nullSafety(Off) $i { eventName } = null);
				} else {
					fields.push( { name:'set_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						setcontroll ?
							{args: [ { name:'v', type:null } ], ret: null, expr: macro return v != $i { f.name } && !( untyped $i { changeName } :Event2 < $ttp, $ttp > ).dispatch(v, $i { f.name }, true ) ?  $i { f.name } = v : $i { f.name } }
							:
							{args: [ { name:'v', type:null } ], ret: null, expr: macro { if (v != $i { f.name }) {var prev = $i { f.name }; ( untyped $i { changeName } :Event2 < $ttp, $ttp > ).dispatch($i { f.name } = v, prev, true ); } return $i { f.name }; }}
					) } );
					fields.push( { name: eventName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(TPath(tp), ex) } );
					fields.push( { name:'get_' + changeName, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: tps, expr: macro return $i { eventName }}
					) } );
					a.push(macro $i { eventName }.destroy());
					a.push(macro @:nullSafety(Off) $i { eventName } = null);
				}
			case _:
		}
		if (destrStatic.length > 0) {
			fields.push({name:'destroyStaticSignals', access: [APrivate, AStatic], pos:Context.currentPos(),meta:[],kind:FFun(
				{args: [], ret: null, expr: macro $b{destrStatic}}
			)});
		}
		if (destr.length > 0) {
			var acc = [APrivate];
			var b = false;
			var cl = Context.getLocalClass().get();
			while (cl.superClass != null) {
				cl = cl.superClass.t.get();
				for (f in cl.fields.get()) if (f.name == 'destroySignals') {
					b = true;
					acc.push(AOverride);
					destr.unshift(macro super.destroySignals());
					break;
				}
				if (b) break;
			}
			fields.push({name:'destroySignals', access: acc, pos:Context.currentPos(),meta:[],kind:FFun(
				{args: [], ret: null, expr: macro $b{destr}}
			)});
		}
		return fields;
	}

}