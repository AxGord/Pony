/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.db.mysql;

#if macro
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Printer;

/**
 * TableMacro
 * @author AxGord <axgord@gmail.com>
 */
class TableMacro {
	
	static public function transExpr(expr:Expr, a:Array<Expr>):Array<Expr> {
		switch expr.expr {
			case EBinop(op, e1, e2):
				
				var o = switch op {
					case OpGt: '>';
					case OpGte: '>=';
					case OpLt: '<';
					case OpLte: '<=';
					case OpEq: '=';
					case OpNotEq: '!=';
					case OpBoolAnd:
						a = transExpr(e1, a);
						a.push(genText(' AND ', expr.pos));
						a = transExpr(e2, a);
						return a;
					case OpBoolOr:
						a = transExpr(e1, a);
						a.push(genText(' OR ', expr.pos));
						a = transExpr(e2, a);
						return a;
					case _: throw 'Unknown operation '+op;
				}
				a = a.concat(parseExpr(e1));
				//var field = takeFieldName(e1);
				
				switch e2.expr {
					case EConst(CIdent(s)) if (s == 'null'):
						switch op {
							case OpEq:
								a.push(genText(' IS NULL', expr.pos));
							case OpNotEq:
								a.push(genText(' IS NOT NULL', expr.pos));
							case _: throw 'Not correct $op operator for null';
						}
					case _:
						a.push(genText(' $o ', expr.pos));
						a = a.concat(parseExpr(e2));
				}
				
			case EParenthesis(e):
				a.push(genText('(', e.pos));
				transExpr(e, a);
				a.push(genText(')', e.pos));
				return a;
				
			case EUnop(Unop.OpNot, _, e):
				a.push(genText('!', e.pos));
				transExpr(e, a);
				return a;
				
			case ECall({expr:EField(e, act),pos:_}, p):
				switch act {
					case 'like':
						if (p.length != 1) throw 'Need 1 argument';
						var field = takeFieldName(e);
						switch p[0].expr {
							case EConst(CIdent(s)):
								a.push(genText('$field LIKE ', expr.pos));
								a.push(macro pony.db.mysql.Table.WhereElement.Value(p[0]));
							case EConst(CInt(s)):
								a.push(genText('$field LIKE $s', expr.pos));
							case EConst(CString(s)):
								a.push(genText('$field LIKE \'$s\'', expr.pos));
							case _: throw 'error';
						}
					case _: 'Unknown action';
				}
				
				
			case _: throw 'Unknown operation '+Std.string(expr.expr);
		}
		return a;
	}
	
	static private function genText(s:String, p:Position):Expr {
		var e:Expr = {expr: EConst(CString(s)), pos: p};
		return macro pony.db.mysql.Table.WhereElement.Text($e);
	}
	
	static private function takeFieldName(e:Expr):String {
		return switch e.expr {
			case EConst(CIdent(s)): '`$s`';
			case _: throw 'Not correct field $e';
		}
	}
	
	static private var printer:Printer = new Printer();
	
	static private function parseExpr(e:Expr):Array<Expr> {
		var a:Array<Expr> = [];
		switch e.expr {
			case EConst(CIdent(s)):
				if (s.charAt(0) == '$') {
					var v:Expr = {expr: EConst(CIdent(s.substr(1))), pos: e.pos};
					a.push(macro pony.db.mysql.Table.WhereElement.Value($v));
				} else {
					a.push(genText('`$s`', e.pos));
				}
			case EConst(CInt(s)):
				a.push(genText(s, e.pos));
			case EConst(CString(s)):
				a.push(genText('\'$s\'', e.pos));
			
			case EBinop(op, e1, e2):
				try {
					var v = ExprTools.getValue(e);
					a.push(genText(Std.string(v), e.pos));
				} catch(_:Dynamic) {
					a = a.concat(parseExpr(e1));
					a.push(genText(printer.printBinop(OpAdd), e.pos));
					a = a.concat(parseExpr(e2));
				}
				
			case EUnop(OpNegBits, false, e):
				a.push(macro pony.db.mysql.Table.WhereElement.Id($e));
				
			case _: throw 'Can\'t parse $e';
		}
		return a;
	}
	
	
}
#end