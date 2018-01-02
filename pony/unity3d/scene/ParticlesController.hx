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
package pony.unity3d.scene;

import pony.time.DT;
import pony.time.DTimer;
import pony.time.Time;
import unityengine.MonoBehaviour;
/**
 * ParticlesController
 * @author AxGord
 */
class ParticlesController extends MonoBehaviour {
	
	private var playAfter:Float = 0;
	private var stopAfter:Float = 0;
	private var abortAfter:Float = 0;
	
	private var playOnAwake:Bool = true;
	
	private var playTimer:DTimer;
	private var stopTimer:DTimer;
	private var abortTimer:DTimer;
	
	private function Start() {
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
	
	public function play(?dt:DT) {
		if (playTimer != null) playTimer.start(dt);
		else playNow(dt);
	}
	
	public function playNow(?dt:DT) {
		abort();
		if (particleSystem != null) particleSystem.Play();
		else particleEmitter.emit = true;
		
		if (stopTimer != null) {
			stopTimer.reset();
			stopTimer.start(dt);
		}
		
		if (abortTimer != null) {
			abortTimer.reset();
			abortTimer.start(dt);
		}
	}
	
	public function stop() {
		if (playTimer != null) {
			playTimer.stop();
			playTimer.reset();
		}
		if (stopTimer != null) stopTimer.stop();
		if (particleSystem != null) particleSystem.Stop();
		else particleEmitter.emit = false;
	}
	
	public function abort() {
		if (abortTimer != null) abortTimer.stop();
		stop();
		if (particleSystem != null) particleSystem.Clear();
		else particleEmitter.ClearParticles();
	}
	
}