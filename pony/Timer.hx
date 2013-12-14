/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class Timer extends Signal {
	
	public var delay(default, null):Int;
	#if (!neko && !dox && !cpp)
	private var t:haxe.Timer;
	#end
	
	public function new(delay:Int, autoStart:Bool = true) {
		super();
		this.delay = delay;
		if (autoStart) start();
	}
	
	public function start():Timer {
		stop();
		#if (!neko && !dox && !cpp)
		t = new haxe.Timer(delay);
		t.run = run;
		#end
		return this;
	}
	
	private function run():Void dispatch();
	
	public function stop():Timer {
		#if (!neko && !dox && !cpp)
		if (t != null) {
			t.stop();
			t = null;
		}
		#end
		return this;
	}
	
	public inline function clear():Void {
		stop();
		removeAllListeners();
	}
	
	public inline function setTickCount(count:Int):Timer {
		add(function() if (--count == 0) clear(), 10000);
		return this;
	}
	
	public static function tick(delay:Int):Timer {
		return new Timer(delay).setTickCount(1);
	}
	
}