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

import haxe.BaseCode;
import Type;

using Reflect;
using pony.Ultra;

/**
 * Please not use "null" for TInt, use "nullInt"! This save you!<br/>
 * Ultra it is good constants pack ;)<br/>
 * Also ultra it is good extensions pack, write: [
 * import pony.Ultra;
 * using.Ultra;
 * ] - this make you happy!<br/>
 * @author AxGord
 */

class Ultra {
	#if neko
	//todo: google it
	public static inline var maxInt:Int = 536870911;
	public static inline var minInt:Int = -536870911;
	#else
	/**
	 * The largest representable 32-bit signed integer, which is 2,147,483,647.
	 */
	public static inline var maxInt:Int = 2147483647;

	/**
	 * The smallest representable 32-bit signed integer, which is -2,147,483,648.
	 */
	public static inline var minInt:Int = -2147483648;
	#end
	
	
	/**
	 * Just "null" not work in as3, use this all time and you no take problem. And use (minInt - 1) ;)
	 */
	#if flash9
	public static inline var nullInt:Int = minInt;
	#else
	public static inline var nullInt:Int = null;
	#end
	
	static public function randomString(string_length:Int = 36):String {
		var chars:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
		var randomstring:String = '';
		for (i in 0...string_length) {
			var rnum:Int = Math.floor(Math.random() * chars.length);
			randomstring += chars.charAt(rnum);
		}
		return randomstring;
	}
}


/**
 * Extensions for TBool. For using write: [using pony.Ultra;]
 * @author AxGord
 */

class BoolExtensions
{
	/**
	 * Some time need take TInt from TBool.
	 */
	public static inline function toInt(b:Bool):Int return b?1:0
}


/**
 * Extensions for TArray. For using write: [using pony.Ultra;]
 * @author AxGord
 */

class ArrayExtensions
{
	/**
	 * Not null elements count in array. Look this:
	 * [
	 * function(?a:String, ?b:Array):String {
	 * 	if ([a, b].notNullCount() != 1) throw 'Take me only one argument.';
	 * 	if (a.notNull())
	 * 		return a;
	 * 	else
	 * 		return b.join(', ');
	 * }
	 * ]
	 */
	public static function notNullCount(a:Array<Dynamic>):Int {
		var s:Int = 0;
		for (e in a)
			s += e.notNull().toInt();
		return s;
	}
	
	/**
	 * Null elements count in array. Look this:
	 * [
	 * function(?a:String, ?b:Array):String {
	 * 	if ([a, b].nullCount() != 1) throw 'Take me only one argument.';
	 * 	if (a.notNull())
	 * 		return a;
	 * 	else
	 * 		return b.join(', ');
	 * }
	 * ]
	 */
	public static function nullCount(a:Array<Dynamic>):Int {
		var s:Int = 0;
		for (e in a)
			s += e.isNull().toInt();
		return s;
	}
	
	/**
	 * Only one element not null.
	 */
	public static inline function onlyOne(a:Array<Dynamic>):Bool {
		return a.notNullCount() == 1;
	}
	
	/**
	 * For make arguments cases.
	 */
	public static function argCase(a:Array<Dynamic>, f:Bool = true):Int {
		if (!a.onlyOne()) {
			if (f)
				throw 'Give me only one argument';
			else
				return Ultra.nullInt;
		}
		for (i in 0...a.length)
			if (a[i] != null)
				return i+1;
		if (f)
			throw 'Give me only one argument';
		return Ultra.nullInt;
	}
	
	public static function last<T>(a:Array<T>):T {
		return a[a.length - 1];
	}

	public static function map < A, B > (a:Array<A>, f:A->B):Array<B> {
		var na:Array<B> = [];
		for (e in a)
			na.push(f(e));
		return na;
	}
	
	public static function quote(a:Array<String>, q:String='"'):Array<String> {
		return a.map(function(s:String) return q + s + q );
	}
	
	public static function search<A>(a:Array<A>, f:A->Bool):Int {
		for (i in 0...a.length) if (f(a[i])) return i;
		return -1;
	}
	
}


/**
 * Extensions for TInt. For using write: [using pony.Ultra;]
 * @author AxGord
 */

class IntExtensions {
	#if flash9
	public static inline function notNull(o:Int):Bool return o != Ultra.nullInt
	public static inline function isNull(o:Int):Bool return o == Ultra.nullInt
	#end
}


/**
 * Extensions for TDynamic. For using write: [using pony.Ultra;]
 * @author AxGord
 */

class DynamicExtensions {
	
	/**
	 * Better use this, not write:
	 * [if (a != null) ...] This fail if a - TInt and platform - flash.
	 * @return true if not null, false if null.
	 */
	public static inline function notNull(o:Dynamic):Bool { return o != null; }
	
	/**
	 * Better use this, not write:
	 * [if (a == null) ...] This fail if a - TInt and platform - flash.
	 * @return true if null, false if not null.
	 */
	public static inline function isNull(o:Dynamic):Bool { return o == null; }
	
	//public static function int(v:Dynamic):Int { return v; }
	
	/**
	 * Make full copy.
	 * @return Copy.
	 */
	public static function clone<T>(o:T):T {
		if (o == null) return null;
		switch (Type.typeof(o)) {
			case TClass(Void):
			case TEnum(Void):
			case TObject:
			case TUnknown:
				var b:Bool = false;
				try {
					b = (untyped o == [] || o[0] != null);
				} catch (e:Dynamic) {
					return o;
				}
				if (b) {//Ultra hack for copy some crazy haxe arrays.
					var i:Int = 0;
					var n:Dynamic = [];
					while (untyped o[i] != null) {
						n[i] = (clone(untyped o[i]));
						i++;
					}
					n = n.field('__a');
					return untyped n;
				} return o;
			default: return o;
		}
		var n:T = o.copy();
		for (f in n.fields()) {
			n.setField(f, clone(n.field(f)));
		}
		return n;
	}
	
	public static function is(o:Dynamic, c:Class<Dynamic>):Bool {
		if (Std.is(o, c)) return true;
		#if !cpp
		try {
			var meta:Dynamic = haxe.rtti.Meta.getType(Type.getClass(o));
			if (meta.hasField('extends')) {
				var exts:Array<String> = meta.field('extends');
				trace(exts);
				for (e in exts)
					if (e == untyped c.__name__[0]) return true;
			}
		} catch (e:Dynamic) { }
		#end
		return false;
	}
	
}

/**
 * Extensions for THash. For using write: [using pony.Ultra;]
 * @author AxGord
 */

class HashExtensions {
	
	/**
	 * Example: [
	 * var h:Hash<Array<Int>> = new Hash<Array<Int>>();
	 * h.push('a', 42);
	 * h.push('a', 27);
	 * h;//{a => [42, 27]}
	 * ] This is alternative for code: [
	 * var h:Hash<Array<Int>> = new Hash<Array<Int>>();
	 * if (!h.exists('a'))
	 * 	 h.set('a', [42]);
	 * else
	 *   h.get('a').push(42);
	 * //etc...
	 */
	public static function push<T>(h:Hash<Array<T>>, key:String, value:T):Void {
		if (h.exists(key))
			h.get(key).push(value);
		else
			h.set(key, [value]);
	}
	
	public static function map < A, B > (a:Hash<A>, f:A->B):Hash<B> {
		var na:Hash<B> = new Hash<B>();
		for (k in a.keys())
			na.set(k, f(a.get(k)));
		return na;
	}
	
	public static function len(a:Hash<Dynamic>):Int {
		var c:Int = 0;
		for (e in a) c++;
		return c;
	}
	
}

/**
 * Extensions for TString. For using write: [using pony.Ultra;]
 * @author AxGord
 */

 class StringExtensions {
	public static function bigFirst(s:String):String {
		return s.charAt(0).toUpperCase() + s.substr(1);
	}
	
	public static function smallFirst(s:String):String {
		return s.charAt(0).toLowerCase() + s.substr(1);
	}
	
	public static function lines(s:String):Array<String> {
		var a:Array<String> = s.split('\r\n');
		if (a.length == 1) {
			a = s.split('\r');
			if (a.length == 1)
				a = s.split('\n');
		}
		return a;
	}
 }