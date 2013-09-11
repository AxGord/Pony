package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import pony.DeltaTime;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends MovieClip implements Dynamic<MovieClip> {

	@:isVar public var auto(default, set):Void->Float;
	
	//@:extern private var bar:MovieClip;
	private var total:Float;
	
	@:isVar public var progress(default, set):Float;
	
	public function new() {
		super();
		addEventListener(Event.ENTER_FRAME, init);
	}
	
	private function init(_):Void {
		removeEventListener(Event.ENTER_FRAME, init);
		total = this.bar.width;
		this.bar.width = 0;
	}
	
	inline public function resolve(name:String):MovieClip return untyped this[name];
	
	public function set_progress(v:Float):Float {
		this.bar.width = total * v;
		return progress = v;
	}
	
	private function set_auto(f:Void->Float):Void->Float {
		if (auto == f) return f;
		if (f == null) {
			DeltaTime.fixedUpdate.remove(autoUpdate);
		} else
			DeltaTime.fixedUpdate.add(autoUpdate);
		return auto = f;
	}
	
	private function autoUpdate():Void {
		progress = auto();
	}
	
}