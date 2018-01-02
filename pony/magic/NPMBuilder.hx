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
package pony.magic;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Compiler;
import haxe.xml.Fast;
import sys.io.File;
import pony.text.XmlConfigReader;
import pony.text.XmlTools;
using Lambda;
#end

/**
 * NPMBuilder
 * @author AxGord <axgord@gmail.com>
 */
class NPMBuilder {

    #if macro
	private static inline var file:String = 'pony.xml';
    private static var replaces:Array<String> = ['-', '.'];
    #end

	macro public static function build():Array<Field> {
		var access = [APublic, AStatic];
		var faccess = [APrivate, AStatic, AInline];
		Context.registerModuleDependency(Context.getLocalModule(), file);
		var fields:Array<Field> = Context.getBuildFields();
        if (!sys.FileSystem.exists(file)) return fields;
        var xml = XmlTools.fast(File.getContent(file)).node.project;
        if (xml.hasNode.npm) {
            var npm = xml.node.npm;
            for (module in npm.nodes.module) {
                var req:String = module.innerData;
                var name:String = module.has.name ? module.att.name : filterName(req);
                fields.push({
					name: name,
					access: access,
					pos: Context.currentPos(),
					kind: FProp('get', 'never', macro:Dynamic, null)
				});
                fields.push({
					name: 'get_$name',
					access: faccess,
					pos: Context.currentPos(),
					kind: FFun({
                        args: [],
                        ret: macro:Dynamic,
                        expr: macro return js.Node.require($v{req})
                    })
				});
            }
        }
        return fields;
    }

    #if macro
    private static function filterName(s:String):String {
        s = s.split('@')[0];
        for (r in replaces) s = StringTools.replace(s, r, '_');
        return s;
    }
    #end

}