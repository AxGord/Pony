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
package pony.magic;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import pony.text.TextTools;
using pony.macro.Tools;
#end

/**
 * HasLink
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.HasLinkBuilder.build())
#end
interface HasLink { }

/**
 * HasLinkBuilder
 * @author AxGord <axgord@gmail.com>
 */
class HasLinkBuilder {
	macro static public function build():Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		for (field in fields) {
			switch field.kind {
				case FProp(get, set, type, expr) if (get == 'link'):
					field.kind = FProp('get', set, type);
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
				case _:
			}
		}
		return fields;
	}
}