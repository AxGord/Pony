package pony.ui.xml;

using StringTools;

#if macro
import pony.Fast;
import pony.text.TextTools;
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

using pony.macro.Tools;
using pony.text.XmlTools;

typedef Style = Map<String, Map<String, String>>;
#end

/**
 * XmlUiBuilder
 * @author AxGord <axgord@gmail.com>
 */
class XmlUiBuilder {

	private static var toConsructor: Array<Expr>;

	macro public static function build(assetManager: Expr, typesExpr: Expr): Array<Field> {
		final cl: ClassType = Context.getLocalClass().get();
		final meta: Metadata = cl.meta.get();
		if (!meta.checkMeta([':ui'])) {
			cl.superClass.t; // run build for super class
			return Context.getBuildFields();
		}

		final types = switch typesExpr.expr {
			case EObjectDecl(ts):
				[for (t in ts) t.field => exprToComplex(t.expr)];
			case _: Context.error('Types list wrong type', typesExpr.pos);
		}

		types['tween'] = macro :pony.time.Tween;

		if (cl.superClass != null) {
			final submeta: Metadata = cl.superClass.t.get().meta.get();
			if (submeta.checkMeta([':ui_types'])) {
				final m = submeta.getMeta(':ui_types').params[0];
				switch m.expr {
					case EObjectDecl(ts):
						for (t in ts) types[t.field] = exprToComplex(t.expr);
					case _:
						Context.error('Types list wrong type', m.pos);
				}
			}
		}

		if (meta.checkMeta([':ui_types'])) {
			final m = meta.getMeta(':ui_types').params[0];
			switch m.expr {
				case EObjectDecl(ts):
					for (t in ts) types[t.field] = exprToComplex(t.expr);
				case _:
					Context.error('Types list wrong type', m.pos);
			}
		}

		final fields: Array<Field> = Context.getBuildFields();

		final style: Style = [];
		if (meta.checkMeta([':style'])) {
			for (p in meta.getMeta(':style').params) switch p.expr {
				case EConst(CString(styleFile)):
					final s = getStyle(styleFile);
					for (k => value in s) style[k] = value;
				case _:
					Context.error('Wrong style type', meta.getMeta(':style').params[0].pos);
			}
		}

		switch meta.getMeta(':ui').params[0].expr {
			case EConst(CString(uiFile)):
				final ps = uiFile.split('/');
				ps.pop();
				gpath = ps.join('/');
				final xml = getXml(uiFile);

				final filters: Style = [];
				if (xml.has.filters) {
					for (f in parseAttr(xml.att.filters)) {
						final s = getFilters(joinPath(gpath, f));
						for (k => value in s) filters[k] = value;
					}
					xml.x.remove('filters');
				}

				if (xml.has.style) {
					for (f in parseAttr(xml.att.style)) {
						final s = getStyle(joinPath(gpath, f));
						for (k => value in s) style[k] = value;
					}
				}

				addId(fields, xml, style, types);

				final obj: Expr = {
					expr: EObjectDecl([for (k in filters.keys()) { field: k, expr: mapToOExprObject(filters[k]) }]),
					pos: Context.currentPos()
				};
				toConsructor = [];
				fields.push({
					name: '_createUI',
					kind: FFun({
						args: [],
						ret: null,
						expr: macro {
							createFilters($obj);
							var root = ${genExpr(xml, style)};
							$a{toConsructor};
							return root;
						}
					}),
					pos: Context.currentPos(),
					access: [#if (haxe_ver < 4.2) AOverride, #end APrivate]
				});
				toConsructor = [];
				final pathes: Array<String> = [];
				getPathes(pathes, xml, style);
				final pts: Array<String> = [];
				for (p in pathes) if (pts.indexOf(p) == -1) pts.push(p);
				final ps: Array<Expr> = [for (p in pts) macro $v{p}];
				fields.push({
					name: 'loadUI',
					kind: FFun({
						args: [{ name: 'cb', type: macro :Int -> Int -> Void }],
						ret: null,
						expr: macro ${assetManager}.load('', $a{ps}, cb)
					}),
					pos: Context.currentPos(),
					access: [AStatic, APublic]
				});
			case _:
				Context.error('Wrong ui type', meta.getMeta(':ui').params[0].pos);
		}

		return fields;
	}

	#if macro
	private static var gpath: String;

	private static function exprToComplex(expr: Expr): ComplexType {
		return TypeTools.toComplexType(Context.getType(ExprTools.toString(expr)));
	}

	private static function mapToOExprObject(map: Map<String, String>): Dynamic {
		return { expr: EObjectDecl([for (k in map.keys()) { field: k, expr: macro $v{map[k]} }]), pos: Context.currentPos() };
	}

	private static function getXml(file: String): Fast {
		Context.registerModuleDependency(Context.getLocalModule(), file);
		return
			try new Fast(Xml.parse(File.getContent(file.trim()))).elements.next() catch (e: haxe.xml.Parser.XmlParserException) throw new Error(
				e.message, Context.makePosition({ min: e.position, max: e.position + 1, file: file })
			);
	}

	private static function getFilters(file: String): Style {
		Context.registerModuleDependency(Context.getLocalModule(), file);
		final xml: Fast = getXml(file);
		var path: String = xml.has.path ? xml.att.path : '';
		return [
			for (x in xml.elements) x.name => [for (a in x.x.attributes()) a => x.att.resolve(a)]
		];
	}

	private static function getStyle(file: String): Style {
		Context.registerModuleDependency(Context.getLocalModule(), file);
		final xml: Fast = getXml(file);
		final path: String = xml.has.path ? xml.att.path : '';
		return [
			for (x in xml.elements) x.name => [
				for (a in x.x.attributes()) a => (a == 'src' ? joinPathA(path, x.att.resolve(a)) : x.att.resolve(a))
			]
		];
	}

	private static function parseAttr(attr: String): Array<String> {
		return [for (s in attr.split(',')) StringTools.trim(s)];
	}

	private static function exprToTypeString(expr: Expr): String {
		return switch expr.expr {
			case EConst(CIdent(s)): s;
			case EField(e, field): exprToTypeString(e) + '.' + field;
			case _: Context.error('Wrong expr type', expr.pos);
		}
	}

	private static function getPathes(pathes: Array<String>, xml: Fast, style: Style, path: String = ''): Void {
		if (xml.name == 'include') {
			if (xml.has.path) path = joinPath(path, xml.att.path);
			final xml = getXml(joinPath(gpath, xml.innerData));
			getPathes(pathes, xml, style, path);
			return;
		}
		if (xml.has.path) {
			path = joinPath(path, xml.att.path);
		} else {
			final attrs: Map<String, String> = [];
			addStyle(xml.name, attrs, style);
			if (attrs.exists('path')) pathes.push(joinPath(path, attrs['path']));
		}
		if (xml.has.src) {
			for (s in xml.att.src.split(',')) pathes.push(joinPath(path, StringTools.trim(s)));
		} else {
			final attrs: Map<String, String> = [];
			addStyle(xml.name, attrs, style);
			if (attrs.exists('src')) for (e in joinPathA(path, attrs['src']).split(',')) pathes.push(StringTools.ltrim(e));
		}
		for (x in xml.elements) getPathes(pathes, x, style, path);
	}

	private static function genExpr(xml: Fast, style: Style, prefix: String = '', path: String = '', repeat: Bool = false): Expr {
		final inRepeat: Bool = repeat;
		switch xml.name {
			case 'include':
				if (xml.has.path) path = joinPath(path, xml.att.path);
				final xml = getXml(joinPath(gpath, xml.innerData));
				return genExpr(xml, style, prefix, path, repeat);
			case 'repeat':
				repeat = true;
			case _:
		}

		final attrs: Map<String, String> = [];
		final name = addStyle(xml.name, attrs, style);
		for (k in xml.x.attributes()) if (k != 'id') attrs[k] = xml.att.resolve(k);

		if (attrs.exists('path')) path = joinPath(path, attrs['path']);
		if (attrs.exists('src')) attrs['src'] = joinPathA(path, attrs['src']);

		final content: Array<Expr> = [
			for (x in xml.elements) {
				final e: Null<Expr> = genExpr(x, style, prefix + (xml.has.id ? xml.att.id + '_' : ''), path, repeat);
				if (e != null) e;
			}
		];
		final textContent: String = content.length == 0 && xml.x.firstChild() != null ? xml.innerData : '';
		final obj: Expr = {
			expr: EObjectDecl([for (k in attrs.keys()) { field: k, expr: macro $v{attrs[k]} }]),
			pos: Context.currentPos()
		};

		if (name == 'tween') {
			if (!xml.has.id) throw 'Not have id';
			if (inRepeat) throw 'Repeat not supported for tween';
			final id: String = prefix + xml.att.id;
			toConsructor.push(macro {
				$i{id} = new pony.time.Tween(
					$v{xml.has.type ? xml.att.type : 'linear'}, $v{xml.has.time ? xml.att.time : '1s'}, $v{xml.isTrue('invert')},
					$v{xml.isTrue('loop')}, $v{xml.isTrue('pingpong')}, $v{xml.isFalse('fixedTime')}
				);
				$i{id}.onUpdate << function(value: Float): Void {
					var d = tweens[$v{id}];
					if (d != null) for (e in d) (e.startPos + e.endPos * value).setPosition(e.target);
				}
			});
			return null;
		}

		final expr: Expr = !inRepeat
			? macro createUIElement($v{name}, $obj, $a{content}, $v{textContent})
			: macro {
				name: $v{name},
				attrs: $obj,
				content: ($a{content}: Array<Dynamic>),
				textContent: textContent
			};
		return xml.has.id ? macro cast($i{prefix + xml.att.id} = cast ${expr}) : macro ${expr};
	}

	private static function addStyle(name: String, attrs: Map<String, String>, style: Style): String {
		if (!style.exists(name)) return name;
		var n: String = name;
		if (style[name].exists('extends')) n = addStyle(style[name]['extends'], attrs, style);
		for (k in style[name].keys()) if (k != 'extends') {
			final s: String = style[name][k];
			final att1: Bool = attrs[k] != null && attrs[k].charAt(0) == ',';
			final att2: Bool = s.charAt(0) == ',';
			attrs[k] = switch [att1, att2] {
				case [false, false]:
					s;
				case [false, true]:
					attrs[k] != null ? attrs[k] + s : s.substr(1).ltrim();
				case [true, false]:
					s + attrs[k];
				case [true, true]:
					StringTools.ltrim(attrs[k]) + s;
			}
		}
		return n;
	}

	private static function addId(
		fields: Array<Field>, xml: Fast, style: Style, types: Map<String, ComplexType>, prefix: String = ''
	): Void {
		if (xml.name == 'include') {
			final xml = getXml(joinPath(gpath, xml.innerData));
			addId(fields, xml, style, types, prefix);
		}
		var id: String = prefix;
		if (xml.has.id) {
			id = prefix + xml.att.id;
			fields.push({
				name: id,
				kind: FProp('default', 'null', getType(xml.name, style, types)),
				pos: Context.currentPos(),
				access: [APublic]
			});
			id += '_';
		}
		for (x in xml.elements) addId(fields, x, style, types, id);
	}

	private static function getType(name: String, style: Style, types: Map<String, ComplexType>): ComplexType {
		return if (types.exists(name))
			types[name];
		else if (style.exists(name))
			getType(style[name]['extends'], style, types);
		else
			Context.error('Unknown type ' + name, Context.currentPos());
	}

	private static function joinPathA(a: String, b: String): String {
		return [for (b in b.split(',')) joinPath(a, StringTools.trim(b))].join(', ');
	}

	private static function joinPath(a: String, b: String): String {
		if (b.charAt(0) == '/') return b.substr(1);
		if (a.length > 0 && a.charCodeAt(a.length - 1) != '/'.code) a += '/';
		return a + b;
	}
	#end

}
