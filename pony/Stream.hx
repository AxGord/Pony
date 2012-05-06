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
import pony.magic.Declarator;

/**
 * @author AxGord
 */

class Stream<O> implements Declarator
{
	@arg private var data:Array<Dynamic> = null;
	@arg private var ldata:List<Dynamic> = null;
	@arg private var stream:Stream<Dynamic> = null;
	@arg private var iter:Iterator<Dynamic> = null;
	@arg private var nextStream:Stream<O> = null;
	@arg private var skiper:Dynamic->Bool = null;
	@arg private var filter:Dynamic->O = null;
	
	private var calced:Array<O> = null;
	
	public dynamic function array():Array<O> {
		var a:Array<O> = [];
		
		for (e in this)
			a.push(e);
			
		return a;
	}
	
	public function list():List<O> {
		var a:List<O> = new List<O>();
		
		for (e in this)
			a.push(e);
			
		return a;
	}
	
	public dynamic function iterator():Iterator<O> {
		if (nextStream != null) {
			var i1:Iterator<O> = subIterator();
			var i2:Iterator<O> = nextStream.iterator();
			var f:Bool = true;
			return {
				hasNext: function() return f ? { (f = i1.hasNext()) ? true : i2.hasNext(); } : i2.hasNext(),
				next: function() return f ? i1.next() : i2.next()
			};
		} else
			return subIterator();
	}
	
	private function subIterator():Iterator<O> {
		var i:Iterator<Dynamic> = if (ldata != null)
			ldata.iterator();
		else if (data != null)
			data.iterator();
		else if (iter != null)
			iter;
		else if (stream != null)
			stream.iterator();
		else [].iterator();
		var next:Dynamic = null;
		return {
			hasNext: if (skiper != null) {
					function() if (i.hasNext()) {
						while (!skiper(next = i.next())) { if (!i.hasNext()) return false; } return true;
					} else return false;
				} else i.hasNext,
			next: if (filter != null) {
					if (skiper != null)
						function() return filter(next)
					else
						function() return filter(i.next());
				} else if (skiper != null) function() return untyped next
				else untyped i.next
			}
	}
	
	public function concat(s:Stream<O>):Stream < O > {
		return new Stream<O>(this, s);
	}
	
	public dynamic function calc():Void {
		calced = new Array<O>();
		for (e in this) {
			calced.push(e);
		}
		data = null;
		ldata = null;
		stream = null;
		iter = null;
		nextStream = null;
		filter = null;
		skiper = null;
		#if flash9
		iterator = function():Iterator<O> {
			return calced.iterator();
		};
		#else
		iterator = calced.iterator;
		#end
		calc = function() { };
		array = function():Array<O> return calced;
	}
	
	public inline function toString():String return array().toString()
	
	public function get(n:Int):O {
		var i:Int = 0;
		for (e in this)
			if (i++ == n)
				return e;
		return null;
	}
	
	public function isEmpty():Bool {
		return ldata == null && data == null && iter == null && stream == null && nextStream == null;
	}
	
	public function length():Int {
		var c:Int = 0;
		for (e in this) c++;
		return c;
	}
	
}