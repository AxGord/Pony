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

import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Signal1;

/**
 * TimelineActions
 * @author AxGord
 */
class TimelineActions {
	
	public var onProccessBegin:Signal0<TimelineActions>;
	public var onProccessEnd:Signal0<TimelineActions>;
	public var onReset:Signal0<TimelineActions>;
	public var onStepBegin:Signal1<TimelineActions, Int>;
	public var onStepEnd:Signal1<TimelineActions, Int>;
	
	private var timeline:Timeline;
	private var toStep:Int = 0;
	
	private var stepSpeed:Array<Float>;
	
	private var superSpeed:Float;
	
	public function new(times:Array<Time>, speeds:Array<Float>, superSpeed:Float=10) {
		stepSpeed = speeds;
		this.superSpeed = superSpeed;
		timeline = new Timeline(times, true);
		timeline.onStep << timelineStepHandler;
		onProccessBegin = Signal.create(this);
		onProccessEnd = Signal.create(this);
		onReset = Signal.create(this);
		onStepBegin = Signal.create(this);
		onStepEnd = Signal.create(this);
	}
	
	dynamic public function setSpeed(v:Float):Void {}
	dynamic public function pause():Void {}
	dynamic public function play():Void {}
	
	inline public function reset():Void timeline.reset();
	
	private function fast():Void {
		setSpeed(superSpeed);
		play();
	}
	
	public function jumpTo(n:Int):Void {
		if (!timeline.isPlay && n == timeline.currentStep) {
			toStep = n;
			play();
			setSpeedForStep(n);
			if (stepSpeed[n] > 0) timeline.play();
			onStepBegin.dispatch(n);
		} else if (timeline.isPlay && n > timeline.currentStep) {
			toStep = n;
			timeline.playTo(n);
			fast();
		} else {
			timeline.reset();
			onReset.dispatch();
			onStepBegin.dispatch(0);
			if (n > 0) {
				onProccessBegin.dispatch();
				toStep = n;
				timeline.playTo(n);
				fast();
			} else {
				toStep = 0;
				timeline.play();
				setSpeedForStep(0);
				play();
			}
		}
	}
	
	public function playNext():Void {
		setSpeedForStep(timeline.currentStep);
		if (stepSpeed[timeline.currentStep] > 0) timeline.play();
		onStepBegin.dispatch(timeline.currentStep);
		play();
	}
	
	inline private function setSpeedForStep(n:Int):Void stepSpeed[n] == 0 ? pause() : setSpeed(stepSpeed[n]);
	
	private function timelineStepHandler(n:Int):Void {
		if (n > toStep) {
			pause();
		} else if (n == toStep) {
			setSpeedForStep(n);
			if (stepSpeed[n] > 0) timeline.play();
			onStepBegin.dispatch(n);
			onProccessEnd.dispatch();
		}
		onStepEnd.dispatch(n-1);
	}
	
}