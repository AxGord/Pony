package pony.starling.ui;

import pony.events.Signal;
import pony.events.Signal1;
import pony.flash.FLTools;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;

/**
 * StarlingBar
 * @author AxGord
 */
class StarlingBar extends Sprite {
	
	private var bar:DisplayObject;
	private var zone:DisplayObject;
	
	private var total:Float;
	
	public var value(default, set):Float = 0;
	public var on:Signal1<StarlingBar, Float>;
	
	private var source:Sprite;
	
	public function new(source:Sprite) {
		super();
		this.source = source;
		on = Signal.create(this);
		bar = untyped source.getChildByName("bar");
		zone = untyped source.getChildByName("zone");
		zone.alpha = 0;
		addChild(source);
		FLTools.init < init;
		TouchManager.addListener(zone, touchHandler);
	}
	
	private function touchHandler(e:TouchManagerEvent):Void {
		if (e.type == TouchEventType.Down) {
			value = (e.globalX - source.x) / total;
		}
	}
	
	private function init():Void {
		total = width;
		bar.width = 0;
	}
	
	public function set_value(v:Float):Float {
		if (value == v) return v;
		on.dispatch(v);
		bar.width = v * total;
		return value = v;
	}
	
}