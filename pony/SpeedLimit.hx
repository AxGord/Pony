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

import haxe.Timer;

/**
 * Speed Limit for save TCP/IP stack or CPU.
 * @author AxGord
 */
class SpeedLimit
{
	/**
	 * Wait time for next run. Set in ms. If -1 then run no wait.
	 */
	public var delay(default, setDelay):Int;
	
	
	#if neko
	private var timer:massive.munit.util.Timer;
	#else
	private var timer:Timer;
	#end
	
	/**
	 * @param	delay Wait time for next run. Set in ms. If -1 then run no wait.
	 */
	public function new(delay:Int=0)
	{
		this.delay = delay;
	}
	
	/**
	 * @param	f Function for run
	 */
	public function run(f:Void->Void):Void {
		if (delay == -1)
			f();
		else {
			if (timer == null) {
				#if neko
				timer = new massive.munit.util.Timer(delay);
				#else
				timer = new Timer(delay);
				#end
			}
			timer.run = function() {
				abort();
				f();
			};
		}
	}
	
	/**
	 * Not run function after delay.
	 */
	public function abort():Void {
		if (timer == null) return;
		timer.stop();
		timer = null;
	}
	
	private function setDelay(d:Int):Int {
		#if neko
			if (d == 0) d = 1;//massive.munit.util.Timer not stable on 0 ms
		#end
		if (delay == d) return d;
		if (d < -1) throw 'delay can\'t be < -1';
		if (timer != null) {
			if (d < delay) {
				timer.run();
				abort();
			} else {
				var f:Void->Void = timer.run;
				timer.stop();
				#if neko
				timer = new massive.munit.util.Timer(d);
				#else
				timer = new Timer(d);
				#end
				timer.run = f;
			}
		}
		return delay = d;
	}
	
	/**
	 * @param	f Function for run
	 */
	static public function nextTick(f:Void->Void):Void {
		var sl:SpeedLimit = new SpeedLimit();
		sl.run(f);
	}
	
}