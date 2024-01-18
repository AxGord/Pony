package pony.magic.builder;

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

	@SuppressWarnings('checkstyle:MagicNumber')
	macro public static function build():Array<Field> {
		var access = [ APublic, AStatic ];
		var faccess = [ APrivate, AStatic, AInline #if (haxe_ver >= 4.2), AExtern #end  ];
		Context.registerModuleDependency(Context.getLocalModule(), file);
		var fields:Array<Field> = Context.getBuildFields();
		if (!sys.FileSystem.exists(file)) return fields;
		var xml = XmlTools.fast(File.getContent(file)).node.project;
		if (xml.hasNode.npm) {
			var npm = xml.node.npm;
			for (module in npm.nodes.module) {
				var req:String = module.innerData;
				var name:String = module.has.name ? module.att.name : filterName(req);
				if (fields.exists(function(f:Field) return f.name == name)) continue;
				fields.push({
					name: name,
					access: access,
					pos: Context.currentPos(),
					kind: FProp('get', 'never', macro:Dynamic, null)
				});
				fields.push({
					name: 'get_$name',
					access: faccess,
					meta: [ #if (haxe_ver < 4.2) { name: ':extern', pos: Context.currentPos() } #end ],
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