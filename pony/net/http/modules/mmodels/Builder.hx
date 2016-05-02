/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http.modules.mmodels;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;

using pony.text.TextTools;
using Lambda;
#end

class Builder {
	
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var cur = Context.getLocalClass().get();
		if (cur.name == 'Model') return fields;
		for (f in fields) switch (f.name) {
			case 'many', 'insert', 'single', 'update':
				if (!f.meta.exists(function(m) return m.name == 'action'))
					f.meta.push( { pos: Context.currentPos(), name: 'action', params: [{expr: EConst(CString(f.name.bigFirst())), pos: Context.currentPos()}] } );
			/*case 'manyAsync', 'insertAsync':
				var n:String = f.name.substr(0, f.name.length - 5).bigFirst();
				if (!f.meta.exists(function(m) return m.name == 'action'))
					f.meta.push( { pos: Context.currentPos(), name: 'action', params: [EConst(CString(n)).expr()] } );*/
		}
		var pathes:Array<{ field : String, expr : Expr}> = [];
		var activePathes:Array<{ field : String, expr : Expr}> = [];
		var data:Array<{ field : String, expr : Expr}> = [];
		for (f in fields) {
			for (m in f.meta) {
				switch m.name {
					case ':path':
						pathes.push({field:f.name, expr: m.params[0]});
					case ':activePath':
						activePathes.push(
							{field:f.name, expr: {expr: EObjectDecl([
									{field: 'path', expr: m.params[0]},
									{field: 'field', expr: m.params[1]}
							]), pos: Context.currentPos()}}
						);
					case 'action':
						var d:Array<Expr> = [];
						switch f.kind {
							case FFun(fun): for (a in fun.args)
								switch a.type {
									case TPath(p):
										d.push({expr: EObjectDecl([
												{field: 'name', expr: {expr: EConst(CString(a.name)), pos: Context.currentPos()}},
												{field: 'type', expr: {expr: EConst(CString(p.name)), pos: Context.currentPos()}}
										]), pos: Context.currentPos()});
									case _: throw 'Error';
								}
							case _: throw 'Error';
						}
						data.push({field: f.name, expr: {expr: EArrayDecl(d), pos: Context.currentPos()}});
				}
				
			}
		}
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoArgs__',
			meta: [],
			doc: null,
			access: [AStatic, APrivate],
			kind: FVar(null, {expr: EObjectDecl(data), pos: Context.currentPos()})
		});
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoPathes__',
			meta: [],
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(null, {expr: EObjectDecl(pathes), pos: Context.currentPos()})
		});
		
		fields.push( {
			pos: Context.currentPos(),
			name: '__methoActivePathes__',
			meta: [],
			doc: null,
			access: [AStatic, APublic],
			kind: FVar(null, {expr: EObjectDecl(activePathes), pos: Context.currentPos()})
		});
		
		return fields;
	}
	
}