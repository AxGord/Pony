package pony.text.tpl;

import pony.Fast;
import pony.fs.Unit;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData.TplStyle;
import pony.text.tpl.WithTplPut;
import pony.text.tpl.TplDir;
import pony.fs.Dir;
import pony.fs.File;
import pony.text.XmlTools;
using pony.Tools;

typedef Manifest = {
	title: String,
	author:String,
	email: String,
	www:String,
	_extends:Array<String>,
	version: { major:Int, minor:Int },
	license: String,
	language: String
}

/**
 * TplSystem
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class TplSystem {
	
	private var pages:TplDir;
	public var includes:TplDir;
	public var manifest:Manifest;
	public var name:String;
	public var _static:Map<String, File>;

	public function new(dir:Dir, ?c:Class<ITplPut>, o:Dynamic, ?s:TplStyle)
	{
		manifest = null;
		name = (dir:Unit).name;
		pages = new TplDir(dir + 'pages', c, o, s);
		includes = new TplDir(dir + 'includes', TplPut, null, s);
		_static = [for (e in ((dir + 'static'):Dir).contentRecursiveFiles()) e.name => e];
	}
	
	@:async
	public function gen(n:String, ?d:Dynamic):String {
		return @await pages.gen(n, d, new PagesPut(this, null, null));
	}
	
	public inline function exists(n:String):Bool return pages.exists(n);
	
	public static function parseManifest(f:File):Manifest {
		var x:Fast = XmlTools.fast(f.content).node.manifest;
		var g = function(n:String) return x.hasNode.resolve(n) ? StringTools.trim(x.node.resolve(n).innerData) : null;
		return {
			title: g('title'),
			author: g('author'),
			email: g('email'),
			www: g('www'),
			version:
				{
					if (x.hasNode.resolve('version')) {
						var v:Array<Int> = x.node.resolve('version').innerData.split('.').map(StringTools.trim).map(Std.parseInt);
						{major: v[0], minor: v[1] };
					} else
						null;
				},
			_extends: x.hasNode.resolve('extends') ? x.node.resolve('extends').innerData.split(',').map(StringTools.trim) : [],
			license: g('license'),
			language: g('language')
		};
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class PagesPut extends TplPut<TplSystem, {}> {
	
	private var included:List<String> = new List<String>();
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'htmlEscape') {
			return StringTools.htmlEscape(@await kid.tplData(content));
		} else if (name == 'include') {
			arg = StringTools.replace(arg, '-', '/');
			if (args.exists('once')) {
				if (Lambda.indexOf(included, arg) == -1) {
					included.push(arg);
				} else {
					return '';
				}
			}
			var d:TplDir = a.includes;
			if (d.exists(arg)) {
				var c:String = null;
				if (kid != null) c = @await kid.tplData(content);
				else c = @await tplData(content);
				return @await d.gen(arg, null, new IncludePut({content: c, args: args}, null, kid));
			}
			else
				return "! Not found include " + arg + " !";
		} else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (name == 'include')
			return @await tag(name, null, arg, new Map<String, String>(), kid);
		else
			return @await super.shortTag(name, arg, kid);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class IncludePut extends TplPut<{content:String, args: Map<String, String>}, {}> {
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'content') {
			return a.content;
		} else if (a.args.exists(name)) {
			var r:String = a.args.get(name);
			return r;
		} else
			return @await super.shortTag(name, arg, kid);
	}
}