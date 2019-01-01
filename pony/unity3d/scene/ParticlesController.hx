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