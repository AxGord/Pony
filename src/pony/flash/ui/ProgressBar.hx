package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import pony.time.DeltaTime;

/**
 * ProgressBar
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class ProgressBar extends MovieClip {

	#if !starling
	@:isVar public var auto(default, set): Null<Void -> Float> = null;

	@SuppressWarnings('checkstyle:MagicNumber')
	@:nullSafety(Off) #if (haxe_ver >= 4.2) extern #else @:extern #end
	private var bar: MovieClip;

	private var total: Float = 0;

	@:isVar public var value(default, set): Float = 0;

	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}

	private function init(): Void {
		total = bar.width;
		bar.width = 0;
	}

	public function set_value(v: Float): Float {
		bar.width = total * v;
		return value = v;
	}

	private function set_auto(f: Void -> Float): Void -> Float {
		if (auto == f) return f;
		if (f == null)
			DeltaTime.fixedUpdate.remove(autoUpdate);
		else
			DeltaTime.fixedUpdate.add(autoUpdate);
		return auto = f;
	}

	private function autoUpdate(): Void {
		value = @:nullSafety(Off) auto();
	}
	#end

}