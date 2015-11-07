package pony.flash.starling.ui;

import flash.events.Event;
import pony.events.Signal;
import pony.events.Signal1;
import pony.flash.FLTools;
import pony.time.DeltaTime;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;

/**
 * StarlingProgressBar
 * @author AxGord
 */
class StarlingProgressBar extends Sprite {

	@:isVar public var auto(default, set):Void->Float;
	
	private var bar:DisplayObject;
	private var total:Float;
	
	@:isVar public var value(default, set):Float;
	
	public function new(source:Sprite) {
		super();
		bar = untyped source.getChildByName("bar");
		total = bar.width;
		bar.width = 0;
		addChild(source);
	}
	
	public function set_value(v:Float):Float {
		bar.width = total * v;
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
}