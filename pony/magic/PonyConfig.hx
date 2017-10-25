/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import haxe.macro.ExprTools;
import haxe.xml.Fast;
import sys.io.File;
import pony.text.TextTools;
import pony.text.XmlTools;
import pony.text.XmlConfigReader;
using Lambda;
using pony.macro.Tools;
#end

/**
 * PonyConfig
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.PonyConfigBuilder.build())
#end
interface PonyConfig {}

class PonyConfigBuilder {

	private static var file:String = 'pony.xml';

	macro static public function build():Array<Field> {
		Context.registerModuleDependency(Context.getLocalModule(), file);
		var fields:Array<Field> = Context.getBuildFields();
		var xml = XmlTools.fast(File.getContent(file)).node.project;
		var cfg:PConfig = {app:null, debug:false, path:''};
		if (xml.hasNode.config) {
			new ReadXmlConfig(xml.node.config, cfg, function(cfg:PConfig):Void {
				var isInt = Std.string(Std.parseInt(cfg.value)) == cfg.value;
				var isFloat = !isInt && Std.string(Std.parseFloat(cfg.value)) == cfg.value;
				fields.push({
					name: cfg.path + cfg.key,
					access: [APublic, AStatic, AInline],
					pos: Context.currentPos(),
					kind: FVar(
						isFloat ? (macro:Float) : (isInt ? (macro:Int) : (macro:String)),
						Context.makeExpr(isFloat ? Std.parseFloat(cfg.value) : (isInt ? Std.parseInt(cfg.value) : cfg.value), Context.currentPos())
					)
				});
			});
		}
		return fields;
	}

}
#if macro
private typedef PConfig = { > BaseConfig,
	path: String,
	?key: String,
	?value: String
};

private class ReadXmlConfig extends XmlConfigReader<PConfig> {

	override private function readNode(xml:Fast):Void {
		var nt = xml.x.count();
		if (nt > 1) {
			new ReadXmlConfig(xml, {
				app: cfg.app,
				debug: cfg.debug,
				path: cfg.path + xml.name + '_'
			}, onConfig);
		} else if (nt == 1) {
			onConfig({
				app: cfg.app,
				debug: cfg.debug,
				path: cfg.path,
				key: xml.name,
				value: xml.innerData
			});
		} else {
			throw 'Xml error';
		}
	}

}
#end