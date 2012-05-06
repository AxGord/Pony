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

package pony.macro;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using pony.macro.MacroExtensions;
using Reflect;
using Type;
using pony.Ultra;

/**
 * @author AxGord
 */
class MacroExtensions {
	public static var pos:Position = null;
	
	public static function error(s:String):Void {
		Context.field('error')(s, getPos());
	}
	
	public static function getPos():Position {
		return if (MacroExtensions.pos == null)
			Context.field('currentPos')();
		else
			MacroExtensions.pos;
	}
	
	public static function fieldsType(s:String):Expr {
		var a:Array<String> = s.split('.');
		var e:Expr = null;
		while (a.length > 2)
			e = EField((e == null)?EConst(CIdent(a.shift())).expr():e, a.shift()).expr();
		e = EType(e, a.shift()).expr();
		e = EField(e, a.shift()).expr();
		return e;
	}
	
	public static function typeCall(s:String, params:Array<Expr>):Expr {
		return ECall(s.fieldsType(), params).expr();
	}
	
	public static function typeNew(s:String, params:Array<Expr>):Expr {
		return ENew(s.typeType(), params).expr();
	}
	
	public static function typeType(s:String):TypePath {
		var a:Array<String> = s.split('.');
		var n:String = a.pop();
		return { sub: null, params: [], pack: a, name: n };
	}
	
}


/**
 * @author AxGord
 */

class ExprExtensions {
	

	
	public static function string(e:Expr):String {
		if (e == null) return 'null';
		return switch (e.expr) {
			
			case ECall(e, ps):
				var a:Array<String> = [];
				for (p in ps)
					a.push(p.string());
				e.string() + '('+ a +')';
			case EConst(c): c.toString();
			case EField(e, f): e.string() + '.' + f;
			case EFunction(n, f): 'function' + (if (n != null) ' '+n else '') + '(){}';
			case EArrayDecl(a):
				var s:String = '[';
				var f:Bool = true;
				for (e in a) {
					if (f)
						f = false;
					else
						s += ', ';
					s += e.string();
				}
				s + ']';
			case EBlock(a):
				var s:String = '{ ';
				for (e in a)
					s += e.string() + '; ';
				s + ' }';
			case EVars(a):
				var s:String = 'var';
				var f:Bool = true;
				for (e in a) {
					if (f)
						f = false;
					else
						s += ',';
					s += ' '+e.name + ':' + e.type.string() + ' = '+ e.expr.string();
				}
				s;
			case EBinop(op, e1, e2): e1.string() + op.string() + e2.string() + ' ';
			case ETry(e, c): 'try ' + e.string() + ' catch (' + c[0].name + ':' + c[0].type.string() + ') ' + c[0].expr.string();
			case EReturn(e): 'return ' + e.string();
			default: 'ComingSoon... ';
		}
		
	}
	
	static public function isVar(e:Expr, ?v:String):Bool {
		return switch(e.expr) {
						case EConst(c):
							switch (c) {
								case CIdent(s): v == null || s == v;
								default: false;
							}
						default: false;
					};
	}
	
	static public function isConst(e:Expr):Bool {
		return switch(e.expr) {
						case EConst(c): true;
						default: false;
					};
	}
	
}

/**
 * @author AxGord
 */

class ExprDefExtensions
{
	
	public static function replace(e:ExprDef, search:String, str:String):ExprDef {
		return switch (e) {
			case EIf(c, i, e):
				var nc:Expr = replace(c.expr, search, str).expr();
				var ni:Expr = replace(i.expr, search, str).expr();
				var ne:Expr = null;
				if (e != null)
					ne = replace(e.expr, search, str).expr();
				EIf(nc, ni, ne);
			case EBlock(a):
				var na:Array<Expr> = [];
				for (e in a)
					na.push(replace(e.expr, search, str).expr());
				EBlock(na);
			case EBinop(op, e1, e2):
				var ne1:Expr = replace(e1.expr, search, str).expr();
				var ne2:Expr = replace(e2.expr, search, str).expr();
				EBinop(op, ne1, ne2);
			case EReturn(e):
				EReturn(replace(e.expr, search, str).expr());
			case EConst(c):
				switch (c) {
					case CIdent(s):
						if (s == search) {
							EConst(CIdent(str));
						} else
							e;
					default: e;
				}
			default: e;
		}
	}
	
	static public function expr(e:ExprDef):Expr {
		return if (MacroExtensions.pos == null)
			{ expr: e, pos: Context.field('currentPos')() };
		else
			{ expr: e, pos: MacroExtensions.pos };
	}

	static public function block(e:ExprDef):Array<Expr> {
		switch (e) {
			case EBlock(a): return a;
			default: throw 'This is not block';
		}
	}
	
	
	static public function etry(e:ExprDef):{e : Expr,catches : Array<{ type : ComplexType, name : String, expr : Expr}>} {
		switch (e) {
			case ETry(t, c): return {e: t, catches: c};
			default: throw 'This is not try';
		}
	}
	
	static public function funcName(e:ExprDef):String {
		switch (e) {
			case EFunction(name, Void): return name;
			default: throw 'This is not function';
		}
	}
	
	static public function func(e:ExprDef):Function {
		switch (e) {
			case EFunction(Void, f): return f;
			default: throw 'This is not function';
		}
	}
	
	static public function vars(e:ExprDef): Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> {
		switch (e) {
			case EVars(a): return a;
			default: throw 'This is not vars';
		}
	}
	
	static public function call(e:ExprDef):Expr {
		switch (e) {
			case ECall(e, Void): return e;
			default: throw 'This is not call';
		}
	}
	
	static public function callParams(e:ExprDef):Array<Expr> {
		switch (e) {
			case ECall(Void, p): return p;
			default: throw 'This is not call';
		}
	}
	
	static public function const(e:ExprDef):Constant {
		switch (e) {
			case EConst(c): return c;
			case EField(ex, Void): return const(ex.expr);
			default: throw 'This is not constant, this is: '+name(e);
		}
	}
	
	static public function name(e:ExprDef):String {
		return switch (e) {
			case EConst(Void): 'const';
			case EField(Void, Void): 'field';
			case ECall(Void, Void): 'call';
			default: 'unknown';
		}
	}
	
	static public function callName(e:ExprDef):String {
		return e.call().expr.const().ident();
	}
	
	static public function binop(e:ExprDef):{op:Binop, e1:Expr, e2:Expr} {
		switch (e) {
			case EBinop(op, e1, e2): return {op: op, e1: e1, e2: e2};
			default: throw 'This is not binop';
		}
	}
	
	static public function ein(e:ExprDef):{e1:Expr, e2:Expr} {
		switch (e) {
			case EIn(e1, e2): return {e1: e1, e2: e2};
			default: throw 'This is not in';
		}
	}
	
	static public function euntyped(e:ExprDef):Expr {
		switch (e) {
			case EUntyped(e): return e;
			default: throw 'This is not untyped';
		}
	}
	
	static public function field(e:ExprDef):{e:Expr, f:String} {
		switch (e) {
			case EField(e, field): return {e: e, f:field};
			default: throw 'This is not field';
		}
	}
	
	static public function parentthesis(e:ExprDef):Expr {
		switch (e) {
			case EParenthesis(e): return e;
			default: throw 'This is not parentthesis';
		}
	}
	
}

/**
 * @author AxGord
 */

class ConstantExtensions {
	
	static public function ident(c:Constant):String {
		switch (c) {
			case CIdent(s): return s;
			default: throw 'This is not ident';
		}
	}
	
	static public function type(c:Constant):String {
		switch (c) {
			case CType(s): return s;
			default: throw 'This is not type';
		}
	}
	
	static public function string(c:Constant):String {
		switch (c) {
			case CString(s): return s;
			default: throw 'This is not string';
		}
	}
	
	static public function toString(c:Constant):String {
		switch (c) {
			case CString(s): return "'" + s + "'";
			case CType(s): return s;
			case CIdent(s): return s;
			case CInt(s): return s;
			default: throw 'Sorry';
		}
	}
	
}

/**
 * @author AxGord
 */

class TypeExtensions {
	
	
	public static function inst(t:Type):ClassType {
		switch (t) {
			case TInst(t, pony): return t.get();
			default: throw 'This is not inst';
		}
	}
	
	public static function fun(t:Type):{args : Array<{ t : Type, opt : Bool, name : String}>, ret : Type} {
		switch (t) {
			case TFun(args, ret): return {args: args, ret: ret};
			default: throw 'This is not funtion';
		}
	}
	
	public static function toComplexType(t:Type):ComplexType {
		return switch (t) {
			case TDynamic(Void): MacroTypes._dynamic;
			case TInst(t, Void): MacroTypes.getTPath(t.get().name, t.get().pack);
			case TEnum(t, Void): MacroTypes.getTPath(t.get().name, t.get().pack);
		case TAnonymous(fields): MacroTypes._dynamic;//todo
			/*
			var a:Array<Field> = [];
			for (f in fields)
				a.push( {
					pos: f.pos,
					name: f.name,
					meta: [],
					kind: FVar(toComplexType(f.type), null),
					doc: null,
					access: []
				});
			a;*/
			case TType(t, Void):  MacroTypes.getTPath(t.get().name, t.get().pack);
		default:
			trace(t);
			throw 'todo';
		}
	}
	
}

/**
 * @author AxGord
 */

class FieldTypeExtensions {
	
	
	public static function fun(t:FieldType):Function {
		switch (t) {
			case FFun(f): return f;
			default: throw 'This is not function';
		}
	}
	
	
}

/**
 * @author AxGord
 */

class ComplexTypeExtensions {
	
	public static function string(t:ComplexType):String {
		return switch (t) {
			case TPath(p): p.name;
			default: 'ComingSoon...';
		}
	}
	
	public static function typePath(t:ComplexType):TypePath {
		switch (t) {
			case TPath(p): return p;
		default: //throw 'This is not TypePath';
			return { sub: null, params:[], pack: [], name: 'Dynamic' };
		}
	}
	
	
}

/**
 * @author AxGord
 */

class BinOpExtensions {
	
	public static function string(b:Binop):String {
		return switch (b) {
			case OpAssign: ' = ';
			default: ' $ ';
		}
	}
	
}