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

using pony.macro.Tools;
#end

/**
 * AbstractBuilder
 * @author AxGord <axgord@gmail.com>
 * @author Simn <simon@haxe.org>
 * @link https://gist.github.com/Simn/5011604
 */
class HasAbstractBuilder {

	private static inline var PUBKEYWORD:String = 'abstract';
	private static inline var KEYWORD:String = ':$PUBKEYWORD';
	private static var META:Array<String> = [KEYWORD, PUBKEYWORD];

	macro public static function build():Array<Field> {
		var fields:Array<Field> = [];
		var cCur = Context.getLocalClass().get();
		
		for (f in Context.getBuildFields()) if (f.meta.checkMeta(META)) {
			if (f.access.indexOf(AOverride) != -1) Context.error("You can't use abstract for override field " + f.name, cCur.pos);
			switch f.kind {
				case FFun(fun):
					fields.push( {
						kind: FFun( { expr:macro return throw 'not implemented', args:fun.args, params:fun.params, ret:fun.ret } ),
						access: f.access,
						doc: f.doc,
						meta: f.meta,
						name: f.name,
						pos: f.pos
					});
				case _: Context.error(f.kind.getName() + " can't be abstract", f.pos);
			}
			
		} else fields.push(f);
		
		var fieldMap = [for (f in fields) f.name => true];
		function loop(c:ClassType) {
			for (f in c.fields.get()) {
				if (f.meta.has(KEYWORD) || f.meta.has(PUBKEYWORD)) {
					if (!fieldMap.exists(f.name)) {
						Context.error('Missing implementation for abstract field ' + f.name, cCur.pos);
					}
				} else {
					fieldMap.set(f.name, true);
				}
			}
			if (c.superClass != null)
				loop(c.superClass.t.get());
		}
		if (cCur.superClass != null)
			loop(cCur.superClass.t.get());
			
		return fields;
	}
	
}