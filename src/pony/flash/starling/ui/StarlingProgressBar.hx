package pony.flash.starling.ui;

import flash.events.Event;
import pony.time.DeltaTime;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;

/**
 * StarlingProgressBar
 * @author AxGord
 */
class StarlingProgressBar extends Sprite {

	@:isVar public var auto(default, set): Void -> Float;
	@:isVar public var value(default, set): Float;

	private final bar: DisplayObject;
	private final total: Float;

	public function new(source: Sprite) {
		super();
		bar = untyped source.getChildByName('bar');
		total = bar.width;
		bar.width = 0;
		addChild(source);
	}

	public function set_value(v: Float): Float {
		bar.width = total * v;
		return value = v;
	}

	private function set_auto(f: Void -> Float): Void -> Float {
		if (auto == f) return f;
		if (f == null) {
			DeltaTime.fixedUpdate.remove(autoUpdate);
		} else
			DeltaTime.fixedUpdate.add(autoUpdate);
		return auto = f;
	}

	private function autoUpdate(): Void {
		value = auto();
	}

}
