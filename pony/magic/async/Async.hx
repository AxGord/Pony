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
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import pony.macro.MacroTool;
import pony.macro.MacroTypes;
import pony.macro.MacroExtensions;

using pony.Ultra;
using Lambda;
using pony.macro.MacroExtensions;
using Reflect;
#end

/**
 * Asyncronization
 * @author AxGord
 */

class Async
{
	#if macro
	private static inline var rt:String = 'pony.magic.async.AsyncRT';
	
	public static var cl:ClassType;
	public static var allClFields:Array<String> = [];
	private static var dtype:ComplexType = MacroTypes._dynamic;
	private static var ftype:ComplexType = TFunction([ MacroTypes._dynamic ], MacroTypes._void);
	private static var fvoidtype:ComplexType = TFunction([ MacroTypes._void ], MacroTypes._void);
	
	public static var pCounter:Int = 0;
	public static var scCounter:Int = 0;
	#end
	
	@:macro static public function async(e:Expr):Expr {
		cl = Context.getLocalClass().get();
		allClFields = [];
		for (el in cl.fields.get())
			allClFields.push(el.name);
		for (el in cl.statics.get())
			allClFields.push(el.name);
		//e.expr.func().expr.expr = EBlock(blocks(e.expr.func().expr.expr.block()));
		
		var block:Expr = blocks(e.expr.block());
		var mt:MacroTool = MacroTool.create({
			var __ok__:Dynamic->Void;
			var __error__:Dynamic->Void;
			var __rootok__:Dynamic->Void;
			__rootok__ = __ok__ = function(r:Dynamic) {
				__rootok__ = __ok__/* = __error__*/ = function(r:Dynamic) throw "'ok' called";
				__error__ = pony.magic.async.AsyncRT.error;
				if (__aok__ != null)
					__aok__(r);
			};
			__error__ = function(r:Dynamic) {
				__rootok__ = __ok__/* = __error__*/ = function(r:Dynamic) throw "'error' called";
				__error__ = pony.magic.async.AsyncRT.error;
				if (__aerror__ != null)
					__aerror__(r);
				else
					throw r;
			};
		});
		mt.result.expr.block().push(block);
		block = mt.result;
		//trace(block.expr.block().last().expr.etry().e.expr.block()[1].expr.call().expr.func().expr.string());
		//trace(block.expr.block().last().expr.etry().e.expr.block()[1].string());
		return EFunction(null, {ret: null, params: [], args: [{value: null, type: ftype, opt: true, name: '__aok__'}, {value: null, type: ftype, opt: true, name: '__aerror__'}], expr: block}).expr();
	}
	
	#if macro
	static public function blocks(a:Array<Expr>):Expr {
		var na:Array<Expr> = [];
		while (a.length > 0) {
			var e:Expr = a.shift();
			MacroExtensions.pos = e.pos;
			switch (e.expr) {
				case EVars(vars):
					while (vars.length > 1) {
						a.unshift({pos: e.pos, expr: EVars([vars.pop()])});
					}
					
					for (v in vars) {
						if (a.length == 0) Context.field('error')('You crazy!', e.pos);
						if (v.expr != null )switch (v.expr.expr) {
							case ECall(call, par):
								switch (call.expr) {
									case EConst(c):
										var n:String = c.ident();
										if ( allClFields.indexOf(n + 'Async') != -1 ) {
											var npar:Array<Expr> = [];
											var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
											var i:Int = 1;
											for (p in par) {
												//if (switch (p.expr) {
												//	case ECall(Void, Void): true;
													//case EBlock(Void): true;
												//	default: false;
												//}) {
													var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
													vars.push( { type: dtype, name: n, expr: p } );
													npar.push( { expr: EConst(CIdent(n)), pos: e.pos } );
												//} else
												//	npar.push( p );
											}
											pCounter++;
											var params:Array<Expr> = npar;
											params.push({expr: EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
													{value: null, type: v.type, opt: false, name: v.name}
												] } ), pos: e.pos } );
												
											params.push( { expr: EConst(CIdent('__error__')), pos: e.pos });
											
											var ne:ExprDef = ECall( { expr: EConst(CIdent(n + 'Async')), pos: e.pos }, params);
											var nb:Expr = blocks([ { expr: EVars(vars), pos: e.pos }, { expr: ne, pos: e.pos } ]);
											for (el in nb.expr.etry().e.expr.block())
												na.push(el);
											return toTry(na);
										} else if (n.substr(n.length - 5) == 'Async' && allClFields.indexOf(n) != -1) {
											na.push(e);
											return toTry(na);
										}
									case EField(ef, field):
										
										if (switch (ef.expr) {
											case ECall(Void, Void):
												var n:String = '__sc' + Std.string(scCounter++) + '__';
												var nb:Array<Expr> = [
													EVars([ { name: n, type: MacroTypes._dynamic, expr: ef } ]).expr(),
													EVars([ { name: v.name, type: v.type, expr: ECall(EField(EConst(CType(n)).expr(), field).expr(), par).expr() } ]).expr()
												];
												nb = nb.concat(a);
												na.push( blocks(nb).expr.etry().e );
												return toTry(na);
											true;
											default: false;
										}) {
										} else if (switch (ef.expr.const()) {
											case CType(s): s != 'Async';
											default: true;
										}) {
										
											var npar:Array<Expr> = [];
											var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
											var i:Int = 1;
											for (p in par) {
												//switch (p.expr) {
												//	case ECall(Void, Void):
														var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
														vars.push( { type: dtype, name: n, expr: p } );
														npar.push( { expr: EConst(CIdent(n)), pos: ef.pos } );
												//	default:
												//		npar.push( p );
												//}
											}
											pCounter++;
											var params:Array<Expr> = [
												ef,
												{expr: EConst(CString(field)), pos: ef.pos },
												{expr: EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
													{value: null, type: v.type, opt: false, name: v.name}
												] } ), pos: ef.pos },
												{expr: EConst(CIdent('__error__')), pos: ef.pos},
												{expr: EArrayDecl(npar), pos: ef.pos}
											];
											
											var nb:Expr = blocks([ { expr: EVars(vars), pos: e.pos }, rt_call(params) ]);
											//trace(nb.expr.etry().e.expr.block()[1].string());
											na.push( nb.expr.etry().e );
											return toTry(na);
										} else {
											na.push(e);
											return toTry(na);
										}
									default:
								}
								
							case EBlock(ex):
								na.push(EVars([{name: '__blockFunc__', type: MacroTypes._dynamic, expr: EFunction(null, {ret: null, params: [], args: [{value: null, type: ftype, opt: false, name: '__ok__'}], expr: blocks(ex)} ).expr()}]).expr());
								na.push(ECall(
									EConst(CIdent('__blockFunc__')).expr(),
									[EFunction(null, {ret: null, params: [], args: [{value: null, type: v.type, opt: false, name: v.name}], expr: blocks(a)} ).expr()]
								).expr());
								return toTry(na);
								
							case EParenthesis(exx):
								var ex:Array<Expr> = [exx];
								na.push(EVars([{name: '__blockFunc__', type: MacroTypes._dynamic, expr: EFunction(null, {ret: null, params: [], args: [{value: null, type: ftype, opt: false, name: '__ok__'}], expr: blocks(ex)} ).expr()}]).expr());
								na.push(ECall(
									EConst(CIdent('__blockFunc__')).expr(),
									[EFunction(null, {ret: null, params: [], args: [{value: null, type: v.type, opt: false, name: v.name}], expr: blocks(a)} ).expr()]
								).expr());
								return toTry(na);
								
							case EBinop(op, e1, e2):
								var nba:Array<Expr> = [EVars([ { name: v.name, type: v.type, expr:EBlock([EBinop(op, e1, e2).expr()]).expr() } ]).expr()];
								for (el in a)
									nba.push(el);
								na.push(blocks(nba).expr.etry().e);
								return toTry(na);
								
							case EIf(econd, eif, eelse):
								var nba:Array<Expr> = [EVars([ { name: v.name, type: v.type, expr:EBlock([EIf(econd, eif, eelse).expr()]).expr() } ]).expr()];
								for (el in a)
									nba.push(el);
								na.push(blocks(nba).expr.etry().e);
								return toTry(na);
								
							case ENew(t, params):
								var npar:Array<Expr> = [];
								var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
								var i:Int = 1;
								for (p in params) {
									var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
									vars.push( { type: dtype, name: n, expr: p } );
									npar.push( EConst(CIdent(n)).expr() );
								}
								pCounter++;
								var params:Array<Expr> = [
									EConst(CType(t.name)).expr(),
									EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
										{value: null, type: v.type, opt: false, name: v.name}
									] } ).expr(),
									EConst(CIdent('__error__')).expr(),
									EArrayDecl(npar).expr()
								];
								//na.push('pony.magic.AsyncRT.create'.typeCall(params));
								
								var nb:Expr = blocks([ { expr: EVars(vars), pos: e.pos }, rt_create(params) ]);
								for (el in nb.expr.etry().e.expr.block())
									na.push(el);
								
								return toTry(na);
								
							case EConst(c):
								switch (c) {
									case CIdent(id)://todo: detect prop
										var n:String = 'get' + id.charAt(0).toUpperCase() + id.substr(1);
										//trace(n);
										if (allClFields.indexOf(n + 'Async') != -1) {
											var nb:Array<Expr> = [];
											nb.push(EVars([{name:vars[0].name, type:vars[0].type, expr:ECall(EConst(CIdent(n)).expr(), []).expr()}]).expr());
											for (el in a)
												nb.push(el);
											na.push(blocks(nb).expr.etry().e);
											return toTry(na);
										}
										
									default:
								}
								
							case EField(ex, f):
								na.push(rt_get([ex, EConst(CString(f)).expr(),
										{expr: EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
													{value: null, type: vars[0].type, opt: false, name: vars[0].name}
												] } ), pos: e.pos },
										 { expr: EConst(CIdent('__error__')), pos: e.pos },
										 EFunction(null, { ret: MacroTypes._dynamic, params: [], expr: EReturn(v.expr).expr(), args: [] } ).expr()
									]));
								return toTry(na);
								
							
							case ESwitch(ex, cases, edef):
								
								var nb:Array<Expr> = [];
								na.push(EVars([{name: '__ok__', type: MacroTypes._function, expr: EFunction(null, { ret: null, params: [], args: [ { value: null, type: v.type, opt: false, name: v.name } ], expr: blocks(a) }).expr()}]).expr());
								//nb.push(EVars([{name: '__sw__', type: MacroTypes._dynamic, expr: ex.expr.parentthesis()}]).expr());
								//nb.push(ESwitch(EParenthesis(EConst(CIdent('__sw__')).expr()).expr(), cases, edef).expr());
								//na.push(blocks(nb).expr.etry().e);
								
								na.push(ESwitch(ex, cases.map(function(c) return { values: c.values, expr: blocks([c.expr]) } ), edef != null ? blocks([edef]) : null).expr());
								
								return toTry(na);
								
							default: //trace(v.expr.expr);
						}
						
					}
				
				case ECall(call, par):
					
					switch (call.expr) {
						case EConst(c):
							var n:String;
							try {
								n = c.ident();
							} catch (e:Dynamic) {
								continue;
							}
							if ( allClFields.indexOf(n + 'Async') != -1 ) {
								
								var npar:Array<Expr> = [];
								var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
								var i:Int = 1;
								for (p in par) {
									//if (switch (p.expr) {
									//	case ECall(Void, Void): true;
										//todo:
										//case EBlock(Void): true;
									//	default: false;
									//}) {
										var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
										vars.push( { type: dtype, name: n, expr: p } );
										npar.push( { expr: EConst(CIdent(n)), pos: e.pos } );
									//} else
									//	npar.push( p );
								}
								pCounter++;
								var params:Array<Expr> = npar;
								params.push( { expr: if (a.length > 0 ) EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
									{value: null, type: TPath({sub: null, params: [], pack: [], name: 'Dynamic'}), opt: false, name: '__v__'}
								] } ) else EConst(CIdent('__ok__')), pos: e.pos });
								
								params.push( { expr: EConst(CIdent('__error__')), pos: e.pos });
								
								var ne:ExprDef = ECall( { expr: EConst(CIdent(n + 'Async')), pos: e.pos }, params);
								
								var nb:Expr = blocks([ { expr: EVars(vars), pos: e.pos }, { expr: ne, pos: e.pos } ]);
								for (el in nb.expr.etry().e.expr.block())
									na.push(el);
								return toTry(na);
							} else if (n.substr(n.length-5) == 'Async' && allClFields.indexOf(n) != -1) {
								na.push(e);
								return toTry(na);
							} else if (switch(par[0].expr) {
								case EConst(c):
									switch (c) {
										case CIdent(s): s.substr(0, 3) != '__p';
										default: true;
									}
								default: true;
							}) {
								
								var npar:Array<Expr> = [];
								var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
								var i:Int = 1;
								for (p in par) {
										var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
										vars.push( { type: dtype, name: n, expr: p } );
										npar.push( { expr: EConst(CIdent(n)), pos: e.pos } );
								}
								pCounter++;
								na.push(EVars(vars).expr());
								
								na.push(ECall(call, npar).expr());
								
								for (el in a)
									na.push(el);
									
								return blocks(na);
							}
						case EField(ef, field):
							if (switch (ef.expr) {
								case ECall(Void, Void):
									var n:String = '__sc' + Std.string(scCounter++) + '__';
									var nb:Array<Expr> = [
										EVars([ { name: n, type: MacroTypes._dynamic, expr: ef } ]).expr(),
										ECall(EField(EConst(CType(n)).expr(), field).expr(), par).expr()
									];
									nb = nb.concat(a);
									na.push( blocks(nb).expr.etry().e );
									return toTry(na);
								true;
								default: false;
							}) {
							} else if (switch(ef.expr) {
								case EConst(c):
									switch (c) {
										case CIdent(s):
											s == 'super';
										default: false;
									}
								default: false;
							}) {
								//field = 'super_' + field;
								//ef.expr = EConst(CIdent('this'));
								var params:Array<Expr> = par.copy();
								params.push( { expr: if (a.length > 0) EFunction(null, { ret: null, params: [], expr:  blocks(a), args: [] } ) else EConst(CIdent('__ok__')), pos: ef.pos } );
								params.push( { expr: EConst(CIdent('__error__')), pos: ef.pos } );
								na.push(ECall(EConst(CIdent('super_' + field+'Async')).expr(), params).expr());
								return toTry(na);
							} else if (
								switch(ef.expr) {
									case EConst(c):
										switch (ef.expr.const()) {
											case CType(s): s != 'Async';
											default: true;
										}
									default://todo: EType, EField
										false;
								}
								) {
								var npar:Array<Expr> = [];
								var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
								var i:Int = 1;
								for (p in par) {
									//if (switch (p.expr) {
									//	case ECall(Void, Void): true;
										//case EBlock(Void): true;
									//	default: false;
									//}) {
										var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
										vars.push( { type: dtype, name: n, expr: p } );
										npar.push( { expr: EConst(CIdent(n)), pos: ef.pos } );
									//} else
									//	npar.push( p );
								}
								pCounter++;
								var params:Array<Expr> = [
									ef,
									{expr: EConst(CString(field)), pos: ef.pos },
									{expr: if (a.length > 0) EFunction(null, { ret: null, params: [], expr:  blocks(a), args: [] } ) else EConst(CIdent('__ok__')), pos: ef.pos },
									{expr: EConst(CIdent('__error__')), pos: ef.pos},
									{expr: EArrayDecl(npar), pos: ef.pos}
								];
								
								var nb:Expr = blocks([ { expr: EVars(vars), pos: ef.pos }, rt_call(params) ]);
								for (el in nb.expr.etry().e.expr.block())
									na.push(el);
								return toTry(na);
							} else {
								na.push(e);
								return toTry(na);
							}
							
						default:
					}
				
				case EReturn(re):
					na.push(EBinop(OpAssign, EConst(CIdent('__ok__')).expr(), EConst(CIdent('__rootok__')).expr()).expr());
					na.push(blocks([re]));
					return toTry(na);
				
				case EBlock(ex):
					
					na.push(EVars([{name: '__blockFunc__', type: MacroTypes._dynamic, expr: EFunction(null, {ret: null, params: [], args: [{value: null, type: ftype, opt: false, name: '__ok__'}], expr: blocks(ex)} ).expr()}]).expr());
					na.push(ECall(
						EConst(CIdent('__blockFunc__')).expr(),
						[if (a.length > 0) EFunction(null, {ret: null, params: [], args: [{value: null, type: dtype, opt: false, name: '__aresult__'}], expr: blocks(a)} ).expr() else okCaller()]
					).expr());
					return toTry(na);
					
				case EParenthesis(exx):
					var ex:Array<Expr> = [exx];
					na.push(EVars([{name: '__blockFunc__', type: MacroTypes._dynamic, expr: EFunction(null, {ret: null, params: [], args: [{value: null, type: ftype, opt: false, name: '__ok__'}], expr: blocks(ex)} ).expr()}]).expr());
					na.push(ECall(
						EConst(CIdent('__blockFunc__')).expr(),
						[if (a.length > 0) EFunction(null, {ret: null, params: [], args: [{value: null, type: dtype, opt: false, name: '__aresult__'}], expr: blocks(a)} ).expr() else okCaller()]
					).expr());
					return toTry(na);
					
				case EIf(econd, eif, eelse):
					if (!econd.isVar('__cond__')) {
						var ne:Expr = inVars([ { name: '__cond__', type: MacroTypes._bool, expr: econd } ],
							{ expr: EIf( { expr: EConst(CIdent('__cond__')), pos: econd.pos }, eif, eelse), pos: e.pos }, na, a
						);
						return toTry([ne]);
					} else {
						na.push(EIf(econd, blocks([eif]).expr.etry().e, blocks((eelse != null)?[eelse]:[]).expr.etry().e).expr());
						return toTry(na);
					}
					
				case EBinop(op, e1, e2):
					if (!e1.isVar('__e1__') && !e2.isVar('__e2__')) {
						if (switch(op) {
							case OpAssign: false;
							case OpAssignOp(Void): false;
							default: true;
						})
							return inVars([ { name: '__e1__', type: MacroTypes._dynamic, expr: e1 }, { name: '__e2__', type: MacroTypes._dynamic, expr: e2 } ],
								{ expr: EBinop(op, EConst(CIdent('__e1__')).expr(), EConst(CIdent('__e2__')).expr()), pos: e.pos }, na, a
							);
						else {//This maybe hard for async setters
							switch (e1.expr) {
								case EConst(c):
									switch(c) {
										case CIdent(id):
											var n:String = 'set' + id.charAt(0).toUpperCase() + id.substr(1);
											//trace(n);
											if (allClFields.indexOf(n + 'Async') != -1) {
												switch(op) {
													case OpAssignOp(o):
														var nb:Array<Expr> = [];
														nb.push(ECall(EConst(CIdent(n)).expr(), [EBinop(o, e1, e2).expr()]).expr());
														for (el in a)
															nb.push(el);
														na.push(blocks(nb).expr.etry().e);
														return toTry(na);
													default:
														var nb:Array<Expr> = [];
														nb.push(ECall(EConst(CIdent(n)).expr(), [e2]).expr());
														for (el in a)
															nb.push(el);
														na.push(blocks(nb).expr.etry().e);
														return toTry(na);
												}
											}
										default:
									}
									
								case EField(ex, f):
									na.push(rt_set([ex, EConst(CString(f)).expr(),
										{expr: EFunction(null, { ret: null, params: [], expr: blocks([e2]), args: [
													{value: null, type: MacroTypes._function, opt: false, name: '__ok__'}
												] } ), pos: e.pos },
										a.length > 0 ? {expr: EFunction(null, { ret: null, params: [], expr: blocks(a), args: [
													{value: null, type: MacroTypes._dynamic, opt: false, name: '__v__'}
												] } ), pos: e.pos }
										: EConst(CIdent('__ok__')).expr(),
										{ expr: EConst(CIdent('__error__')), pos: e.pos },
										EFunction(null, { ret: MacroTypes._dynamic, params: [], expr: EReturn(EBinop(OpAssign, e1, EConst(CIdent('__v__')).expr()).expr()).expr(), args: [{value: null, type: MacroTypes._dynamic, opt: false, name: '__v__'}] } ).expr()
									]));
									return toTry(na);
								default:
							}
							/*
							trace( inVars([ { name: '__e2__', type: MacroTypes._dynamic, expr: e2 } ],
								{ expr: EBinop(op, e1, EConst(CIdent('__e2__')).expr()), pos: e.pos }, na, a
							).expr.etry().e.expr.block()[0].expr.vars()[0].expr.expr.func().expr.string());
							*/
							return inVars([ { name: '__e2__', type: MacroTypes._dynamic, expr: e2 } ],
								{ expr: EBinop(op, e1, EConst(CIdent('__e2__')).expr()), pos: e.pos }, na, a
							);
						}
					}
					
				case EWhile(econd, ebody, nw):
					if (nw) {
						var bfa:Array<Expr> = [
							EVars([ { name: '__bodyFunction__', type: ftype, expr: EFunction(null, { ret: null, params: [], args: [{value: null, type: ftype, opt: false, name: '__ok__'}], expr: blocks([ebody]).expr.etry().e } ).expr() } ]).expr(),
							EVars([ { name: '__whileFunction__', type: ftype, expr: EConst(CType('null')).expr() } ]).expr(),
							EBinop(OpAssign, EConst(CIdent('__whileFunction__')).expr(),
								EFunction(null, { ret: null, params: [], args: [{value: null, type: MacroTypes._dynamic, opt: false, name: '__result__'}], expr: blocks([EIf(
									econd,
									EBlock([
										EVars([ { name: '__ok__', type: ftype, expr: EConst(CIdent('__bodyFunction__')).expr()}]).expr(),
										EConst(CIdent('__whileFunction__')).expr()
									]).expr(),
									EBlock(a).expr()
								).expr()]).expr.etry().e } ).expr() ).expr(),
							ECall(EConst(CIdent('__whileFunction__')).expr(), [EConst(CType('null')).expr()]).expr()
							];
						for (el in bfa) {
							na.push(el);
							
						}
						//trace(bfa[2].expr.binop().e2.expr.func().expr.expr.block()[0].expr.etry().e.expr.block()[0].expr.vars()[0].expr.expr.func().expr.expr.etry().e.expr.block()[0].expr.block()[0].expr.vars()[0].expr.expr.func().expr.expr.etry().e.expr.block()[0].expr.vars()[0].expr.expr.func().expr.expr.etry().e.expr.block()[0].expr.block()[0].expr.vars()[0].expr.expr.func().expr.string());
						
						return toTry(na);
					} else
						'Coming soon!'.error();
					
				case EFor(it, ex):
					var ein: { e1:Expr, e2:Expr } = it.expr.ein();
					switch (ein.e2.expr) {
						case EBinop(Void, Void, Void):
							na.push(EVars( [ { name: '__iter__', type: MacroTypes._iterator, expr: ein.e2 } ] ).expr());
						case EConst(Void):
							na.push(EVars( [ { name: '__iter__', type: MacroTypes._iterator, expr: ECall(EField(ein.e2, 'iterator').expr(), []).expr() } ] ).expr());
						case EArrayDecl(Void):
							na.push(EVars( [ { name: '__array__', type: MacroTypes._array, expr: ein.e2 } ] ).expr());
							na.push(EVars( [ { name: '__iter__', type: MacroTypes._iterator, expr: ECall(EField(EConst(CIdent('__array__')).expr(), 'iterator').expr(), []).expr() } ] ).expr());
						case EField(Void, Void):
							na.push(EVars( [ { name: '__iter__', type: MacroTypes._iterator, expr: ECall(EField(ein.e2, 'iterator').expr(), []).expr() } ] ).expr());
						default:
							na.push(EVars( [ { name: '__iter__', type: MacroTypes._iterator, expr: ein.e2 } ] ).expr());
					}
					na.push(EWhile(ECall(
						EField(EConst(CIdent('__iter__')).expr(), 'hasNext').expr(), []).expr(),
						EBlock([EVars([ { name: ein.e1.expr.const().ident(), type: MacroTypes._dynamic, expr: ECall(EField(EConst(CIdent('__iter__')).expr(), 'next').expr(), []).expr() } ]).expr(), ex]).expr(),
						true
					).expr());
					for (el in a)
						na.push(el);
					return blocks(na);
					
				case ETry(e, catches):
					for (c in catches)
						c.expr = blocks([c.expr]);
					var nb:Array<Expr> = [EVars([ { name: '__error__', type: ftype, expr: EFunction(null, { ret: null, params: [], args: [ { value: null, type: MacroTypes._dynamic, opt: false, name: '__e__' } ], expr: EBlock([ETry(EThrow(EConst(CIdent('__e__')).expr()).expr(), catches).expr()]).expr() } ).expr() } ]).expr()];
					var snb:Array<Expr> = [];
					for (el in e.expr.block())
						snb.push(el);
					nb.push(EBlock(snb).expr());
					na.push(EBlock(nb).expr());
					for (el in a)
						na.push(el);
					
					return blocks(na);
					
				case ENew(t, params):
					var npar:Array<Expr> = [];
					var vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}> = [];
					var i:Int = 1;
					for (p in params) {
						var n:String = '__p' + Std.string(pCounter) + '_' + Std.string(i++) + '__';
						vars.push( { type: dtype, name: n, expr: p } );
						npar.push( EConst(CIdent(n)).expr() );
					}
					pCounter++;
					var params:Array<Expr> = [
						EConst(CType(t.name)).expr(),
						EConst(CIdent('__ok__')).expr(),
						EConst(CIdent('__error__')).expr(),
						EArrayDecl(npar).expr()
					];
					na.push(rt_create(params));
					return toTry(na);
					
					
				case ESwitch(ex, cases, edef)://todo: ex to async
								
					var nb:Array<Expr> = [];
					na.push(EVars([{name: '__ok__', type: MacroTypes._function, expr: EFunction(null, { ret: null, params: [], args: [ { value: null, type: MacroTypes._dynamic, opt: false, name: '__r__' } ], expr: blocks(a) }).expr()}]).expr());
					//nb.push(EVars([{name: '__sw__', type: MacroTypes._dynamic, expr: ex.expr.parentthesis()}]).expr());
					//nb.push(ESwitch(EParenthesis(EConst(CIdent('__sw__')).expr()).expr(), cases, edef).expr());
					//na.push(blocks(nb).expr.etry().e);
					
					na.push(ESwitch(ex, cases.map(function(c) return { values: c.values, expr: blocks([c.expr]) } ), edef != null ? blocks([edef]) : null).expr());
					
					return toTry(na);
					
				case ETernary(econd, eif, eelse):
					return blocks([EIf(econd, eif, eelse).expr()].concat(a));
		
				case EConst(c):
					//trace(c);
				case EThrow(Void): //skip
					
				case EField(Void, Void):
					
				default:
					trace(e.expr);
					'Coming soon!'.error();
			}
			na.push(e);
		}
		var e:Expr = na.pop();
		na.push(ECall(EConst(CIdent('__ok__')).expr(), if (e != null) [e] else [EConst(CIdent('null')).expr()]).expr());
		return toTry(na);
	}
	
	//Позволяет выписать выражения в аргументы, для последующей конвертации в ассинхронный вид.
	private static function inVars(vars:Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr>}>, op:Expr, na:Array<Expr>, a:Array<Expr>):Expr {
		var v:Expr = { expr: EVars(vars), pos: op.pos };
		var nba:Array<Expr> = [EBlock([ v, op ]).expr()];
		for (el in a) nba.push(el);
		var nb:Expr = blocks(nba);
		for (el in nb.expr.etry().e.expr.block()) {
			//trace(el.string());
			na.push(el);
		}
		return toTry(na);
	}
	
	static private function toTry(a:Array<Expr>):Expr {
		return ETry(EBlock(a).expr(), [ {
			type: dtype,
			name: '__err__',
			expr: ECall(EConst(CIdent('__error__')).expr(), [EConst(CIdent('__err__')).expr()]).expr()
		}]).expr();
	}
	
	static private function okCaller():Expr return EFunction(null, {
		ret: null,
		params: [],
		expr: ECall(EConst(CIdent('__ok__')).expr(), [EConst(CIdent('__result__')).expr()]).expr(),
		args: [{value: null, type: MacroTypes._dynamic, opt: false, name: '__result__'}]
	}).expr()

	
	static private function searchAsync(e:Expr):Bool {
		switch (e.expr) {
			case EConst(c):
				var n:String = c.ident();
				return cl.fields.get().exists(function(e:ClassField) return e.name == n + 'Async');
			case EField(e, field):
				trace(e);
				return false;
			default:
				return false;
		}
		
	}
	
	static private inline function rt_call(params:Array<Expr>):Expr {
		return (rt+'.call').typeCall(params);
	}
	
	static private inline function rt_create(params:Array<Expr>):Expr {
		return (rt+'.create').typeCall(params);
	}
	
	static private inline function rt_get(params:Array<Expr>):Expr {
		return (rt+'.get').typeCall(params);
	}
	
	static private inline function rt_set(params:Array<Expr>):Expr {
		return (rt+'.get').typeCall(params);
	}
	
	#end
}