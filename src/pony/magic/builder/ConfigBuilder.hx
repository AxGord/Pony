package pony.magic.builder;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Compiler;

import pony.Fast;

import sys.io.File;

import pony.text.TextTools;
import pony.text.XmlConfigReader;
import pony.text.XmlTools;

using Lambda;
#end

/**
 * ConfigBuilder
 * @author AxGord <axgord@gmail.com>
 */
class ConfigBuilder {

	private static inline var file: String = 'pony.xml';

	macro public static function build(): Array<Field> {
		Context.registerModuleDependency(Context.getLocalModule(), file);
		var fields: Array<Field> = Context.getBuildFields();
		if (!sys.FileSystem.exists(file))
			return fields;
		var xml = XmlTools.fast(File.getContent(file)).node.project;
		if (xml.hasNode.config) {
			var xcfg: Fast = xml.node.config;
			if (xcfg.has.dep)
				for (f in xcfg.att.dep.split(','))
					Context.registerModuleDependency(Context.getLocalModule(), StringTools.trim(f));
			var cfg: PConfig = {
				app: haxe.macro.Context.definedValue('app'),
				#if debug
				debug: true,
				#else
				debug: false,
				#end
				#if cordova
				cordova: true,
				#end
				path: ''
			};
			var addedConfig: Array<String> = []; // Filter added configs because app define not set for completion server
			new ReadXmlConfig(xcfg, cfg, function(cfg: PConfig): Void {
				var type: ComplexType = switch cfg.type {
					case CString: macro:String;
					case CInt: macro:Int;
					case CFloat: macro:Float;
					case CBool: macro:Bool;
					case CColor: macro:pony.color.Color;
					case CStringMap: macro:Map<String, String>;
					case CIntMap: macro:Map<String, Int>;
					case CFloatMap: macro:Map<String, Float>;
					case CBoolMap: macro:Map<String, Bool>;
					case CColorMap: macro:Map<String, pony.color.Color>;
					case _: throw 'Error';
				}

				var value: Expr = switch cfg.type {
					case CString: Context.makeExpr(cfg.value, Context.currentPos());
					case CInt: Context.makeExpr(Std.parseInt(cfg.value), Context.currentPos());
					case CFloat: Context.makeExpr(Std.parseFloat(cfg.value), Context.currentPos());
					case CBool: Context.makeExpr(TextTools.isTrue(cfg.value), Context.currentPos());
					case CColor: Context.makeExpr((pony.color.Color.fromString(cfg.value): Int), Context.currentPos());
					case CStringMap, CIntMap, CFloatMap: null;
					case _: throw 'Error';
				}

				var map: Array<Expr> = switch cfg.type {
					case CString, CInt, CFloat, CBool, CColor: null;
					case CStringMap: [for (k in cfg.map.keys()) macro $v{k} => $v{cfg.map[k]}];
					case CIntMap: [for (k in cfg.map.keys()) macro $v{k} => $v{Std.parseInt(cfg.map[k])}];
					case CFloatMap: [for (k in cfg.map.keys()) macro $v{k} => $v{Std.parseFloat(cfg.map[k])}];
					case CBoolMap: [for (k in cfg.map.keys()) macro $v{k} => $v{TextTools.isTrue(cfg.map[k])}];
					case CColorMap: [
							for (k in cfg.map.keys()) macro $v{k} => $v{(pony.color.Color.fromString(cfg.value): Int)}
						];
					case t: throw 'Error $t';
				}

				var access = [APublic, AStatic];
				switch cfg.type {
					case CString, CInt, CFloat, CBool:
						access.push(AInline);
					case _:
				}
				var name: String = cfg.path + cfg.key;
				if (addedConfig.contains(name)) return;
				addedConfig.push(name);
				fields.push({
					name: name,
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
private typedef PConfig = {
	> BaseConfig,
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
	CBool;
	CColor;
	CVars;
	CStringMap;
	CIntMap;
	CFloatMap;
	CBoolMap;
	CColorMap;
}

private class ReadXmlConfig extends XmlConfigReader<PConfig> {

	override private function readNode(xml: Fast): Void {
		var v: String = null;
		try {
			v = xml.innerData;
			if (v.charAt(0) == '$') {
				var nv = Sys.getEnv(v.substr(1));
				if (nv == null) {
					Sys.println('Warning: Not exists env: ' + v);
					v = '';
				} else {
					v = nv;
				}
			}
		} catch (_:Any) {}

		var stype: String = xml.has.type ? xml.att.type : null;

		var map: Map<String, String> = null;

		var type: ConfigTypes = switch stype {

			case 'map', 'intmap', 'floatmap', 'boolmap', 'stringmap':
				var mapType: ConfigTypes = switch stype {
					case 'map': null;
					case 'intmap': CInt;
					case 'floatmap': CFloat;
					case 'boolmap': CBool;
					case 'stringmap': CString;
					case 'colormap': CColor;
					case _: throw 'Error';
				};
				map = new Map();
				new ReadXmlConfig(xml, {
					app: cfg.app,
					debug: cfg.debug,
					cordova: cfg.cordova,
					path: ''
				}, function(conf: PConfig) {
					if (mapType == null) mapType = conf.type;
					if (stype == 'map' && mapType != conf.type) throw 'Type error';
					map[conf.path + conf.key] = conf.value;
				});

				switch mapType {
					case CInt: CIntMap;
					case CFloat: CFloatMap;
					case CBool: CBoolMap;
					case CString: CStringMap;
					case CColor: CColorMap;
					case _: throw 'Type error';
				}

			case 'vars': CVars;
			case 'int': CInt;
			case 'float': CFloat;
			case 'bool': CBool;
			case 'string': CString;
			case 'color': CColor;

			case _:
				var nt: Int = xml.x.count();
				if (nt > 1) {
					CVars;
				} else if (nt == 1) {
					if (v == null)
						CString;
					else if (TextTools.isTrue(v) || StringTools.trim(v.toLowerCase()) == 'false')
						CBool;
					else if (Std.string(Std.parseInt(v)) == v)
						CInt;
					else if (Std.string(Std.parseFloat(v)) == v)
						CFloat;
					else if (v.charAt(0) == '#')
						CColor;
					else
						CString;
				} else {
					throw 'Xml error';
				}

		}

		switch type {

			case CIntMap, CFloatMap, CBoolMap, CStringMap, CColorMap:
				onConfig({
					app: cfg.app,
					debug: cfg.debug,
					cordova: cfg.cordova,
					path: cfg.path,
					key: xml.name,
					map: map,
					type: type
				});

			case CInt, CFloat, CBool, CString, CColor:
				onConfig({
					app: cfg.app,
					debug: cfg.debug,
					cordova: cfg.cordova,
					path: cfg.path,
					key: xml.name,
					value: v,
					type: type
				});

			case CVars:
				new ReadXmlConfig(xml, {
					app: cfg.app,
					debug: cfg.debug,
					cordova: cfg.cordova,
					path: cfg.path + xml.name + '_'
				}, onConfig);

		}

	}

}
#end