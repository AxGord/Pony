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
package pony.flash;
import pony.events.Signal;
import flash.external.ExternalInterface;
/**
 * ...
 * @author AxGord
 */
class Exterface extends Signal implements Dynamic<Exterface> {

	public static var get:Exterface = new Exterface();
	private static var map:Map<String, Exterface> = new Map<String, Exterface>();
	
	public var name(default, null):String;
	public var call:Dynamic;
	
	private function new(?name:String) {
		if (name != null) {
			super();
			this.name = name;
			ExternalInterface.addCallback(name, cb);
			map.set(name, this);
			call = Reflect.makeVarArgs(cll);
		}
	}
	
	private function cb(v:Array<Dynamic>):Void dispatchArgs(v);
	
	public function resolve(field:String):Exterface {
		var s:String = (name != null ? name + '.' : '') + field;
		return map.exists(s) ? map.get(s) : new Exterface(s);
	}
	
	private function cll(args:Array<Dynamic>):Dynamic {
		args.unshift(name);
		return Reflect.callMethod(null, ExternalInterface.call, args);
	}
	
}