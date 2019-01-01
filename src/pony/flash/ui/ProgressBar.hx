package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import pony.time.DeltaTime;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends MovieClip implements Dynamic<MovieClip> {
#if !starling
	@:isVar public var auto(default, set):Void->Float;
	
	//@:extern private var bar:MovieClip;
	private var total:Float;
	
	@:isVar public var value(default, set):Float;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		total = this.bar.width;
		this.bar.width = 0;
	}
	
	inline public function resolve(name:String):MovieClip return untyped this[name];
	
	public function set_value(v:Float):Float {
		this.bar.width = total * v;
		return value = v;
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
		value = auto();
	}
#end
}