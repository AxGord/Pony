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
package pony;

import haxe.macro.Context;
import haxe.macro.Expr;

using Reflect;
using Lambda;
/**
 * ...
 * @author AxGord
 */
class Tools {

	
	macro public static function getBuildDate() {
        var date = Date.now().toString();
        return Context.makeExpr(date, Context.currentPos());
    }
	
	
	public static function equal(a:Dynamic, b:Dynamic):Bool {
		if (a == b) return true;
		for (f in a.fields())
			if (!b.hasField(f) || a.field(f) != b.field(f))
				return false;
		return true;
	}
	
	inline public static function percentCalc(p:Float, min:Float, max:Float):Float return (max - min) * p + min;
	
	
}

class ArrayTools {
	
	public static function equal<T>(a:Array<T>, b:Array<T>):Bool {
		if (a == b) return true;
		for (i in 0...a.length) if (a[i] != b[i]) return false;
		return true;
	}
	
	public static function thereIs<T>(a:Iterable<Array<T>>, b:Array<T>):Bool {
		for (e in a) if (equal(e, b)) return true;
		return false;
	}
	
}

class FloatTools {
	
	macro public static function toFixed(ex:Expr, mask:String):Expr {
		var s:String;
		if (mask.indexOf('.') != -1) {
			s = '.';
		} else if (mask.indexOf(',') != -1) {
			s = ',';
		} else s = '!';
		var a:Array<String> = s == '!' ? [mask, ''] : mask.split(s);
		if (s == '!') s = '.';
		var beginS = a[0].length > 0 ? a[0].charAt(0) : '0';
		var endS = a[1].length > 0 ? a[1].charAt(0) : '0';
		return macro FloatTools._toFixed($a{[$ex, $v{a[1].length}, $v{a[0].length}, $v{s}, $v{beginS}, $v{endS}]});
	}
	
	public static function _toFixed(v:Float, n:Int, begin:Int = 0, d:String='.', beginS:String='0', endS:String='0'):String {
		if (begin != 0) {
			var s:String = _toFixed(v, n, d, beginS, endS);
			var a = s.split(d);
			var d = begin - a[0].length;
			return StringTls.repeat(beginS, d) + s;
		}
		
		if (n == 0) return Std.string(Std.int(v));
		var p:Float = Math.pow(10, n);
		v = Std.int(v * p) / p;
		var s:String = Std.string(v);
		var a:Array<String> = s.split('.');
		if (a.length <= 1)
			return s + d + StringTls.repeat(endS, n);
		else
			return a[0] + d + a[1] + StringTls.repeat(endS, n - a[1].length);
	}
	
	inline public static function inRange(v:Float, min:Float, max:Float):Bool return min <= v && v <= max;
	
	inline public static function approximately(a:Float, b:Float, range:Float=1):Bool return inRange(a, b - range, b + range);
}

class StringTls {
	
	public static function repeat(s:String, count:Int):String {
		var r:String = '';
		while (count-->0) r += s;
		return r;
	}
	
	inline public static function isTrue(s:String):Bool return StringTools.trim(s.toLowerCase()) == 'true';
	
	public static function explode(s:String, delimiters:Array<String>):Array<String> {
		var r:Array<String> = [s];
		for (d in delimiters) {
			var sr:Array<String> = [];
			for ( e in r ) for ( se in e.split(d) ) if (se != '') sr.push(se);
			r = sr;
		}
		return r;
	}
	
}

class XmlTools {
	inline public static function isTrue(x:haxe.xml.Fast, name:String):Bool return x.has.resolve(name) && StringTls.isTrue(x.att.resolve(name));
}