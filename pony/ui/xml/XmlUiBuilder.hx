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
				[for (t in ts) t.field => TypeTools.toComplexType(Context.getType(exprToTypeString(t.expr)))];
			case _: Context.error('Types list wrong type', typesExpr.pos);
		}
		
		var cl = Context.getLocalClass();
		var meta = cl.get().meta.get();
		if (!meta.checkMeta([':ui'])) Context.error('Not have :ui', Context.currentPos());
		
		if (meta.checkMeta([':ui_types'])) {
			var m = meta.getMeta(':ui_types').params[0];
			switch m.expr {
				case EObjectDecl(ts):
					for (t in ts) types[t.field] = TypeTools.toComplexType(Context.getType(exprToTypeString(t.expr)));
				case _: Context.error('Types list wrong type', m.pos);
			}
		}
		
		var fields:Array<Field> = Context.getBuildFields();
		
		var style:Style = new Map();
		if (meta.checkMeta([':style'])) {
			for (p in meta.getMeta(':style').params)
				switch p.expr {
					case EConst(CString(styleFile)):
						var s = getStyle(styleFile);
						for (k in s.keys()) style[k] = s[k];
					case _: Context.error('Wrong style type', meta.getMeta(':style').params[0].pos);
				}
		}
		
		switch meta.getMeta(':ui').params[0].expr {
			case EConst(CString(uiFile)):
				var ps = uiFile.split('/');
				ps.pop();
				gpath = ps.join('/');
				var xml = getXml(uiFile);
				
				var filters:Style = new Map();
				if (xml.has.filters) {
					for (f in parseAttr(xml.att.filters)) {
						var s = getFilters(joinPath(gpath, f));
						for (k in s.keys()) filters[k] = s[k];
					}
					xml.x.remove('filters');
				}
				
				if (xml.has.style) {
					for (f in parseAttr(xml.att.style)) {
						var s = getStyle(joinPath(gpath, f));
						for (k in s.keys()) style[k] = s[k];
					}
				}
				
				addId(fields, xml, style, types);
				
				var obj = {expr: EObjectDecl([for (k in filters.keys()) {field: k, expr: mapToOExprObject(filters[k])}]), pos: Context.currentPos()};
				
				var exprs:Array<Expr> = [
					macro createFilters($obj),
					macro return ${genExpr(xml, style)}
				];
				
				fields.push({name: '_createUI', kind:FFun({args:[], ret:null, expr:macro $b{exprs}}), pos: Context.currentPos(), access:[AOverride, APrivate]});
				var pathes:Array<String> = [];
				getPathes(pathes, xml, style);
				var pts = [];
				for (p in pathes) if (pts.indexOf(p) == -1) pts.push(p);
				var ps:Array<Expr> = [for (p in pts) macro $v{p}];
				fields.push({name: 'loadUI', kind:FFun({args:[{name:'cb', type:macro:Int->Int->Void}], ret:null,
					expr:macro pony.ui.AssetManager.loadPath('', $a{ps}, cb)}), pos: Context.currentPos(), access: [AStatic, APublic]});
			case _: Context.error('Wrong ui type', meta.getMeta(':ui').params[0].pos);
		}
		
		return fields;
	}
	
	#if macro
	private static var gpath:String;
	
	private static function mapToOExprObject(map:Map<String, String>):Dynamic {
		return {expr: EObjectDecl([for (k in map.keys()) {field: k, expr: macro $v{map[k]}}]), pos: Context.currentPos()};
	}
	
	private static function getXml(file:String):Fast {
		return new Fast(Xml.parse(File.getContent(StringTools.trim(file)))).elements.next();
	}
	
	private static function getFilters(file:String):Style {
		var xml = getXml(file);
		var path = xml.has.path ? xml.att.path : '';
		return [for (x in xml.elements) x.name => 
			[for (a in x.x.attributes()) a => x.att.resolve(a)]
		];
	}
	
	private static function getStyle(file:String):Style {
		var xml = getXml(file);
		var path = xml.has.path ? xml.att.path : '';
		return [for (x in xml.elements) x.name => 
			[for (a in x.x.attributes()) a => (a == 'src' ? joinPathA(path, x.att.resolve(a)) : x.att.resolve(a))]
		];
	}
	
	private static function parseAttr(attr:String):Array<String> {
		return [for (s in attr.split(',')) StringTools.trim(s)];
	}
	
	private static function exprToTypeString(expr:Expr):String {
		return switch expr.expr {
			case EConst(CIdent(s)): s;
			case EField(e, field): exprToTypeString(e) + '.' + field;
			case _: Context.error('Wrong expr type', expr.pos);
		}
	}
	
	private static function getPathes(pathes:Array<String>, xml:Fast, style:Style, path:String = ''):Void {
		if (xml.name == 'include') {
			if (xml.has.path) path = joinPath(path, xml.att.path);
			var xml = getXml(joinPath(gpath, xml.innerData));
			getPathes(pathes, xml, style, path);
			return;
		}
		if (xml.has.path) {
			path = joinPath(path, xml.att.path);
		} else {
			var attrs:Map<String, String> = new Map();
			addStyle(xml.name, attrs, style);
			if (attrs.exists('path')) pathes.push(joinPath(path, attrs['path']));
		}
		if (xml.has.src) {
			pathes.push(joinPath(path, xml.att.src));
		} else {
			var attrs:Map<String, String> = new Map();
			addStyle(xml.name, attrs, style);
			if (attrs.exists('src'))
				for (e in joinPathA(path, attrs['src']).split(','))
					pathes.push(StringTools.ltrim(e));
		}
		for (x in xml.elements) getPathes(pathes, x, style, path);
	}
	
	private static function genExpr(xml:Fast, style:Style, prefix:String = '', path:String = ''):Expr {
		if (xml.name == 'include') {
			if (xml.has.path) path = joinPath(path, xml.att.path);
			var xml = getXml(joinPath(gpath, xml.innerData));
			return genExpr(xml, style, prefix, path);
		}
		
		var attrs:Map<String, String> = new Map();
		var name = addStyle(xml.name, attrs, style);
		for (k in xml.x.attributes()) if (k != 'id')
			attrs[k] = xml.att.resolve(k);
			
		if (attrs.exists('path')) path = joinPath(path, attrs['path']);
		if (attrs.exists('src')) attrs['src'] = joinPathA(path, attrs['src']);
			
		var content:Array<Expr> = [for (x in xml.elements) genExpr(x, style, prefix + (xml.has.id ? xml.att.id+'_' : ''), path)];
		if (content.length == 0 && xml.x.firstChild() != null) content.push(macro $v{xml.innerData});
		var obj = {expr: EObjectDecl([for (k in attrs.keys()) {field: k, expr: macro $v{attrs[k]}}]), pos: Context.currentPos()};
		
		var expr = macro createUIElement($v{name}, $obj, $a{content});
		if (xml.has.id)
			return macro cast ($i{prefix + xml.att.id} = ${expr});
		else
			return macro ${expr};
	}
	
	private static function addStyle(name:String, attrs:Map<String, String>, style:Style):String {
		if (!style.exists(name)) return name;
		var n = name;
		if (style[name].exists('extends'))
			n = addStyle(style[name]['extends'], attrs, style);
		for (k in style[name].keys()) if (k != 'extends') {
			var s:String = style[name][k];
			var att1 = attrs[k] != null && attrs[k].charAt(0) == ',';
			var att2 = s.charAt(0) == ',';
			attrs[k] = switch [att1, att2] {
				case [false, false]:
					s;
				case [false, true]:
					attrs[k] != null ? attrs[k] + s : StringTools.ltrim(s.substr(1));
				case [true, false]:
					s + attrs[k];
				case [true, true]:
					StringTools.ltrim(attrs[k]) + s;
			}
		}
		return n;
	}
	
	private static function addId(fields:Array<Field>, xml:Fast, style:Style, types:Map<String, ComplexType>, prefix:String = ''):Void {
		
		if (xml.name == 'include') {
			var xml = getXml(joinPath(gpath, xml.innerData));
			addId(fields, xml, style, types, prefix);
		}
		
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
	
	private static function joinPathA(a:String, b:String):String {
		return [for (b in b.split(',')) joinPath(a, StringTools.ltrim(b))].join(', ');
	}
	
	private static function joinPath(a:String, b:String):String {
		return b.charAt(0) == '/' ? b.substr(1) : (a != '' ? a + '/' : '') + b;
	}
	#end
	
}