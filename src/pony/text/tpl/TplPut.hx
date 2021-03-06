package pony.text.tpl;

import pony.magic.SuperPuper;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData.TplShortTag;
import pony.text.tpl.TplData.TplTag;

/**
 * TplPut
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class TplPut<T1, T2> implements ITplPut implements SuperPuper {
	
	public var a:T1;
	public var b:T2;
	public var parent:ITplPut = null;
	
	public function new(a:T1, b:T2, parent:ITplPut) {
		this.a = a;
		this.b = b;
		this.parent = parent;
	}
	
	@:async
	public function tplData(d:TplData):String {
		if (d == null) return null;
		var r:String = '', nt:String = null;
		if (d.length > 0) for(e in d)
			switch (e) {
				case Text(t1):
					if (nt!=null) {
						var tt = killSpaceLeft(t1);
						if (tt != t1)
							r = killSpaceRight(r) + nt + tt;
						else
							r = r + nt + t1;
						nt = null;
					} else
						r += t1;
				case Tag(t2):
					var s:String = @await tplTag(t2);
					
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
					var s:String = @await tplShortTag(t3);
					
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
	
	private static function tagTrim(r:String, s:String, nt:String): { r:String, f:String } {
		if (s == '') {
			var nr = killSpaceRight(r);
			if (nr != r) nt = s;
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
					} else {
						s = killSpaceRight(s.substr(0, s.length -1));
					}
				} else if (ch == '\n') {
					s = s.substr(0, s.length -1);
				}
			}
			
		}
		return {r: r+s, f: nt};
	}
	
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
	
	private static function killSpaceRightSub(s:String, r:Int):String {
		for (i in (r + 1)...s.length)
			if (s.charAt(i) != ' ' && s.charAt(i) != '	')
				return s;
		return s.substr(0, r+1);
	}
	
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
			return s;
	}
	
	private static function killSpaceLeftSub(s:String, r:Int):String {
		for (i in 0...r)
			if (s.charAt(i) != ' ' && s.charAt(i) != '	')
				return s;
		return s.substr(r+1);
	}
	
	@:async
	public function tplTag(d:TplTag):String {
		var na:Map<String,String> = new Map<String,String>();
		if (d.args.iterator().hasNext()) for(k in d.args.keys())
			na.set(k, @await tplData(d.args.get(k)));
			
		var arg:String = @await tplData(d.arg);
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
		return @await o.tag(name, content, arg, na, null);
	}
	
	@:async @:puper
	public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		return if (parent == null)
			@await shortTag(name, arg);
		else {
			var r:String = @await parentTag(name, content, arg, args, kid);
			if (r == '%'+name+'%')
				@await shortTag(name, arg);
			else
				r;
		}
	}
	/*
	@:async
	public function tagHelper(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		return @await tag(name, content, arg, args, kid);
	}
	*/
	@:async
	private inline function parentTag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		return @await parent.tag(name, content, arg, args, kid == null ? this : kid);
	}
	
	@:async
	public function tplShortTag(d:TplShortTag):String {
		var arg:String = @await tplData(d.arg);
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
			return @await o.shortTag(name, arg, null);
		else
			return @await tag(name, content, arg, new Map<String, String>());
	}
	
	@:async @:puper
	public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (parent == null)
			return '%' + name + '%';
		else
			return @await parentShortTag(name, arg, kid);
	}
	
	@:async
	private function parentShortTag(name:String, arg:String, ?kid:ITplPut):String {
		return @await parent.shortTag(name, arg, kid == null ? this : kid);
	}
	
	@:async
	public function sub(o:Dynamic, d:Dynamic, ?cl:Class<ITplPut>, ?content:TplData):String {
		return @await Tpl.go(o, d, this, cl, content);
	}
	
	@:async
	public function many(?d:Iterable<Dynamic>, ?i:Iterator<Dynamic>, cl:Dynamic, content:TplData, ?delemiter:String):String {
		return @await manyEasy(d, i,
			function(e:Dynamic, cb:String->Void):Void return sub(this, e, cl, content, cb),
			delemiter);
	}
	
	private static function getString(v:Dynamic, cb:String->Void):Void cb(Std.string(v));
	
	@:async
	public static function manyEasy(?o:Iterable<Dynamic>, ?i:Iterator<Dynamic>, ?func:Dynamic->(String->Void)->Void, ?delemiter:String):String {
		if (func == null) {
			func = getString;
		}
		if (o != null)
			i = o.iterator();
		if (delemiter == null) {
			var r:String = '';
			var f:Bool = true;
			
			for (e in i)
				if (f) {
					f = false;
					r += killSpaceRight(@await func(e));
				} else if (i.hasNext())
					r += killSpaceRight(killSpaceLeft(@await func(e)));
				else
					r += (killSpaceLeft(@await func(e)));
			return r;
		} else {
			var r:String = '';
			var f:Bool = true;
			for (e in i) {
				if (f) {
					f = false;
					r += (@await func(e));
				} else
					r += delemiter + (killSpaceLeft(@await func(e)));
			}
			return r;
		}
	}
	
}