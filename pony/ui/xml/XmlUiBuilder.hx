package pony.ui.xml;

#if macro
import haxe.xml.Fast;
import sys.io.File;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import pony.text.TextTools;

using pony.macro.Tools;

typedef Style = Map<String, Map<String, String>>;
#end

/**
 * XmlUiBuilder
 * @author AxGord <axgord@gmail.com>
 */
class XmlUiBuilder {
	
	macro static public function build(typesExpr:Expr):Array<Field> {
		
		var types = switch typesExpr.expr {
			case EObjectDecl(ts):
				[for (t in ts) t.field => switch t.expr.expr {
					case EConst(CIdent(s)): TypeTools.toComplexType(Context.getType(s));
					case _: Context.error('Types list wrong type', typesExpr.pos);
				}];
			case _: Context.error('Types list wrong type', typesExpr.pos);
		}
		
		var cl = Context.getLocalClass();
		var meta = cl.get().meta.get();
		if (!meta.checkMeta([':ui'])) Context.error('Not have :ui', Context.currentPos());
		
		var fields:Array<Field> = Context.getBuildFields();
		
		var style:Style = new Map();
		if (meta.checkMeta([':style'])) {
			switch meta.getMeta(':style').params[0].expr {
				case EConst(CString(styleFile)):
					var xml = new Fast(Xml.parse(File.getContent(styleFile)));
					style = [for (x in xml.node.style.elements)
						x.name => [for (a in x.x.attributes()) a => x.att.resolve(a)]
					];
				case _: Context.error('Wrong style type', meta.getMeta(':style').params[0].pos);
			}
		}
		
		switch meta.getMeta(':ui').params[0].expr {
			case EConst(CString(uiFile)):
				var xml = new Fast(Xml.parse(File.getContent(uiFile))).elements.next();
				addId(fields, xml, style, types);
				fields.push({name: 'createUI', kind:FFun({args:[], ret:null, expr:genExpr(xml, style)}), pos: Context.currentPos()});
				var pathes:Array<String> = [];
				getPathes(pathes, xml, style);
				var pts = [];
				for (p in pathes) if (pts.indexOf(p) == -1) pts.push(p);
				var ps:Array<Expr> = [for (p in pts) macro $v{p}];
				fields.push({name: 'loadUI', kind:FFun({args:[{name:'cb', type:macro:Int->Int->Void}], ret:null,
					expr:macro pony.ui.AssetManager.loadPath('', $a{ps}, cb)}), pos: Context.currentPos()});
			case _: Context.error('Wrong ui type', meta.getMeta(':ui').params[0].pos);
		}
		
		return fields;
	}
	
	#if macro
	private static function getPathes(pathes:Array<String>, xml:Fast, style:Style, path:String = ''):Void {
		if (xml.has.path) {
			path += xml.att.path + '/';
		} else {
			var attrs:Map<String, String> = new Map();
			addStyle(xml.name, attrs, style);
			if (attrs.exists('path')) pathes.push(path + attrs['path']);
		}
		if (xml.has.src) {
			pathes.push(path + xml.att.src);
		} else {
			var attrs:Map<String, String> = new Map();
			addStyle(xml.name, attrs, style);
			if (attrs.exists('src')) pathes.push(path + attrs['src']);
		}
		for (x in xml.elements) getPathes(pathes, x, style, path);
	}
	
	private static function genExpr(xml:Fast, style:Style, prefix:String = ''):Expr {
		var attrs:Map<String, String> = new Map();
		var name = addStyle(xml.name, attrs, style);
		for (k in xml.x.attributes())
			attrs[k] = xml.att.resolve(k);
		var content:Array<Expr> = [for (x in xml.elements) genExpr(x, style, prefix + (xml.has.id ? xml.att.id+'_' : ''))];
		if (content.length == 0 && xml.x.firstChild() != null) content.push(macro $v{xml.innerData});
		var obj = {expr: EObjectDecl([for (k in attrs.keys()) {field: k, expr: macro $v{attrs[k]}}]), pos: Context.currentPos()};
		if (xml.has.id)
			return macro $i{prefix + xml.att.id} = createUIElement($v{name}, $obj, $a{content});
		else
			return macro createUIElement($v{name}, $obj, $a{content});
	}
	
	private static function addStyle(name:String, attrs:Map<String, String>, style:Style):String {
		if (!style.exists(name)) return name;
		var n = name;
		if (style[name].exists('extends'))
			n = addStyle(style[name]['extends'], attrs, style);
		for (k in style[name].keys()) if (k != 'extends')
			attrs[k] = style[name][k];
		return n;
	}
	
	private static function addId(fields:Array<Field>, xml:Fast, style:Style, types:Map<String, ComplexType>, prefix:String = ''):Void {
		var id = prefix;
		if (xml.has.id) {
			id = prefix + xml.att.id;
			fields.push({name: id, kind:FProp('default', 'null', getType(xml.name, style, types)), pos: Context.currentPos(), access: [APublic]});
			id += '_';
		}
		for (x in xml.elements) addId(fields, x, style, types, id);
	}
	
	private static function getType(name:String, style:Style, types:Map<String, ComplexType>):ComplexType {
		return if (types.exists(name)) types[name];
		else if (style.exists(name))
			getType(style[name]['extends'], style, types);
		else
			Context.error('Unknown type '+name, Context.currentPos());
	}
	#end
	
}