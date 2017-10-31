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

class LangTable
{
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