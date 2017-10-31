/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d.scene;

import pony.time.DT;
import pony.time.DTimer;
import pony.time.Time;
import unityengine.MonoBehaviour;
using hugs.HUGSWrapper;

/**
 * ParticlesManager
 * @author AxGord
 */

class ParticlesManager extends MonoBehaviour {

	private var playAfter:Float = 0;
	private var stopAfter:Float = 0;
	private var abortAfter:Float = 0;
	
	private var playOnAwake:Bool = true;
	
	private var playTimer:DTimer;
	private var stopTimer:DTimer;
	private var abortTimer:DTimer;
	
	private var comps:NativeArrayIterator<ParticlesController>;
	
	
	private function Start():Void {
		comps = getComponentsInChildrenOfType(ParticlesController);
		abort();
		if (playAfter > 0) {
			playTimer = DTimer.createTimer(Time.fromFloat(playAfter * 1000));
			playTimer.complite << playNow;
		}
		if (stopAfter > 0) {
			stopTimer = DTimer.createTimer(Time.fromFloat(stopAfter * 1000));
			stopTimer.complite << stop;
		}
		if (abortAfter > 0) {
			abortTimer = DTimer.createTimer(Time.fromFloat(abortAfter * 1000));
			abortTimer.complite << abort;
		}
		if (playOnAwake) play();
	}
	
	public function play(?dt:DT):Void {
		if (playTimer != null) playTimer.start(dt);
		else playNow(dt);
	}
	
	public function playNow(?dt:DT):Void {
		abort();
		comps.reset();
		for (c in comps) c.play(dt);
		
		if (stopTimer != null) {
			stopTimer.reset();
			stopTimer.start(dt);
		}
		
		if (abortTimer != null) {
			abortTimer.reset();
			abortTimer.start(dt);
		}
	}
	
	public function playSuperNow(?dt:DT):Void {
		comps.reset();
		for (c in comps) c.playNow(dt);
	}
	
	public function stop():Void {
		if (playTimer != null) {
			playTimer.stop();
			playTimer.reset();
		}
		if (stopTimer != null) stopTimer.stop();
		comps.reset();
		for (c in comps) c.stop();
	}
	
	public function abort():Void {
		if (abortTimer != null) abortTimer.stop();
		stop();
		comps.reset();
		for (c in comps) c.abort();
	}
	
}