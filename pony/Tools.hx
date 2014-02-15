/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.xml.Fast;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end
import pony.text.TextTools;

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
      //trace(type);
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
              if (!equal(a[i], b[i], maxDepth-1)) return false;
            return true;
          
          case TObject: if(Std.is(a, Class)) return false;
          case TUnknown:
          case TClass(t):
          
          if (t == Array) {
            if (!Std.is(b, Array)) return false;
          
            if (a.length != b.length) return false;
            for (i in 0...a.length) 
              if (!equal(a[i], b[i], maxDepth-1)) return false;
            return true;
          }
  
      }
      // a is Object on Unknown or Class instance
      switch (Type.typeof(b)) {
          case TInt, TFloat, TBool, TFunction, TEnum(_), TNull: return false;
          case TObject: if(Std.is(b, Class)) return false;
          case TClass(t): if (t == Array) return false;
          case TUnknown:
      }
      
      var fields:Array<String> = a.fields();
      //trace(fields);
      //trace(b.fields());
      if (fields.length == b.fields().length) {
        if (fields.length == 0) return true;
              for (f in fields)
                  if (!b.hasField(f) || !equal(a.field(f), b.field(f), maxDepth-1))
                      return false;
              return true;
           }
          return false;
    }
	
	public static function superIndexOf<T>(it:Iterable<T>, v:T, maxDepth:Int = 1):Int {
		var i:Int = 0;
		for (e in it) {
			if (equal(e, v, maxDepth)) return i;
			i++;
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
		f = sys.FileSystem.fullPath(f).split('\\').slice(0,-1).join('/');
		return macro $v{f};
	}
	
	public static inline function exists<T>(a:Iterable<T>, e:T):Bool return a.indexOf(e) != -1;
	
}

class ArrayTools {
	
	public static inline function exists<T>(a:Array<T>, e:T):Bool return a.indexOf(e) != -1;
	
	public static function thereIs<T>(a:Iterable<Array<T>>, b:Array<T>):Bool {
		for (e in a) if (Tools.equal(e, b)) return true;
		return false;
	}
	
	public static function kv<T>(a:Array<T>):Iterator < KeyValue < Int, T >> {
		var i:Int = 0;
		var c:Int = a.length;
		return {
			hasNext: function() return i < c,
			next: function() {
				var p = new Pair(i, a[i]);
				i++;
				return p;
			}
		};
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