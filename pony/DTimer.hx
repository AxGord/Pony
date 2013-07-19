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
import pony.events.Listener;
import pony.events.Signal;

using pony.Tools;
/**
 * ...
 * @author AxGord
 */
class DTimer {
	
	public var hour:Int;
	public var min:Int;
	public var sec:Int;
	public var forward:Bool;
	
	public var update:Signal;
	public var updateVisual:Signal;
	
	private var sumdt:Float;

	public function new(hour:Int = 0, min:Int = 0, sec:Int = 0, forward:Bool = true) {
		update = new Signal();
		updateVisual = new Signal();
		var l:Listener = visual;
		updateVisual.takeListeners.add(update.add.bind(l));
		updateVisual.lostListeners.add(update.remove.bind(l));
		//update.add(visual);
		setTime(hour, min, sec);
		this.forward = forward;
		DeltaTime.update.add(_update);
	}
	
	private function enableVisual():Void {
		//update.add(visual);
	}
	
	private function disableVisual():Void {
		update.remove(visual);
	}
	
	public function setTime(hour:Int=0,min:Int=0,sec:Int=0) {
		this.hour = hour;
		this.min = min;
		this.sec = sec;
		update.dispatch(hour, min, sec);
	}
	
	private function _update(dt:Float):Void {
		sumdt += dt;
		var updated:Bool = sumdt > 1;
		while (sumdt > 1) {
			sumdt--;
			sec++;
			if (sec > 59) {
				min++;
				sec = 0;
				if (min > 59) {
					hour++;
					min = 0;
					if (hour > 23)
						hour = 0;
				}
			}
		}
		
		if (updated)
			update.dispatch(hour, min, sec);
	}
	
	private function visual():Void {
		updateVisual.dispatch(toString());
	}
	
	public function toString():String {
		return hour + ':' + min.toFixed('00') + ':' + sec.toFixed('00');
	}
	
}