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
package pony.time;

import pony.events.Listener;
import pony.events.Signal;

/**
 * Timer as Signal
 * todo: rewrite like DTime
 * @author AxGord
 */
class Timer extends Signal {
	
	public var delay(default, null):Time;
	#if (!neko && !dox && !cpp)
	private var t:haxe.Timer;
	#elseif munit
	private var t:massive.munit.util.Timer;
	#end
	
	public inline function new(delay:Time) {
		super();
		if (delay <= 0) throw 'Delay can be only > 0';
		this.delay = delay;
	}
	
	public function start():Timer {
		stop();
		#if (!neko && !dox && !cpp)
		t = new haxe.Timer(delay);
		t.run = dispatchEmpty;
		#elseif munit
		t = new massive.munit.util.Timer(delay);
		t.run = dispatchEmpty;
		#end
		return this;
	}
	
	public function stop():Timer {
		#if ((!neko && !dox && !cpp) || munit)
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
	
	public function setTickCount(count:Int):Timer {
		add(function() if (--count == 0) stop(), 100500);
		return this;
	}
	
	public inline static function tick(delay:Time):Timer {
		var t = new Timer(delay);
		return t.add(t.stop, 100500).start();
	}
	
	public inline static function tickAndClear(delay:Time):Timer {
		var t = new Timer(delay);
		return t.add(t.clear, 100500).start();
	}
	
	override public function add(listener:Listener, priority:Int = 0):Timer {
		super.add(listener, priority);
		return this;
	}
	
}