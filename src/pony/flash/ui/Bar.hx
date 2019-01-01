package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

/**
 * Bar
 * @author AxGord
 */
class Bar extends MovieClip implements FLStage implements HasSignal {
#if !starling
	@:stage private var bar:MovieClip;
	
	private var total:Float;
	
	public var value(default, set):Float = 0;
	@:auto public var onComplete:Signal1<Float>;
	@:auto public var onDynamic:Signal1<Float>;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
		addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	private function clickHandler(_):Void {
		value = mouseX / total;
	}
	
	private function init():Void {
		total = width;
		bar.width = 0;
	}
	
	public function set_value(v:Float):Float {
		if (value == v) return v;
		eDynamic.dispatch(v);
		eComplete.dispatch(v);
		bar.width = v * total;
		return value = v;
	}
#end
}