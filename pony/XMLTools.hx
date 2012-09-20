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
import haxe.xml.Fast;
#if !flash
import pony.fs.File;
#end

using pony.Ultra;

/**
 * ...
 * @author AxGord
 */

class XMLTools
{

	#if !flash
	public static inline function fast(f:File):Fast return new Fast(Xml.parse(f.content)).elements.next()
	#end
	/*
	public static function toObj(?x:Fast, ?f:File, fields:Array<String>, ?delemiter:String):Dynamic {
		if (f != null) {
			x = fast(f);
		}
		var obj:Dynamic = { };
		if (delemiter == null) {
			for (f in fields)
				if (x.has.resolve(f))
					Reflect.setField(obj, f, StringTools.trim(x.node.resolve(f).innerData));
				else
					Reflect.setField(obj, f, null);
		} else {
			for (f in fields)
				if (x.has.resolve(f))
					Reflect.setField(obj, f, x.node.resolve(f).innerData.split(delemiter).map(StringTools.trim));
				else
					Reflect.setField(obj, f, null);

		}
		return obj;
	}
	
	public static function toHash(?x:Fast, ?f:File, ?delemiter:String):Hash<String> {
		if (f != null) {
			x = fast(f);
		}
		var h:Hash<String> = new Hash<String>();
		if (delemiter == null) {
			for (f in x.elements)
				if (x.has.resolve(f))
					h.set(f, StringTools.trim(x.node.resolve(f).innerData));
				else
					h.set(f, null);
		} else {
			for (f in fields)
				if (x.has.resolve(f))
					h.set(f, x.node.resolve(f).innerData.split(delemiter).map(StringTools.trim));
				else
					h.set(f, null);

		}
		return h;
	}
	*/
	
	public static function serialize(v:Dynamic):Xml {
		if (Std.is(v, String) || Std.is(v, Int))
			return Xml.createPCData(v);
		if (Std.is(v, Bool))
			return Xml.createPCData(v?'1':'0');
		if (v == null)
			return Xml.createPCData('');
		trace(v);
		throw 'Sorry, unrealized type';
	}
	
	public static function unserialize(x:Xml):Dynamic {
		if (x.nodeType + '' == 'element') {
			trace(x);
			throw 'Sorry, unrealized type';
		} else
			return x.toString();
	}
	
}