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
package pony.magic.async;

import Type;

/**
 * Async runtime functions.
 * @author AxGord
 */
class AsyncRT
{
	
	public static function call(o:Dynamic, m:String, ok:Dynamic->Void, err:Dynamic->Void, a:Array<Dynamic>):Void {
		//trace('Call: ' + m);
		try {
			var af:Dynamic = Reflect.field(o, m + 'Async');
			if (af != null) {
				//trace('Async');
				a.push(ok);
				a.push(err);
				try {
					Reflect.callMethod(o, af, a);
				} catch (e:String) {
					if (e == 'Invalid call')
						throw e + ': ' + m + 'Async, args count '+a.length;
					else
						throw e;
				}
			} else {
				//trace('args length ' + a.length);
				var f = Reflect.field(o, m);
				if (f == null)
					throw 'Not exists method: ' + m;
				//trace(f);
				var r:Dynamic = null;
				try {
					r = Reflect.callMethod(o, f, a);
				} catch (e:String) {
					if (e == 'Invalid call')
						throw e + ': ' + m + ', args count '+a.length;
					else
						throw e;
				}
				ok(r);
				
			}
		} catch (e:Dynamic) {
			err(e);
		}
	}
	

	public static function create(c:Dynamic, ok:Dynamic->Void, err:Dynamic->Void, a:Array<Dynamic>):Void {
		try {
			var o:Dynamic = Type.createEmptyInstance(c);
			if (Reflect.hasField(o, 'newAsync')) {
				a.push(function() ok(o));
				a.push(err);
				Reflect.callMethod(o, Reflect.field(o, 'newAsync'), a);
			} else
				ok(Type.createInstance(c, a));
		} catch (e:Dynamic) {
			if (e == 'Invalid call')
				err("Can't create object, class "+Type.getClassName(c)+', args count '+a.length);
			else
				err(e);
		}
	}
	
	public static function get(o:Dynamic, f:String, ok:Dynamic->Void, err:Dynamic->Void, sync:Void->Dynamic):Void {
		try {
			//trace(f);
			var n:String = 'get' + f.charAt(0).toUpperCase() + f.substr(1) + 'Async';
			if (Reflect.hasField(o, n)) {
				Reflect.callMethod(o, Reflect.field(o, n), [ok, err]);
			} else  {
				ok(sync());
			}
			
		} catch (e:Dynamic) {
			err(e);
		}
	}
	
	public static function set(o:Dynamic, f:String, val:Dynamic->Void, ok:Dynamic->Void, err:Dynamic->Void, sync:Dynamic->Dynamic):Void {
		try {
			var n:String = 'set' + f.charAt(0).toUpperCase() + f.substr(1) + 'Async';
			
			if (Reflect.hasField(o, n)) {
				val(function(v:Dynamic) {
					Reflect.callMethod(o, Reflect.field(o, n), [v, ok, err]);
				});
			} else  {
				val(function(v:Dynamic) {
					ok(sync(v));
				});
			}
			
		} catch (e:Dynamic) {
			err(e);
		}
	}
	
	public static function error(r:Dynamic):Void {
		throw r;
	}
	
}