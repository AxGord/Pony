package pony.pixi;

import js.html.Audio;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pony.events.Signal0;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.time.Time;
import pony.time.TimeInterval;

/**
 * PixiSound
 * @author AxGord <axgord@gmail.com>
 */
class PixiSound implements HasSignal {

	private static inline final shift: Float = 0; // 0.076;
	private static inline final ending: Float = 0.300;
	private static inline final loopEnd: Float = 6.000;

	@:auto public var onEnd: Signal0;
	public var core: Audio;

	private var _volume: Float = 0;
	@:auto private var onEndTrack: Signal0;
	private var waitTime: Time;

	public function new() {}

	public function loadHandler(r: Resource): Void {
		core = cast r.data;
		_stop();
		onEnd << endHandler;
		DeltaTime.fixedUpdate << _loopUpdate;
	}

	public function playInterval(v: TimeInterval, ?cb: Void -> Void): Void {
		if (core == null || !enabled()) return;
		// if (isPlay()) {
		// 	onEnd < playInterval.bind(v, cb);
		// 	return;
		// }
		if (cb != null) onEnd < cb;
		core.currentTime = v.min / 1000 + shift;
		waitTime = v.max;
		if (v.max == null) {
			onEndTrack < dispatchEnd;
		} else {
			waitTime = v.max;
			DeltaTime.fixedUpdate << timeUpdate;
		}
		_play();
	}

	public function stop(): Void waitTime == null ? dispatchEnd() : endHandler();

	public function isPlay(): Bool {
		return JsTools.isMobile ? core.volume != 0 : !core.paused;
	}

	public function enable(): Void {
		if (enabled()) return;
		_volume = 1;
		if (!JsTools.isMobile) return;
		trace('ENABLE');
		core.play();
	}

	public function disable(): Void {
		if (!enabled()) return;
		_volume = 0;
		dispatchEnd();
		core.pause();
		core.currentTime = 0;
	}

	public function enabled(): Bool {
		return _volume == 1;
	}

	private inline function dispatchEnd(): Void eEnd.dispatch();

	private function _loopUpdate(): Void {
		if (core.currentTime > core.duration - loopEnd) {
			core.currentTime = shift;
			eEndTrack.dispatch();
		}
	}

	private function timeUpdate(): Void {
		if (core.currentTime * 1000 + shift + ending >= waitTime.totalMs) {
			dispatchEnd();
		}
	}

	private function endHandler(): Void {
		DeltaTime.fixedUpdate >> timeUpdate;
		_stop();
	}

	private function _play(): Void {
		if (JsTools.isMobile) {
			core.volume = _volume;
		} else {
			core.play();
		}
	}

	private function _stop(): Void {
		if (JsTools.isMobile) {
			core.volume = 0;
		} else {
			core.pause();
		}
	}

}
