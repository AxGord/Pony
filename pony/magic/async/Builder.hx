/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.magic.async;

#if macro
import pony.magic.async.Async;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import pony.macro.MacroTool;
import pony.macro.MacroTypes;
import pony.macro.MacroExtensions;

using pony.Ultra;
using Lambda;
using pony.macro.MacroExtensions;
#end

/**
 * ...
 * @author AxGord
 */

class Builder
{
	@:macro public static function buildAsyncAuto():Array<Field> {
		var m:Metadata = (Context.getLocalClass().get().meta.get());
		var onlyAsync:Bool = false;
		var all:Bool = (m.exists(function(d)
			if (d.name.toLowerCase() == 'AsyncAutoAll'.toLowerCase()) {
				onlyAsync = d.params.exists(function(e:Expr) return e.expr.const().string().toLowerCase() == 'onlyAsync'.toLowerCase());
				return true;
			} else return false));
		var fields:Array<Field> = Context.getBuildFields();
		
		validateProp(fields);
		
		
		fields = addAsync(fields, all, onlyAsync);
		
		fields = genSuper(fields);
		/*
		trace('-----'+Context.getLocalClass()+'-----');
		for (f in fields)
			trace(f.name);
		trace('-----End-----');
		*/
		genFieldsList(fields);
		return async(fields);
	}
	
	@:macro public static function buildAsyncAutoAll():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		validateProp(fields);
		fields = addAsync(fields, true, false);
		fields = genSuper(fields);
		genFieldsList(fields);
		return async(fields);
	}
	
	#if macro
	
	public static function validateProp(fields:Array<Field>):Void {
		for (f in fields) switch (f.kind) {
			case FProp(get, set, Void, Void):
				if (get != 'null' && get != 'get' + f.name.bigFirst())
					Context.error('Not correct name for getter. Name can be '+' get' + f.name.bigFirst()+' or null.', f.pos);
				if (set != 'null' && set != 'set' + f.name.bigFirst())
					Context.error('Not correct name for setter. Name can be '+' set' + f.name.bigFirst()+' or null.', f.pos);
			default:
		}
	}
	
	public static function addAsync(fields:Array<Field>, all:Bool, onlyAsync:Bool):Array<Field> {
		var newFields:Array<Field> = [];
		//Async.allClFields = [];
		for (f in fields) {
			switch (f.kind) {
				case FFun(Void):
					if (!onlyAsync || f.meta.exists(function(m) return m.name.toLowerCase() == 'NotAsyncAuto'.toLowerCase()) || f.name.substr(f.name.length - 5) == 'Async') {
						//Async.allClFields.push(f.name);
						newFields.push(f);
					}
					if (all || f.meta.exists(function(m) return m.name.toLowerCase() == 'AsyncAuto'.toLowerCase()))
					if (!f.meta.exists(function(m) return m.name.toLowerCase() == 'NotAsyncAuto'.toLowerCase()))
					if (!fields.exists(function(e) { return e.name == f.name + 'Async'; } ) && f.name.substr(f.name.length - 5) != 'Async') {
						var fun:Function;
						switch (f.kind) {
							case FFun(ff): fun = ff;
							default: continue;
						}
						
						var md:Metadata = [];
						for (m in f.meta)
							if (m.name.toLowerCase() != 'AsyncAuto'.toLowerCase() && m.name.toLowerCase() != 'remove' && m.name.toLowerCase() != 'lock')
								md.push(m);
						md.push({
								pos: f.pos,
								params: [],
								name: 'Async'
							});
						//Async.allClFields.push( f.name + 'Async');
						var naccess:Array<Access> = f.access.copy();
						naccess.remove(AInline);
						newFields.push( {
							pos: f.pos,
							name: f.name + 'Async',
							meta: md,
							kind: FFun( {
								ret: MacroTypes._void,
								params: fun.params,
								expr: fun.expr,
								args: fun.args.concat([
									{value: null, type: MacroTypes._function, opt: true, name: 'ok' },
									{value: null, type: MacroTypes._function, opt: true, name: 'error' }
								])
							} ),
							access: naccess,
							doc: null
						});
					}
					
				case FProp(Void, Void, Void, Void):
					if (!onlyAsync) {
						//Async.allClFields.push(f.name);
						newFields.push(f);
					}
				default:
					//Async.allClFields.push(f.name);
					newFields.push(f);
			}
			
		}
		return newFields;
	}
	
	public static function genFieldsList(fields:Array<Field>):Void {
		Async.allClFields = [];
		for (f in fields)
			Async.allClFields.push(f.name);
	}
	
	public static function async(fields:Array<Field>):Array<Field> {
		Async.cl = Context.getLocalClass().get();
		for (f in fields)
			if (f.meta.exists(function(m) return m.name.toLowerCase() == 'Async'.toLowerCase())) {
				var fun:Function = f.kind.fun();
				var mt:MacroTool = MacroTool.create({
					var __ok__:Dynamic->Void = null;
					var __error__:Dynamic->Void = null;
					var __rootok__:Dynamic->Void = null;
					__rootok__ = __ok__ = function(r:Dynamic) {
						//trace(r);
						__rootok__ = __ok__/* = __error__*/ = function(r:Dynamic) throw "'ok' called";
						__error__ = pony.magic.async.AsyncRT.error;
						if (ok != null)
							ok(r);
					};
					__error__ = function(r:Dynamic) {
						//trace('Error: '+r);
						__rootok__ = __ok__/* = __error__ */= function(r:Dynamic) { trace(r); throw "'error' called"; };
						__error__ = pony.magic.async.AsyncRT.error;
						if (error != null)
							error(r);
						else
							throw r;
					};
				});
				var b:Array<Expr> = mt.result.expr.block().clone();
				b.push(Async.blocks(fun.expr.expr.block().clone()));
				//b = b.concat(Async.blocks(fun.expr.expr.block().clone()).expr.etry().e.expr.block());
				//if (f.name == 'tagAsync')
				//trace(Async.blocks(fun.expr.expr.block().clone()).expr.etry().e.string());
				//trace(EBlock(b).expr().string());
				f.kind = FFun( {
					ret: fun.ret,
					params: fun.params,
					expr: EBlock(b).expr(),
					args: fun.args
				});
			}
		
		return fields;
	}
	
	public static function genSuper(fields:Array<Field>):Array<Field> {
		var newFields:Array<Field> = fields.copy();
		for (f in fields) switch (f.kind) {
			case FFun(fun):
				if (f.name.substr(f.name.length - 5) == 'Async' && f.meta.exists(function(m) return m.name.toLowerCase() == 'BuildSuper'.toLowerCase())) {
					MacroExtensions.pos = f.pos;
					newFields.push( { pos: f.pos, name: 'super_' + f.name, meta: f.meta, kind: FFun(fun), doc: null, access: f.access } );
					var params:Array<Expr> = [];
					for (arg in fun.args)
						params.push(EConst(CIdent(arg.name)).expr());
					f.kind = FFun( { ret: fun.ret, params: fun.params, args: fun.args, expr: EBlock([EReturn(ECall(EConst(CIdent('super_' + f.name)).expr(), params).expr()).expr()]).expr() } );
				}
			default:
		}
		return newFields;
	}
	
	#end
}