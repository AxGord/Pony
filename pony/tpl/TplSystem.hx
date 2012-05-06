/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.tpl;

import haxe.xml.Fast;
import pony.magic.async.AsyncAuto;
import pony.tpl.Tpl;
import pony.tpl.WithTplPut;
import pony.tpl.TplDir;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Files;
import pony.XMLTools;

using pony.Ultra;

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

//using Lambda;
//using StringTools;

/**
 * ...
 * @author AxGord
 */

class TplSystem implements AsyncAuto
{
	private var pages:TplDir;
	public var includes:TplDir;
	public var _static:Files<File>;
	public var manifest:Manifest;
	public var name:String;

	public function new(dir:Dir, ?c:Class<Dynamic>, o:Dynamic, ?s:TplStyle)
	{
		manifest = null;
		name = dir.name;
		var pp:PagesPut = new PagesPut(this, null);
		pages = new TplDir(dir.dir('pages'), c, o, s);
		includes = new TplDir(dir.dir('includes'), TplPut, null, s);
		_static = new Files<File>(dir.dir('static'));
	}
	
	@AsyncAuto
	public inline function gen(n:String, ?d:Dynamic):String {
		return pages.gen(n, d, new PagesPut(this, null, null));
	}
	
	public inline function exists(n:String):Bool return pages.exists(n)
	
	public static function parseManifest(f:File):Manifest {
		var x:Fast = XMLTools.fast(f);
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

class PagesPut extends TplPut<TplSystem, Void> {
	
	private var included:List<String> = new List<String>();
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		if (name == 'htmlEscape') {
			return StringTools.htmlEscape(kid.tplData(content));
		} else if (name == 'include') {
			arg = StringTools.replace(arg, '-', '/');
			if (args.exists('once')) {
				if (Lambda.indexOf(included, arg) == -1) {
					included.push(arg);
				} else {
					return '';
				}
			}
			var d:TplDir = data.includes;
			if (d.exists(arg)) {
				var c:String = kid.tplData(content);
				return d.gen(arg, null, new IncludePut({content: c, args: args}, null, kid));
			}
			else
				return "! Not found include " + arg + " !";
		} else
			return super.tag(name, content, arg, args, kid);
	}
	
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (name == 'include')
			return tag(name, null, arg, new Hash<String>(), kid);
		else
			return super.shortTag(name, arg, kid);
	}
	
}

class IncludePut extends TplPut<{content:String, args: Hash<String>}, Void> {
	
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'content') {
			return data.content;
		} else if (data.args.exists(name)) {
			var r:String = data.args.get(name);
			return r;
		} else
			return super.shortTag(name, arg, kid);
	}
}