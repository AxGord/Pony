/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.time;
import pony.events.Listener1;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;

/**
 * TimeLine
 * @author AxGord
 */
class Timeline implements Declarator implements HasSignal {

	@:arg private var data:Array<Time>;
	@:arg public var pauseOnStep:Bool = false;
	
	@:auto public var onStep:Signal1<Int>;
	
	public var isPlay(default, null):Bool = false;
	
	public var currentStep(default,null):Int = 0;
	public var currentTime(default,null):Time = 0;
	
	private var lastdt:DT = 0;
	private var timer:DTimer;
	
	public function play(dt:DT = 0):Void {
		if (isPlay) return;
		if (currentStep >= data.length) return;
		isPlay = true;
		if (timer == null) timer = DTimer.fixedDelay(data[currentStep] - currentTime, endStep, dt + lastdt);
		else timer.start(dt + lastdt);
		lastdt = 0;
	}
	
	public function pause():Void {
		if (!isPlay) return;
		timer.stop();
		isPlay = false;
	}
	
	private function endStep(dt:DT):Void {
		timer = null;
		currentTime = data[currentStep];
		currentStep++;
		lastdt = dt;
		isPlay = false;
		if (!pauseOnStep) play();
		eStep.dispatch(currentStep);
	}
	
	public function reset():Void {
		if (timer != null) {
			timer.destroy();
			timer = null;
		}
		isPlay = false;
		currentTime = 0;
		currentStep = 0;
	}
	
	public function playTo(step:Int, dt:DT = 0):Void {
		pauseOnStep = true;
		var l:Listener1<Int> = null;
		l = function(n:Int):Void {
			if (n < step) play();
			else onStep >> l;
		}
		onStep << l;
		play(dt);
	}
	
}