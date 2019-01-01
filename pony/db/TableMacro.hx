package pony.db ;

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
								a.push(macro pony.db.Table.WhereElement.Value(p[0]));
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
		return macro pony.db.Table.WhereElement.Text($e);
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
					a.push(macro pony.db.Table.WhereElement.Value($v));
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
				} catch (_:Dynamic) {
					var o = switch op {
						case OpGt: '>';
						case OpGte: '>=';
						case OpLt: '<';
						case OpLte: '<=';
						case OpEq: '=';
						case OpNotEq: '!=';
						case OpBoolAnd, OpAnd: 'AND';
						case OpBoolOr, OpOr: 'OR';
						case _: throw 'Unknown operation '+op;
					}
					a = a.concat(parseExpr(e1));
					a.push(genText(' '+o+' ', e.pos));
					a = a.concat(parseExpr(e2));
				}
				
			case EUnop(OpNegBits, false, e):
				a.push(macro pony.db.Table.WhereElement.Id($e));
				
			case _: throw 'Can\'t parse $e';
		}
		return a;
	}
	
	
}
#end