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
import haxe.macro.Type;
import pony.macro.MacroTypes;

using Lambda;
using pony.macro.MacroExtensions;
#end

/**
 * Use meta @extends(class1, ...classN)
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.MultyExtendsBuilder.build())
#end
interface MultyExtends { }

/**
 * @author AxGord
 */
@:macro class MultyExtendsBuilder {
	
	
	static public function build():Array<Field> {
		var fields:Hash<Field> = new Hash<Field>();
		for (f in Context.getBuildFields()) {
			if (fields.exists(f.name))
				Context.error('Duplicate class field declaration: '+f.name, f.pos);
			fields.set(f.name, f);
		}
		
		var lClass:ClassType = Context.getLocalClass().get();
		var exts:Array < String > = [];
		var meta:MetaAccess = lClass.meta;
		
		var ne:Array<Expr> = [];
		for (m in meta.get()) {
			if (m.name == 'extends') {
				for (p in m.params) {
					//var c:String = p.expr.const().type();
					var c:String = p.expr.const().ident();
					exts.push(c);
					ne.push(EConst(CString(c)).expr());
				}
			}
		}
		meta.remove('extends');
		meta.add('extends', ne, Context.currentPos());
		for (e in exts) {
			var v:String = 'super' + e;
			var typePath:TypePath = { sub: null, params: [], pack: [], name: e };
			if (!fields.exists(v))
				fields.set(v, { pos: Context.currentPos(), name: v, meta: [], kind: FVar(TPath(typePath)), doc: null, access: [APrivate] } );
			
			//Build new
			{
				var block:Array<Expr> = fields.get('new').kind.fun().expr.expr.block();
				var ok:Bool = false;
				for (b in block)
					switch (b.expr) {
						case ECall(ex, pa):	
							if (ex.expr.const().ident() == v) {
								b.expr = EBinop(OpAssign, { pos: ex.pos, expr: EConst(CIdent(v)) }, { pos: ex.pos, expr: ENew(typePath, pa) } );
								ok = true;
							}
						default:
					}
				if (!ok) Context.error('Missing '+v+' constructor call', fields.get('new').pos);
			}
			
			for (f in Context.getType(e).inst().fields.get())
				if (!fields.exists(f.name)) {
					var ft:FieldType = null;
					var type:ComplexType = null;
					switch(f.type) {
						case TFun(args, ret):
							var nArgs:Array<FunctionArg> = [];
							var callParams:Array<Expr> = [];
							var n:Int = 1;
							for (a in args) {
								nArgs.push( { value: null, type: TPath( { sub: null, params: [], pack: [], name: a.t.inst().name } ), opt: a.opt, name: '_v' + n } );
								callParams.push(EConst(CIdent('_v'+n)).expr());
								n++;
							}
							ft = FFun( { ret:null, params:[], args:nArgs, expr: ECall(
								if (f.isPublic)
									EField(EConst(CIdent(v)).expr(), f.name).expr()
								else
									ECall(EField(EConst(CType('Reflect')).expr(), 'field').expr(), [EConst(CIdent(v)).expr(), EConst(CString(f.name)).expr()]).expr()
							, callParams).expr()});
						case TInst(t, p):
							type = TPath( { sub: null, params: [], pack: [], name: t.get().name } );
						case TDynamic(Void):
							type = MacroTypes._dynamic;
						//todo
						case TEnum(Void, Void):
							type = MacroTypes._dynamic;
						case TLazy(Void):
							type = MacroTypes._dynamic;
						//end
						default: throw 'Coming soon: '+f.type;
					}
					if (ft == null) {
						fields.set('get_'+f.name, { pos: f.pos, name: 'get_'+f.name, meta:f.meta.get(), kind: FFun ({
							ret: type, params: [], expr: EReturn(
								if (f.isPublic)
									EField(EConst(CIdent(v)).expr(), f.name).expr()
								else
									ECall(EField(EConst(CType('Reflect')).expr(), 'field').expr(), [EConst(CIdent(v)).expr(), EConst(CString(f.name)).expr()]).expr()
							).expr(), args: []
						}), doc: null, access: [APrivate] } );
						fields.set('set_'+f.name, { pos: f.pos, name: 'set_'+f.name, meta:f.meta.get(), kind: FFun({
							ret: type, params: [], expr: EReturn(
								if (f.isPublic)
									EBinop(OpAssign, EField(EConst(CIdent(v)).expr(), f.name).expr(), EConst(CIdent('_v')).expr()).expr()
								else
									EBlock([
										ECall(EField(EConst(CType('Reflect')).expr(), 'setField').expr(), [EConst(CIdent(v)).expr(), EConst(CString(f.name)).expr(), EConst(CIdent('_v')).expr()]).expr(),
										EConst(CIdent('_v')).expr()
									]).expr()
							).expr(), args: [{value: null, type: type, opt: false, name: '_v'}]
						}), doc: null, access: [APrivate]} );
						ft = FProp('get_' + f.name, 'set_' + f.name, type);
					}
					fields.set(f.name, { pos: f.pos, name: f.name, meta:f.meta.get(), kind: ft, doc: null, access: [f.isPublic?APublic:APrivate, AInline] } );
				}
			
		}
		return fields.array();
	}
}