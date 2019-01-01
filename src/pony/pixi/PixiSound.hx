package pony.pixi;

import js.html.Audio;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pony.events.Signal0;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.time.Time;
import pony.time.TimeInterval;
import pony.ui.AssetManager;

/**
 * PixiSound
 * @author AxGord <axgord@gmail.com>
 */
class PixiSound implements HasSignal {
	
	inline static private var shift:Float = 0;// 0.076;
	inline static private var ending:Float = 0.300;
	inline static private var loopEnd:Float = 6.000;

	@:auto public var onEnd:Signal0;
	@:auto private var onEndTrack:Signal0;
	
	public var core:Audio;
	
	private var waitTime:Time;
	
	private var _volume:Float = 0;
	
	public function new() {}
	
	public function loadHandler(r:Resource):Void {
		core = cast r.data;
		_stop();
		onEnd << endHandler;
		DeltaTime.fixedUpdate << _loopUpdate;
	}
	
	private function _loopUpdate():Void {
		if (core.currentTime > core.duration - loopEnd) {
			core.currentTime = shift;
			eEndTrack.dispatch();
		}
	}
	
	public function playInterval(v:TimeInterval, ?cb:Void->Void):Void {
		if (core == null || !enabled()) return;
		/*
		if (isPlay()) {
			onEnd < playInterval.bind(v, cb);
			return;
		}
		*/
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
	
	private function timeUpdate():Void {
		if (core.currentTime * 1000 + shift + ending >= waitTime.totalMs) {
			dispatchEnd();
		}
	}
	
	inline private function dispatchEnd():Void eEnd.dispatch();
	
	public function stop():Void waitTime == null ? dispatchEnd() : endHandler();
	
	private function endHandler():Void {
		DeltaTime.fixedUpdate >> timeUpdate;
		_stop();
	}
	
	private function _play():Void {
		if (JsTools.isMobile) {
			core.volume = _volume;
		} else {
			core.play();
		}
	}
	
	private function _stop():Void {
		if (JsTools.isMobile) {
			core.volume = 0;
		} else {
			core.pause();
		}
	}
	
	public function isPlay():Bool {
		if (JsTools.isMobile) {
			return core.volume != 0;
		} else {
			return !core.paused;
		}
	}
	
	public function enable():Void {
		if (enabled()) return;
		_volume = 1;
		if (JsTools.isMobile) {
			trace('ENABLE');
			core.play();
		}
	}
	
	public function disable():Void {
		if (!enabled()) return;
		_volume = 0;
		dispatchEnd();
		core.pause();
		core.currentTime = 0;
	}
	
	public function enabled():Bool {
		return _volume == 1;
	}
	
}