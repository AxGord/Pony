/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.magic;

/**
 * ExtendedProperties
 * @author AxGord <axgord@gmail.com>
 */
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import pony.macro.Tools;
using Lambda;
#end

#if !macro
@:autoBuild(pony.magic.ExtendedPropertiesBuilder.hidden()) 
@:autoBuild(pony.magic.ExtendedPropertiesBuilder.f2p()) 
interface ExtendedProperties { }
#end

class ExtendedPropertiesBuilder {
	
	#if macro
		inline private static var hprefix:String = '_';
		private static var used:Map<Int, Array<String>>;
		private static var repList:Array<String> = [];
		private static var lvl:Int;
	#end
	
	macro public static function hidden():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var fs:Array<Field> = [];
		var funs:Array<String> = [];
		for (f in fields) if (f.kind.match(FFun(_))) funs.push(f.name);
		for (f in fields) {
			switch f.kind {
				case FProp('_', s, t, e):
					f.kind = FProp('get', s, t);
					fs.push(f);
					fs.push( { kind: FVar(t, e), name: hprefix + f.name, pos: f.pos, access: f.access.indexOf(AStatic) != -1 ? [AStatic] : [] } );
					repList.push(f.name);
					var fn = 'get_' + f.name;
					if (funs.indexOf(fn) == -1) {
						fs.push( { kind: FFun({
							args: [],
							ret: t,
							expr: macro return $i{ hprefix + f.name }
						}), name: fn, pos: f.pos, access: f.access.indexOf(AStatic) != -1 ? [AStatic, APrivate, AInline] : [APrivate, AInline]});
					}
				case _: fs.push(f);
			}
		}
		used = new Map();
		for (f in fs) switch f.kind {
			case FFun(f):
				lvl = 0;
				used.set(lvl, [for (a in f.args) a.name]);
				f.expr = ExprTools.map(f.expr, repl);
			case FVar(_, e) if (e != null):
				e.expr = ExprTools.map(e, repl).expr;
			case _:
		}
		return fs;
	}
	#if macro
	
	inline private static function lvlused():Array<String> return used.exists(lvl) ? used.get(lvl) : [];
	
	private static function repl(e:Expr):Expr {
		var curRepl = repList.copy();
		for (a in used) for (b in a) curRepl.remove(b);
		
		switch e.expr {
			case EVars(args):
				var a:Array<String> = lvlused();
				for (arg in args) if (repList.indexOf(arg.name) != -1) a.push(arg.name);
				used.set(lvl, a);
			case EFunction(name, f):
				var a:Array<String> = lvlused();
				if (name != null) a.push(name);
				used.set(lvl, a);
			case _:
		}
		lvl++;
		
		switch e.expr {
			case EFunction(_, f):
				var a:Array<String> = lvlused();
				for ( arg in f.args ) if (repList.indexOf(arg.name) != -1) a.push(arg.name);
				used.set(lvl, a);
			case _:
		}
		
		e = ExprTools.map(switch e.expr {
			case EConst(CIdent(s)) if (curRepl.indexOf(s) != -1): {
				pos: e.pos,
				expr: EField( { pos: e.pos, expr: EConst(CIdent('this')) }, hprefix+s)
			};
			case EField({pos:_, expr: EConst(CIdent('this'))}, s): {
				pos: e.pos,
				expr: EField( { pos: e.pos, expr: EConst(CIdent('this')) }, hprefix+s)
			};
			case _: {pos: e.pos, expr: e.expr};
		}, repl);
		used.remove(lvl);
		lvl--;
		return e;
	}
	#end
	
	#if macro
	static private var pmeta = [':toProp', 'toProp', ':prop', 'prop'];
	#end
	
	macro static public function f2p():Array<Field> {
		var fs:Array<Field> = [];
		for (f in Context.getBuildFields()) {
			switch f.kind {
				case FFun(fun) if (Tools.checkMeta(f.meta, pmeta)):
					var access:Array<Access> = f.access.copy();
					access.remove(AInline);
					fs.push( { kind: FProp('get', 'never', fun.ret), name: f.name, pos: f.pos, access: access } );
					var access:Array<Access> = [];
					if (f.access.indexOf(AStatic) != -1) access.push(AStatic);
					if (f.access.indexOf(AInline) != -1) access.push(AInline);
					fs.push( { kind: f.kind, name: 'get_' + f.name, pos: f.pos, access: access } );
				case FVar(t, e) if (Tools.checkMeta(f.meta, pmeta)):
					var access:Array<Access> = f.access.copy();
					access.remove(AInline);
					fs.push( { kind: FProp('get', 'never', t), name: f.name, pos: f.pos, access: access } );
					var access:Array<Access> = [];
					if (f.access.indexOf(AStatic) != -1) access.push(AStatic);
					if (f.access.indexOf(AInline) != -1) access.push(AInline);
					fs.push( { kind: FFun({args: [], params: [], ret: t, expr: macro return $e}), name: 'get_' + f.name, pos: f.pos, access: access } );
				case _: fs.push(f);
			}
		}
		return fs;
	}
}
