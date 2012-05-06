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

import pony.magic.async.AsyncAutoAll;
import pony.tpl.Tpl;
import pony.magic.Declarator;

/**
 * ...
 * @author AxGord
 */

class TplPut<T1, T2> implements ITplPut, implements Declarator, implements AsyncAutoAll
{
	@arg public var data:T1;
	@arg public var datad:T2;
	@arg public var parent:ITplPut = null;
	
	public function tplData(d:TplData):String {
		if (d == null) return null;
		var r:String = '', nt:String = null;
		for (e in d)
			switch (e) {
				case Text(t1):
					if (nt!=null) {
						var tt = killSpaceLeft(t1);
						if (tt != t1)
							r = killSpaceRight(r) + nt + tt;
						else
							r = r + nt + t1;
						nt = null;
						//r += killSpaceLeft(t1);
					} else
						r += t1;
				case Tag(t2):
					var s:String = tplTag(t2);
					
					if (nt!=null) {
						var tt = killSpaceLeft(s);
						if (tt != s)
							r = killSpaceRight(r) + nt;
						else
							r += nt;
						nt = null;
					}
					
					var o = tagTrim(r, s, nt);
					nt = o.f;
					r = o.r;
				case ShortTag(t3):
					var s:String = tplShortTag(t3);
					
					if (nt!=null) {
						var tt = killSpaceLeft(s);
						if (tt != s)
							r = killSpaceRight(r) + nt;
						else
							r += nt;
						nt = null;
					}
					
					var o = tagTrim(r, s, nt);
					nt = o.f;
					r = o.r;
			}
		return r;
	}
	
	@NotAsyncAuto
	private static function tagTrim(r:String, s:String, nt:String): { r:String, f:String } {
		if (s == '') {
			var nr = killSpaceRight(r);
			if (nr != r) nt = s;
			//r = '';
			//r = nr;
			//trace(r);
		} else {
			{
				var ch:String = s.charAt(0);
				var ch2:String = s.charAt(1);
				
				if (ch == '\r') {
					if (ch2 == '\n') {
						r = killSpaceRight(r);
						s = s.substr(2);
					} else {
						var nr = killSpaceRight(r);
						if (nr != r)
							s = s.substr(1);
						r = nr;
					}
				} else if (ch == '\n') {
					r = killSpaceRight(r);
					s = s.substr(1);
				}
			}
			{
				var ch:String = s.charAt(s.length - 1);
				var ch2:String = s.charAt(s.length - 2);
				if (ch == '\r') {
					if (ch2 == '\n') {
						s = s.substr(0, s.length - 2);
						//nt = true;
					} else {
						//s = killSpaceRight(s);
						s = killSpaceRight(s.substr(0, s.length -1));
						//if (ns != s)
						
						//nt = true;
					}
				} else if (ch == '\n') {
					s = s.substr(0, s.length -1);
					//nt = true;
				}
			}
			
		}
		//r += s;
		return {r: r+s, f: nt};
	}
	
	@NotAsyncAuto
	private static function killSpaceRight(s:String):String {
		var n:Int = (s.lastIndexOf('\n'));
		var r:Int = (s.lastIndexOf('\r'));
		if (n == -1) {
			if (r == -1)
				return s;
			else
				return killSpaceRightSub(s, r);
		} else if (r == -1) {
			return killSpaceRightSub(s, n);
		} else if (r + 1 == n) {
			return killSpaceRightSub(s, n);
		} else
			return s;
	}
	
	@NotAsyncAuto
	private static function killSpaceRightSub(s:String, r:Int):String {
		for (i in (r + 1)...s.length)
			if (s.charAt(i) != ' ' && s.charAt(i) != '	')
				return s;
		return s.substr(0, r+1);
	}
	
	@NotAsyncAuto
	private static function killSpaceLeft(s:String):String {
		var n:Int = (s.indexOf('\n'));
		var r:Int = (s.indexOf('\r'));
		if (n == -1) {
			if (r == -1)
				return s;
			else
				return killSpaceLeftSub(s, r);
		} else if (r == -1) {
			return killSpaceLeftSub(s, n);
		} else if (r + 1 == n) {
			if (r != 0)
				return killSpaceLeftSub(s, r);
			else
				return killSpaceLeftSub(s, r).substr(1);
		} else
			return s;//todo
	}
	
	@NotAsyncAuto
	private static function killSpaceLeftSub(s:String, r:Int):String {
		for (i in 0...r)
			if (s.charAt(i) != ' ' && s.charAt(i) != '	')
				return s;
		return s.substr(r+1);
	}
	
	public function tplTag(d:TplTag):String {
		var na:Hash<String> = new Hash<String>();
		for (k in d.args.keys())
			na.set(k, tplData(d.args.get(k)));
		var arg:String = tplData(d.arg);
		var content:TplData = d.content;
		var n:Array<String> = d.name.name.copy();
		var name:String = null;
		if (n.length > 1) {
			name = n.shift();
			content = [Tag( { name: {name: n, up: 0}, args: d.args, arg: d.arg, content: content } )];
			
		} else
			name = n[0];
		
		var o:ITplPut = this;
		for (i in 0...d.name.up) {
			if (o.parent == null)
				throw 'This is root lvl, cant get up';
			o = o.parent;
		}
		return o.tag(name, content, arg, na, null);
	}
	
	@BuildSuper
	public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String {
		return if (parent == null)
			shortTag(name, arg);
		else {
			var r:String = parentTag(name, content, arg, args, kid);
			if (r == '%'+name+'%')
				shortTag(name, arg);
			else
				r;
		}
	}
	
	private inline function parentTag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String {
		return parent.tag(name, content, arg, args, kid == null ? this : kid);
	}
	
	public function tplShortTag(d:TplShortTag):String {
		var arg:String = tplData(d.arg);
		var content:TplData = null;
		var n:Array<String> = d.name.name.copy();
		var name:String = null;
		if (n.length > 1) {
			name = n.shift();
			content = [ShortTag( { name: {name: n, up: 0}, arg: d.arg} )];
			
		} else
			name = n[0];
		
		var o:ITplPut = this;
		for (i in 0...d.name.up) {
			if (o.parent == null)
				throw 'This is root lvl, cant get up';
			o = o.parent;
		}
		if (content == null)
			return o.shortTag(name, arg, null);
		else
			return tag(name, content, arg, new Hash<String>());
	}
	
	@BuildSuper
	public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (parent == null)
			return '%' + name + '%';
		else
			return parentShortTag(name, arg, kid);
	}
	
	private function parentShortTag(name:String, arg:String, ?kid:ITplPut):String {
		return parent.shortTag(name, arg, kid == null ? this : kid);
	}
	
	public function sub(o:Dynamic, d:Dynamic, ?cl:Class<Dynamic>, ?content:TplData):String {
		return Tpl.go(o, d, this, cl, content);
	}
	
	public function many(?d:Iterable<Dynamic>, ?i:Iterator<Dynamic>, cl:Dynamic, content:TplData, ?delemiter:String):String {
		/*if (delemiter == null) {
			var r:String = '';
			for (e in d)
				r += tagTrim(sub(this, e, cl, content));
			return r;
		} else {*/
			/*var r:String = '', f:Bool = true;
			for (e in d) {
				if (f) {
					f = false;
					r += sub(this, e, cl, content);
				} else {
					r += (delemiter == null ? '' : delemiter) + killSpaceLeft(sub(this, e, cl, content));
				}
			}
			return r;*/
		//}
		
		return manyEasy(d, i,
			function(e) return sub(this, e, cl, content),
			delemiter);
	}
	
	public function manyAsync(?d:Iterable<Dynamic>, ?i:Iterator<Dynamic>, cl:Dynamic, content:TplData, ?delemiter:String, ok:String->Void, error:Dynamic->Void):Void {
		manyEasyAsync(d, i,
			function(e, ok, error) subAsync(this, e, cl, content, ok, error),
			delemiter, ok, error);
	}
	
	public static function manyEasy(?o:Iterable<Dynamic>, ?i:Iterator<Dynamic>, ?func:Dynamic->String, ?delemiter:String):String {
		if (func == null) {
			func = function(v:Dynamic):String return v;
		}
		if (o != null)
			i = o.iterator();
		if (delemiter == null) {
			var r:String = '', f:Bool = true;
			
			for (e in i)
				if (f) {
					f = false;
					r += killSpaceRight(func(e));
				} else if (i.hasNext())
					r += killSpaceRight(killSpaceLeft(func(e)));
				else
					r += (killSpaceLeft(func(e)));
			return r;
		} else {
			var r:String = '', f:Bool = true;
			for (e in i) {
				if (f) {
					f = false;
					r += (func(e));
				} else
					r += delemiter + (killSpaceLeft(func(e)));
			}
			return r;
		}
	}
	
	public static function manyEasyAsync(?o:Iterable<Dynamic>, ?i:Iterator<Dynamic>, ?func:Dynamic->Dynamic->Dynamic->Void, ?delemiter:String, ok:String->Void, error:Dynamic->Void):Void {
		if (func == null) {
			func = function(v:Dynamic, ok:Dynamic->Void, error:Dynamic->Void):Void ok(v);
		}
		if (o != null)
			i = o.iterator();
		if (delemiter == null) {
			var r:String = '', f:Bool = true;
			var step:Void->Void = null;
			step = function() {
				if (i.hasNext()) {
					func(i.next(), function(s:String) {
						if (f) {
							f = false;
							r += killSpaceRight(s);
						} else if (i.hasNext())
							r += killSpaceRight(killSpaceLeft(s));
						else
							r += killSpaceLeft(s);
						step();
					}, error);
				} else {
					ok(r);
				}
			};
		} else {
			var r:String = '', f:Bool = true;
			
			var step:Void->Void = null;
			step = function() {
				if (i.hasNext()) {
					func(i.next(), function(s:String) {
						if (f) {
							f = false;
							r += s;
						} else
							r += delemiter + killSpaceLeft(s);
						step();
					}, error);
				} else {
					ok(r);
				}
			};
		}
	}
	
}