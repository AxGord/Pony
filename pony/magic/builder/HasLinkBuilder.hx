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
package pony.magic.builder;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.text.TextTools;

using pony.macro.Tools;
#end

/**
 * HasLinkBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasLinkBuilder {
	macro public static function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (field in fields) {
			switch field.kind {
				case FProp(get, set, type, expr) if (get == 'link' || set == 'link'):

					if (get == 'link') {
						get = 'get';
						
						var access = [AInline, APrivate];
						if (field.access.indexOf(AStatic) != -1)
							access.push(AStatic);
						fields.push({
							name: 'get_' + field.name,
							access: access,
							kind: FFun({
								args: [],
								ret: type,
								expr: macro return ${ expr }
							}),
							pos: field.pos,
							#if (js||flash) //for interfaces work only js or flash
							meta: [ { name:':extern', pos: field.pos } ]
							#end
						});
					}

					if (set == 'link') {
						set = 'set';
						
						var access = [AInline, APrivate];
						if (field.access.indexOf(AStatic) != -1)
							access.push(AStatic);
						fields.push({
							name: 'set_' + field.name,
							access: access,
							kind: FFun({
								args: [{name: 'v', type: type}],
								ret: type,
								expr: macro return ${ expr } = v
							}),
							pos: field.pos,
							#if (js||flash) //for interfaces work only js or flash
							meta: [ { name:':extern', pos: field.pos } ]
							#end
						});
					}

					field.kind = FProp(get, set, type);

				case _:
			}
		}
		return fields;
	}
}