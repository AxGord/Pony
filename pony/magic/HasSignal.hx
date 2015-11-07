/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.magic;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.text.TextTools;
using pony.macro.Tools;
#end

/**
 * HasSignal
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.HasSignalBuilder.build())
#end
interface HasSignal { }

/**
 * HasSignalBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasSignalBuilder {
	macro static public function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var pack = ['pony', 'events'];
		#if !(cpp||windows||android||ios)
		var ext = [ { name:':extern', pos: Context.currentPos() } ];
		#else
		var ext = [];
		#end
		for (f in fields) switch f.kind {
			case FVar(TPath(p),_) if (p.name.substr(0,6) == 'Signal'):
				var on = !(f.name.substr(0, 2) != 'on' && f.name.charAt(3).toLowerCase() == f.name.charAt(3));
					//Context.error('Incorrect signal name: ${f.name}', f.pos);
				var ast = f.access.indexOf(AStatic) == -1 ? [] : [AStatic];
				var eName = 'e' + TextTools.bigFirst(f.name.substr(on ? 2 : 0));
				var tp = { name: 'Event' + p.name.substr(6), pack: pack, params: p.params };
				if (f.meta.checkMeta([":auto", "auto"])) {
					f.kind = FProp('get', 'never', TPath(p));
					fields.push( { name: eName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(
						TPath( tp ),
						{pos:f.pos, expr: ENew(tp, [])}//fail if use EReturn
					)});
					fields.push( { name:'get_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: null, expr: macro return $i { eName }}
					) } );
				} else if (f.meta.checkMeta([":lazy", "lazy"])) {
					f.kind = FProp('get', 'never', TPath(p));
					fields.push( { name: eName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(
						TPath( tp )
					) } );
					var ex:Expr = { pos:f.pos, expr: ENew(tp, []) };
					fields.push( { name:'get_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: null, expr: macro return $i { eName } == null ? $i { eName } = ${ex} : $i { eName }}
					) } );
				}
			case FVar(TPath(p), val) if (f.meta.checkMeta([":bindable", "bindable"])):
				var ast = f.access.indexOf(AStatic) == -1 ? [] : [AStatic];
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
				for (p in m.params) switch p.expr {
					case EConst(CString('notlazy')): lazy = false;
					case EConst(CString('private')): priv = true;
					case _: Context.error('Incorrect bindable parameter', f.pos);
				}
				
				if (lazy) {
					var eventName = 'e'+TextTools.bigFirst(changeName);
					fields.push({ name:'set_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [ { name:'v', type:null } ], ret: null, expr: macro return $i { eventName } == null || v != $i { f.name } && !$i { eventName }.dispatch(v, $i { f.name }, true ) ?  $i { f.name } = v : $i { f.name } }
					) } );
					fields.push( { name: eventName, access:ast.concat([APrivate]), pos:f.pos, kind:FVar(TPath(tp)) } );
					fields.push( { name: changeName, access:ast.concat([priv?APrivate:APublic]), pos:f.pos, kind:FProp(
						'get', 'never', TPath( { pack:pack, name:'Signal2', params:[ TPType(ttp), TPType(ttp) ] } )
					) } );
					fields.push( { name:'get_' + changeName, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [], ret: tps, expr: macro return $i { eventName } == null ? $i { eventName } = ${ex} : $i { eventName }}
					) } );
				} else {				
					fields.push( { name:'set_' + f.name, access: ast.concat([AInline, APrivate]), meta: ext, pos:f.pos, kind:FFun(
						{args: [ { name:'v', type:null } ], ret: null, expr: macro return v != $i { f.name } && !( untyped $i { changeName } :Event2 < $ttp, $ttp > ).dispatch(v, $i { f.name }, true ) ?  $i { f.name } = v : $i { f.name } }
					) } );
					fields.push( { name: changeName, access:ast.concat([priv?APrivate:APublic]), pos:f.pos, kind:FProp(
						'default', 'never',  tps, ex
					) } );
				}
			case _:
		}
		return fields;
	}
}