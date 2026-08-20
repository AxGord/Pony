package pony.magic.builder;

using StringTools;

import haxe.macro.Expr.Access;
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
	private static inline final file: String = 'pony.xml';
	private static final replaces: Array<String> = ['-', '.'];
	#end

	@SuppressWarnings('checkstyle:MagicNumber')
	macro public static function build(): Array<Field> {
		final access: Array<Access> = [APublic, AStatic];
		final faccess: Array<Access> = [APrivate, AStatic, AInline #if (haxe_ver >= 4.2), AExtern #end];
		Context.registerModuleDependency(Context.getLocalModule(), file);
		final fields: Array<Field> = Context.getBuildFields();
		if (!sys.FileSystem.exists(file)) return fields;
		final xml: haxe.xml.Access = XmlTools.fast(File.getContent(file)).node.project;
		if (xml.hasNode.npm) {
			final npm: haxe.xml.Access = xml.node.npm;
			for (module in npm.nodes.module) {
				final req: String = module.innerData;
				final name: String = module.has.name ? module.att.name : filterName(req);
				if (fields.exists((f: Field) -> f.name == name)) continue;
				fields.push({ name: name, access: access, pos: Context.currentPos(), kind: FProp('get', 'never', macro :Dynamic, null) });
				fields.push({ name: 'get_$name', access: faccess, meta: [#if (haxe_ver < 4.2) { name: ':extern', pos: Context.currentPos() } #end], pos: Context.currentPos(), kind: FFun(
					{ args: [], ret: macro :Dynamic, expr: macro return js.Node.require($v{req}) }
				) });
			}
		}
		return fields;
	}

	#if macro
	private static function filterName(s: String): String {
		s = s.split('@')[0];
		for (r in replaces) s = s.replace(r, '_');
		return s;
	}
	#end

}
