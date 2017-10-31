/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import haxe.macro.ExprTools;
import haxe.macro.Compiler;
import haxe.xml.Fast;
import sys.io.File;
import pony.text.XmlConfigReader;
import pony.text.XmlTools;
using Lambda;
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
		#if debug
		var debug = true;
		#else
		var debug = false;
		#end
		var cfg:PConfig = {app:Compiler.getDefine('app'), debug:debug, path:''};
		if (xml.hasNode.config) {
			new ReadXmlConfig(xml.node.config, cfg, function(cfg:PConfig):Void {

				var type:ComplexType = switch cfg.type {
					case CString: macro:String;
					case CInt: macro:Int;
					case CFloat: macro:Float;
					case CStringMap: macro:Map<String, String>;
					case CIntMap: macro:Map<String, Int>;
					case CFloatMap: macro:Map<String, Float>;
					case _: throw 'Error';
				}

				var value:Expr = switch cfg.type {
					case CString: Context.makeExpr(cfg.value, Context.currentPos());
					case CInt: Context.makeExpr(Std.parseInt(cfg.value), Context.currentPos());
					case CFloat: Context.makeExpr(Std.parseFloat(cfg.value), Context.currentPos());
					case CStringMap, CIntMap, CFloatMap: null;
					case _: throw 'Error';
				}

				var map:Array<Expr> = switch cfg.type {
					case CString, CInt, CFloat: null;
					case CStringMap: [for (k in cfg.map.keys()) macro $v{k} => $v{cfg.map[k]}];
					case CIntMap: [for (k in cfg.map.keys()) macro $v{k} => $v{Std.parseInt(cfg.map[k])}];
					case CFloatMap: [for (k in cfg.map.keys()) macro $v{k} => $v{Std.parseFloat(cfg.map[k])}];
					case _: throw 'Error';
				}

				var access = [APublic, AStatic];
				switch cfg.type {
					case CString, CInt, CFloat: access.push(AInline);
					case _:
				}

				fields.push({
					name: cfg.path + cfg.key,
					access: access,
					pos: Context.currentPos(),
					kind: FVar(type, value != null ? value : macro $a{map})
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
	?value: String,
	?map: Map<String, String>,
	?type: ConfigTypes
};

private enum ConfigTypes {
	CString;
	CInt;
	CFloat;
	CVars;
	CStringMap;
	CIntMap;
	CFloatMap;
}

private class ReadXmlConfig extends XmlConfigReader<PConfig> {

	override private function readNode(xml:Fast):Void {
		var stype:String = xml.has.type ? xml.att.type : null;

		var map:Map<String, String> = null;

		var type:ConfigTypes = switch stype {

			case 'map', 'intmap', 'floatmap', 'stringmap':
				var mapType:ConfigTypes = switch stype {
					case 'map': null;
					case 'intmap': CInt;
					case 'floatmap': CFloat;
					case 'stringmap': CString;
					case _: throw 'Error';
				};
				map = new Map();
				new ReadXmlConfig(xml, {
					app: cfg.app,
					debug: cfg.debug,
					path: ''
				}, function(conf:PConfig) {
					if (mapType == null) mapType = conf.type;
					if (mapType != conf.type) throw 'Type error';
					map[conf.path + conf.key] = conf.value;
				});

				switch mapType {
					case CInt: CIntMap;
					case CFloat: CFloatMap;
					case CString: CStringMap;
					case _: throw 'Type error';
				}

			case 'vars': CVars;
			case 'int': CInt;
			case 'float': CFloat;
			case 'string': CString;

			case _:

				var nt = xml.x.count();
				if (nt > 1) {
					CVars;
				} else if (nt == 1) {
					var v = xml.innerData;
					if (Std.string(Std.parseInt(v)) == v)
						CInt;
					else if (Std.string(Std.parseFloat(v)) == v)
						CFloat;
					else
						CString;
				} else {
					throw 'Xml error';
				}

		}

		switch type {

			case CIntMap, CFloatMap, CStringMap:
				onConfig({
					app: cfg.app,
					debug: cfg.debug,
					path: cfg.path,
					key: xml.name,
					map: map,
					type: type
				});

			case CInt, CFloat, CString:
				onConfig({
					app: cfg.app,
					debug: cfg.debug,
					path: cfg.path,
					key: xml.name,
					value: xml.innerData,
					type: type
				});

			case CVars:
				new ReadXmlConfig(xml, {
					app: cfg.app,
					debug: cfg.debug,
					path: cfg.path + xml.name + '_'
				}, onConfig);

		}

		
	}

}
#end