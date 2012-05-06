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

package pony.magic;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;

using pony.macro.MacroExtensions;
#end
import haxe.Serializer;

using pony.Ultra;

/**
 * Create polymorph function.
 * @author MrCheater
 * @author AxGord
 */
class PolymorphFunction implements Dynamic
{
	static public function create(args:Array<Dynamic>)
	{
		var hashTable = new Hash<Dynamic>();
		for (i in args) hashTable.set(i.sig, i.func);
		return Reflect.makeVarArgs(
		function (vargs:Array<Dynamic>):Dynamic
			{
				var f:Dynamic = hashTable.get({
					var signature = "";
					for (i in vargs)
						signature += serializer(i);
					signature;
				});
				
				if (f == null) {
					
					for (i in 0...vargs.length) {
						var signature = "";
						for (j in 0...vargs.length) {
							if (j < i+1)
								signature += 'Dynamic';
							else
								signature += serializer(i);
						}
						if (hashTable.exists(signature)) {
							f = hashTable.get(signature);
							break;
						}
					}
					
					if (f == null) throw 'Wrong arguments:' + {
						var signature = "";
						for (i in vargs) signature += ' ' + serializer(i);
						signature;
					};
					
				}
				
				
				return Reflect.callMethod(null, f, vargs);
			}
		);
	}
	
	@:macro public static function parse( args:Expr ) : Expr 
	{
		/*var new_expr:Expr = { expr:ECall( { expr:EField( { expr:EConst(CType("PolymorphFunction")), pos:Context.currentPos() }, "create"), pos:Context.currentPos() }, [
			{expr:ECall( { expr:EField( { expr:EConst(CType("PolymorphFunction")), pos:Context.currentPos() }, "parseArgs"), pos:Context.currentPos() }, [
				args
			]), pos:Context.currentPos()}
		]), pos:Context.currentPos()};*/
		var new_expr:Expr = 'pony.magic.PolymorphFunction.create'.typeCall(['pony.magic.PolymorphFunction.parseArgs'.typeCall([args])]);
		return new_expr;
	}
	
	@:macro public static function parseArgs(varg:Expr) : Expr {
		var arrExpr = new Array<Expr>();
		switch(varg.expr)
		{
			case EArrayDecl(args):
			
			for (arg in args)	
			{
				var sig = "";
				switch(arg.expr)
				{
					case EFunction(Void, fbody):
			
					for (i in fbody.args)
					{
						switch(i.type)
						{
							case ComplexType.TFunction(Void, Void): sig += 'Function';
							case ComplexType.TPath(c):
								sig += c.name;
								if (c.name == "Array")
								{
									sig += "<";
									for (i in c.params)
									{
										
										switch(i)
										{
											case TypeParam.TPType(c):
												switch(c)
												{
													case ComplexType.TPath(c):
														sig += c.name;
													case ComplexType.TAnonymous(c):
														sig += "{";
														c.sort(function(a, b) { 
															if (a.name == b.name) return 0;
															if (a.name > b.name) return 1;
															else return -1;
														});
														for (i in c) 
														switch(i.kind)
														{
															case FieldType.FVar(s, Void):
															switch(s)
															{
																case ComplexType.TPath(t):
																	sig += t.name;
																default:
															}
															default:
														}
														sig += "}";
													default:
												}
											default:
										}
									}
									sig += ">";
								}
								//trace("!!!"+c.name);
							case ComplexType.TAnonymous(c):
								sig += "{";
								c.sort(function(a, b) { 
									if (a.name == b.name) return 0;
									if (a.name > b.name) return 1;
									else return -1;
								});
								for (i in c) 
								switch(i.kind)
								{
									case FieldType.FVar(s, Void):
									switch(s)
									{
										case ComplexType.TPath(t):
											sig += t.name;
										default:
									}
									default:
								}
								sig += "}";
							default:	
						}
					}
				default:	
				}
			//trace(sig);
			arrExpr.push( { expr : EObjectDecl([ { field:"func", expr:arg }, { field:"sig", expr: { expr : EConst(CString(sig)), pos : Context.currentPos() } } ]), pos : Context.currentPos() } );
			}
			default:
		}
		return { expr :EArrayDecl(arrExpr), pos : Context.currentPos()} ; 	
	}

	
	
	static public function serializer(arg:Dynamic)
	{
		var v = Type.typeof(arg);
		
		switch(v)
		{
			case ValueType.TBool:		return "Bool";
			case ValueType.TClass(c):	return 
			{
				if (c == Array) 
				{
					
					var tmp = "Array";
					var arr:Array<Dynamic> = arg;
					var arrType = (arr[0] != null ? serializer(arr[0]) : "Dynamic");
					for (i in 1...arr.length) 
						if ( serializer(arr[i]) != arrType )
						{
							arrType = "Dynamic";
							break;
						}
					tmp += "<" + arrType + ">";
					tmp;
				} else
					Type.getClassName(c);
			}
			case ValueType.TEnum(c):	return Type.getEnumName(c).split('.').last();
			case ValueType.TFloat:		return "Float";
			case ValueType.TInt:		return "Int";
			case ValueType.TObject:		return  
			{
				var tmp = "{";
				var args = Reflect.fields(arg);
				args.sort(
					function(a, b) { 
						if (a == b) return 0;
						if (a > b) return 1;
						else return -1;
					}
				);
				for (i in args ) tmp += serializer(Reflect.field(arg, i));
				tmp += "}";
				tmp;
			}
			case ValueType.TFunction: return "Function";
			default:
				throw "Error type!";
				return null;
		}
	}
}