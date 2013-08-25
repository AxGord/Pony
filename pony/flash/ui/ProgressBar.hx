package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import pony.DeltaTime;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
class ProgressBar extends MovieClip implements Dynamic<MovieClip> {

	//@:extern private var bar:MovieClip;
	private var total:Float;
	private var autof:Void->Float;
	
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
	
	inline public function progress(v:Float):Void {
		this.bar.width = total * v;
	}
	
	inline public function enableAuto(f:Void->Float):Void {
		autof = f;
		DeltaTime.update.add(autoUpdate);
		autoUpdate();
	}
	
	inline public function diableAuto():Void {
		DeltaTime.update.remove(autoUpdate);
	}
	
	private function autoUpdate():Void {
		progress(autof());
	}
	
}