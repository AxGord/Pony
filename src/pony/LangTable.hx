package pony;

import pony.fs.Dir;
import pony.fs.File;

using pony.Tools;
using pony.text.TextTools;
using Lambda;

typedef LangInfo = {
	title: String,
	author: String
}

/**
 * LangTable
 * @author AxGord <axgord@gmail.com>
 */
class LangTable {

	//private var h:Hash < Array<String> > ;
	private var defaultLang:String;
	public var langs:Map<String, LangInfo>;
	
	private var h:Map <String, Array<String> > ;
	
	public function new(dir:Dir, defaultLang:String='en')
	{
		langs = new Map<String, LangInfo>();
		this.defaultLang = defaultLang;
		//h = new Hash < Array<String> > ();
		h = new Map();
		for (f in dir.files('txt')) {
			var li:LangInfo = null;
			var a:Array<String> = [];
			for (sf in f.takeExists) {
				var sf:File = sf;
				var lines:Array<String> = sf.content.lines();
				if (lines[0].charAt(0) == '!') {
					var s:String = lines.shift();
					if (li == null) {
						li = { title: f.shortName, author: null };
						for (e in s.substr(1).split(',')) {
							var aa:Array<String> = e.split(':').map(StringTools.trim);
							switch (aa[0]) {
								case 'title': li.title = aa[1];
								case 'author': li.author = aa[1];
								default: throw 'Unknown attr '+aa[0];
							}
						}
					}
				}
				a = a.concat(lines.map(TextTools.bigFirst));
				
			}
			h.set(f.shortName, a);
			if (li != null) {
				langs.set(f.shortName, li);
			} else {
				langs.set(f.shortName, {title: f.shortName, author: null});
			}
		}
		/*
		new Files<Array<String>>(dir, 'txt', function(f:File):Array<String> {
			var li:LangInfo = null;
			var a:Array<String> = [];
			for (sf in f.listToFileArray()) if (sf.exists) {
				var lines:Array<String> = sf.content.lines();
				if (lines[0].charAt(0) == '!') {
					var s:String = lines.shift();
					if (li == null) {
						li = { title: f.withoutExtension(), author: null };
						for (e in s.substr(1).split(',')) {
							var aa:Array<String> = e.split(':').map(StringTools.trim);
							switch (aa[0]) {
								case 'title': li.title = aa[1];
								case 'author': li.author = aa[1];
								default: throw 'Unknown attr '+aa[0];
							}
						}
					}
				}
				a = a.concat(lines.map(StringExtensions.bigFirst));
			}
			//h.set(f.withoutExtension(), a);
			if (li != null) {
				langs.set(f.withoutExtension(), li);
			} else {
				langs.set(f.withoutExtension(), {title: f.withoutExtension(), author: null});
			}
			return a;
		});
		*/
	}
	
	public function translate(from:String, to:String, text:String):String {
		if (!h.exists(from)) return text;
		var s:String = text.bigFirst();
		var i:Int = h.get(from).indexOf(s);
		if (i == -1) return text;
		if (!h.exists(to))
			to = defaultLang;
		var a = h.get(to);
		var r:String = a[i];
		return s == text ? r : r.smallFirst();
	}
	
}