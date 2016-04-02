/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import haxe.Constraints.Function;
import haxe.CallStack;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Eof;
import haxe.Log;
import haxe.xml.Fast;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end
import pony.text.TextTools;

using Reflect;
using Lambda;

/**
 * Tools
 * @author AxGord
 */
class Tools {
	#if macro
	private static var _getBuildDate:String;
	#end
	macro public static function getBuildDate() {
        if (_getBuildDate == null) _getBuildDate = Date.now().toString();
        return Context.makeExpr(_getBuildDate, Context.currentPos());
    }
	
	/**
	 * Null Or Empty
	 * @author nadako <nadako@gmail.com>
	 */
	inline static public function nore<T:{var length(default,null):Int;}>(v:T):Bool
		return v == null || v.length == 0;
	
	inline public static function or<T>(v1:T, v2:T):T return v1 == null ? v2 : v1;
	
	/**
	 * with
	 * @author Simn <simon@haxe.org>
	 * @link https://gist.github.com/Simn/87948652a840ff544a22
	 */
	macro static public function with(e1:Expr, el:Array<Expr>) {
		var tempName = "tmp";
		var acc = [macro var $tempName = $e1];
		var eThis = macro $i{tempName};
		for (e in el) {
			var e = switch (e) {
				case macro $i{s}($a{args}):
					macro $eThis.$s($a{args});
				case macro $i{s} = $e:
					macro $eThis.$s = $e;
				case macro $i{s} += $e:
					macro $eThis.$s += $e;
				case macro $i{s} -= $e:
					macro $eThis.$s -= $e;
				case macro $i{s} *= $e:
					macro $eThis.$s *= $e;
				case macro $i{s} /= $e:
					macro $eThis.$s /= $e;
				case _:
					Context.error("Don't know what to do with " + e.toString(), e.pos);
			}
			acc.push(e);
		}
		return macro $b{acc};
	}
	
	static public function randomString(string_length:Int = 36):String {
		var chars:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
		var randomstring:String = '';
		for (i in 0...string_length) {
			var rnum:Int = Math.floor(Math.random() * chars.length);
			randomstring += chars.charAt(rnum);
		}
		return randomstring;
	}
	
	/**
	 * Compare two value
	 * @author	deep <system.grand@gmail.com>
	 * @param	a
	 * @param	b
	 * @param	maxDepth -1 - infinity depth
	 * @return
	 */
	public static function equal(a:Dynamic, b:Dynamic, maxDepth:Int = 1):Bool {
		if (a == b) return true;
		if (maxDepth == 0) return false;
		var type = Type.typeof(a);
		switch (type) {
			case TInt, TFloat, TBool, TNull: return false;
			case TFunction: 
				try {
					return Reflect.compareMethods(a, b);
				} catch (_:Dynamic) {
					return false;
				}
			case TEnum(t): 
				if (t != Type.getEnum(b)) return false;
				if (Type.enumIndex(a) != Type.enumIndex(b)) return false;
				var a = Type.enumParameters(a);
				var b = Type.enumParameters(b);
				if (a.length != b.length) return false;
				for (i in 0...a.length) 
					if (!equal(a[i], b[i], maxDepth - 1)) return false;
				return true;
			case TObject: if (Std.is(a, Class)) return false;
			case TUnknown:
			case TClass(t):
				if (t == Array) {
					if (!Std.is(b, Array)) return false;
					if (a.length != b.length) return false;
					for (i in 0...a.length) 
						if (!equal(a[i], b[i], maxDepth - 1)) return false;
					return true;
				}
		}
		// a is Object on Unknown or Class instance
		switch (Type.typeof(b)) {
			case TInt, TFloat, TBool, TFunction, TEnum(_), TNull: return false;
			case TObject: if (Std.is(b, Class)) return false;
			case TClass(t): if (t == Array) return false;
			case TUnknown:
		}

		var fields:Array<String> = a.fields();
		if (fields.length == b.fields().length) {
			if (fields.length == 0) return true;
			for (f in fields)
				if (!b.hasField(f) || !equal(a.field(f), b.field(f), maxDepth - 1))
					return false;
				return true;
			}
		return false;
    }
	
	public static function clone<T:Dynamic>(obj:T):T {
		return switch Type.typeof(obj) {
			case TEnum(t):
				Type.createEnumIndex(t, Type.enumIndex(obj), [for (e in Type.enumParameters(obj)) clone(e)]);
			case TObject if (!Std.is(obj, Class)):
				_clone(obj);
			case TClass(t):
				if (t == Array) {
					var obj:Array<Dynamic> = cast obj;
					cast [for (i in 0...obj.length) clone(obj[i])];
				} else {
					cast _clone(obj);
				}
			case _:
				obj;
		}
	}
	
	private static function _clone<T:Dynamic>(obj:T):T {
		var n = {};
		for (p in obj.fields())
			n.setField(p, clone(obj.field(p)));
		return cast n;
	}
	
	public static function superIndexOf<T>(it:Iterable<T>, v:T, maxDepth:Int = 1):Int {
		var i:Int = 0;
		if (maxDepth == 0) //Avoiding extra function calls on maxDepth == 0
		{
			for (e in it) {
				if (e == v) return i;
				i++;
			}
		}
		else
		{
			for (e in it) {
				if (equal(e, v, maxDepth)) return i;
				i++;
			}
		}
		return -1;
	}
	
	public static function superMultyIndexOf<T>(it:Iterable<T>, av:Array<T>, maxDepth:Int = 1):Int {
		var i:Int = 0;
		for (e in it) {
			for (v in av) if (equal(e, v, maxDepth)) return i;
			i++;
		}
		return -1;
	}
	
	public static function multyIndexOf<T>(it:Iterable<T>, av:Array<T>):Int {
		var i:Int = 0;
		for (e in it) {
			for (v in av) if (e == v) return i;
			i++;
		}
		return -1;
	}
	
	/**
	 * @author BoBaH6eToH
	 * @param	b
	 * @return
	 */
	public static function cut(inp:BytesInput):BytesInput {
		var out:BytesOutput = new BytesOutput();
		var cntNull:Int = 0;
		var flagNull:Bool = true;
		var cur:Int = -99;
		while (true)
		{
			try {
				cur = inp.readByte();
			} catch (_:Dynamic) {
				break;
			}
			if ( cur == 0 )
			{
				if ( !flagNull )
					flagNull = true;
				cntNull++;
			}
			else
			{
				if ( flagNull )
					while ( cntNull-- > 0 )
						out.writeByte( 0 );
				flagNull = false;
				out.writeByte ( cur );
			}
		}
		out.close();
		return new BytesInput(out.getBytes());
	}
	
	macro public static function currentFile():Expr
	{
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f);
		return macro $v{f};
	}
	
	macro public static function currentDir():Expr
	{
		var f:String = Context.getPosInfos(Context.currentPos()).file;
		f = sys.FileSystem.fullPath(f).split('\\').slice(0, -1).join('/') + '/';
		return macro $v{f};
	}
	
	public static inline function exists<T>(a:Iterable<T>, e:T):Bool return a.indexOf(e) != -1;
	
	public static inline function bytesIterator(b:Bytes):Iterator<Byte> {
		var i:Int = 0;
		return {
			hasNext: function():Bool return i < b.length,
			next: function():Byte return b.get(i++)
		};
	}
	
	public static inline function bytesInputIterator(b:BytesInput):Iterator<Byte> {
		var i:Null<Int> = 0;
		return {
			hasNext: function():Bool return b.position < b.length,
			next: function():Byte return b.readByte()
		};
	}
	
	macro public static function ifsw(e:Expr):Expr {
		var d:Array<Expr> = [];
		switch e.expr {
			case ESwitch(ex, cases, edef):
				for (c in cases) {
					var cond:Expr = { expr: EBinop(OpEq, ex, c.values[0]), pos: Context.currentPos() };
					d.push(macro if ($cond) ${c.expr});
				}
			default: throw 'This is not switch';
		}
		//return macro $b{d};
		return {expr: EBlock(d), pos: Context.currentPos()};// Context.makeExpr(d, Context.currentPos());
	}
	
	public static function setFields(a:{}, b:{}):Void {
		for (p in b.fields()) {
			var d:Dynamic = b.field(p);
			if (d.isObject() && !Std.is(d, String))
				setFields(a.field(p), d);
			else
				a.setField(p, d);
		}
	}
	
	inline public static function copyFields(a:{}, b:{}):Void for (p in b.fields()) a.setField(p, b.field(p));
	
	public static function parsePrefixObjects(a:Dynamic<String>, delimiter:String = '_'):Dynamic<Dynamic> {
		var result:Dynamic<Dynamic> = { };
		for (f in a.fields()) {
			var d = f.split(delimiter);
			var obj = result;
			for (i in 0...d.length - 1) {
				if (obj.hasField(d[i])) {
					obj = obj.field(d[i]);
				} else {
					var newObj = { };
					obj.setField(d[i], newObj);
					obj = newObj;
				}
			}
			obj.setField(d.pop(), a.field(f));
		}
		return result;
	}
	
	public static function convertObject(a:{}, fun:Dynamic->Dynamic):Dynamic<Dynamic> {
		var result:Dynamic<Dynamic> = { };
		for (p in a.fields()) {
			var d:Dynamic = a.field(p);
			if (d.isObject() && !Std.is(d, String))
				result.setField(p, convertObject(d, fun));
			else
				result.setField(p, fun(d));
		}
		return result;
	}
	
	inline public static function traceThrow(e:String):Void {
		Log.trace(e, null);
		Log.trace(CallStack.toString(CallStack.exceptionStack()), null);
	}
	
	inline public static function writeStr(b:BytesOutput, s:String):Void {
		b.writeInt32(s.length);
		b.writeString(s);
	}
	
	static public function readStr(b:BytesInput):String {
		try {
			return b.readString(b.readInt32());
		} catch (_:Dynamic) return null;
	}
	
	@:generic inline static public function sget<A,B:{function new():Void;}>(m:Map<A,B>, key:A):B
		return m.exists(key) ? m[key] : m[key] = new B();
	#if !cs
	inline static public function reverse<K:Dynamic,V:Dynamic>(map:Map<K, V>):Map<V, K> return [for (k in map.keys()) map[k] => k];
	#end
	inline static public function min(it:IntIterator):Int return it.field('min');
	inline static public function max(it:IntIterator):Int return it.field('max');
	inline static public function copy(it:IntIterator):IntIterator return it.field('min')...it.field('max');
	
	public static function nullFunction0():Void return;
	public static function nullFunction1(_:Dynamic):Void return;
	public static function nullFunction2(_:Dynamic, _:Dynamic):Void return;
	public static function nullFunction3(_:Dynamic, _:Dynamic, _:Dynamic):Void return;
	public static function nullFunction4(_:Dynamic, _:Dynamic, _:Dynamic, _:Dynamic):Void return;
	public static function nullFunction5(_:Dynamic, _:Dynamic, _:Dynamic, _:Dynamic, _:Dynamic):Void return;
	public static function errorFunction(e:Dynamic):Void throw e;
	
	public static function own(c1:Class<Dynamic>, c2:Class<Dynamic>):Bool {
		var p = c2;
		while (p != null) {
			if (c1 == p) return true;
			p = Type.getSuperClass(c2);
		}
		return false;
	}
	
	#if (js||flash)
	@:extern inline
	#end
	public static function functionLength(f:Function):Int {
		#if php
		var rf = untyped __php__("new ReflectionMethod($f[0], $f[1])");
		return rf.getNumberOfParameters();
		#elseif (js||flash)
		return untyped f.length;
		#elseif cpp
		return Std.parseInt(Std.string(f).substr(10));
		#elseif neko
		return Std.parseInt(Std.string(f).split(':')[1]);
		#else
		return throw 'Function not work for current platform';
		#end
	}
}

class ImmutableArrayTools {
	@:extern inline public static function kv<T>(a:ImmutableArray<T>):Iterator < KeyValue < Int, T >> return ArrayTools.kv(cast a);
}

class ArrayTools {
	
	public static inline function exists<T>(a:Array<T>, e:T):Bool return a.indexOf(e) != -1;
	
	public static function thereIs<T>(a:Iterable<Array<T>>, b:Array<T>):Bool {
		for (e in a) if (Tools.equal(e, b)) return true;
		return false;
	}
	
	public static function kv<T>(a:Iterable<T>):Iterator < KeyValue < Int, T >> {
		var i:Int = 0;
		//var c:Int = a.length;
		var it = a.iterator();
		return {
			hasNext: it.hasNext,
			next: function() {
				var p = new Pair(i, it.next());
				i++;
				return p;
			}
		};
	}
	
	public static function pair<A,B>(a:Iterable<A>, b:Iterable<B>):Iterator < Pair < A, B >> {
		var itA = a.iterator();
		var itB = b.iterator();
		return {
			hasNext: function() return itA.hasNext() && itB.hasNext(),
			next: function() return new Pair(itA.next(), itB.next())
		};
	}
	
	public static inline function toBytes(a:Array<Int>):BytesOutput {
		var b = new BytesOutput();
		for (e in a) b.writeByte(e);
		return b;
	}
	
	/**
	 * Randomize
	 * Warning: This function modifies original array
	 */
	public inline static function randomize<T>(a:Array<T>):Array<T> {
		a.sort(randomizeSort);
		return a;
	}
	private static function randomizeSort(_:Dynamic, _:Dynamic):Int return Math.random() > 0.5 ? 1 : -1;
	
	inline public static function last<T:Dynamic>(a:Array<T>):T return a[a.length - 1];
	
	static public function swap<T>(array:Array<T>, a:Int, b:Int):Array<T> {
		if (a > b) return swap(array, b, a);
		else if (a == b) return array;
		var v1 = array[a];
		var v2 = array[b];
		var p1 = a == 0 ? [] : array.slice(0, a);
		var p2 = array.slice(a + 1, b);
		var p3 = array.slice(b + 1);
		p1.push(v2);
		p2.push(v1);
		return p1.concat(p2).concat(p3);
	}
	
	static public function delete<T>(array:Array<T>, index:Int):Array<T> {
		var na:Array<T> = [];
		for (i in 0...array.length) if (i != index) na.push(array[i]);
		return na;
	}
	
	static public function fIndexOf<T>(a:Array<T>, f:T->Bool):Int {
		var i = 0;
		for (e in a) {
			if (f(e)) return i;
			i++;
		}
		return -1;
	}
	
	static public function sum<T:Float>(a:Array<T>):T {
		var sum:T = cast 0;
		for (v in a) sum += v;
		return sum;
	}
	
}

class FloatTools {
	/**
	 * todo: negative numbers
	 * @param	ex
	 * @param	mask
	 * @return
	 */
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
			var s:String = _toFixed(v, n, 0, d, beginS, endS);
			var a = s.split(d);
			var d = begin - a[0].length;
			return TextTools.repeat(beginS, d) + s;
		}
		
		if (n == 0) return Std.string(Std.int(v));
		var p:Float = Math.pow(10, n);
		v = Math.floor(v * p) / p;
		var s:String = Std.string(v);
		var a:Array<String> = s.split('.');
		if (a.length <= 1)
			return s + d + TextTools.repeat(endS, n);
		else
			return a[0] + d + a[1] + TextTools.repeat(endS, n - a[1].length);
	}
}

class XMLTools {
	inline public static function isTrue(x:haxe.xml.Fast, name:String):Bool return x.has.resolve(name) && TextTools.isTrue(x.att.resolve(name));
	inline public static function fast(text:String):Fast return new haxe.xml.Fast(Xml.parse(text));
}