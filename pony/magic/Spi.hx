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
import pony.macro.MacroTool;
import haxe.macro.Type;

using Lambda;
using pony.macro.MacroExtensions;
#end

/**
 * Signal on update var marked @spi.
 * Field SPI - for public, field spi - for private vars.
 * @author AxGord
 */
#if !macro
@:autoBuild(pony.magic.SpiBuilder.build())
#end
interface Spi implements Declarator { }

/**
 * ...
 * @author AxGord
 */
class SpiBuilder 
{

	@:macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		if (Context.getLocalClass().get().isInterface) return fields;
		var prSignals:Array<Field> = [];
		var pubSignals:Array<Field> = [];
		var prObj:Array<{ field : String, expr : Expr}> = [];
		var pubObj:Array<{ field : String, expr : Expr}> = [];
		var fNames:Array<String> = [];
		for (f in fields)
		{
			fNames.push(f.name);
			switch(f.kind) {
				case FVar(t, e):
					for (m in f.meta)
						if (m.name.toLowerCase() == 'spi') {
							
							var access:Array<Access> = f.access.indexOf(AStatic) == -1 ? [APrivate] : [APrivate, AStatic];
							
							(f.access.indexOf(AStatic) == -1 ? prSignals : pubSignals).push( {
								kind: FVar(TPath('pony.events.Signal'.typeType()), null),
								meta: [],
								name: f.name,
								doc: null,
								pos: Context.currentPos(),
								access: []
							});
							
							(f.access.indexOf(AStatic) == -1 ? prObj : pubObj).push( {
								field: f.name,
								expr: 'pony.events.Signal'.typeNew([])
							});
								
							
							
							var nMeta:Metadata = f.meta.copy();
							nMeta.remove(m);
							f.meta = [];
							fields.push( { pos: Context.currentPos(), name: '_' + f.name, meta: nMeta, kind: FVar(t, e), doc: null, access: access } );
							var tool:MacroTool =
								if (f.access.indexOf(AStatic) == -1)
									MacroTool.create({
										if (name == v) return v;
										spi.__.dispatch(v);
										return name = v;
									});
								else
									MacroTool.create({
										if (name == v) return v;
										SPI.__.dispatch(v);
										return name = v;
									});
							var res:Expr = EBlock(tool.result.expr.block()).replace('name', '_' + f.name).expr();
							
							res.expr.block()[1].expr.call().expr.field().e.expr = EField(res.expr.block()[1].expr.call().expr.field().e.expr.field().e, f.name);
							fields.push({ pos: Context.currentPos(), name: 'set_' + f.name, meta: [], kind: FFun( {
								ret: t, params: [], args: [ { value: null, type: t, opt: false, name: 'v' } ],
								expr: res
							}), doc: null, access: access } );
							
							fields.push({ pos: Context.currentPos(), name: 'get_' + f.name, meta: [], kind: FFun( {
								ret: t, params: [], args: [],
								expr: EReturn(EConst(CIdent('_'+f.name)).expr()).expr()
							}), doc: null, access: access } );
							f.kind = FProp('get_' + f.name, 'set_' + f.name, t, null);
							break;
						}
				default:
			}
		}
		if (fieldExists('spi'))
		fields.push( { pos: Context.currentPos(), name: 'spi', meta: [], kind: FVar(TAnonymous(prSignals), EObjectDecl(prObj).expr()), doc: null, access: [APublic] } );
		if (fieldExists('SPI'))
		fields.push( { pos: Context.currentPos(), name: 'SPI', meta: [], kind: FVar(TAnonymous(pubSignals), EObjectDecl(pubObj).expr()), doc: null, access: [APublic, AStatic] } );
		
		
		return fields;
	}
	
	#if macro
	public static function fieldExists(field:String):Bool {
		var c:ClassType = Context.getLocalClass().get();
		for (f in c.fields.get()) if (f.name == field) return true;
		while (c.superClass != null) {
			c = c.superClass.t.get();
			for (f in c.fields.get()) if (f.name == field) return true;
		}
		return false;
	}
	#end
}