package pony.flash.starling.ui;

import flash.geom.Point;
import flash.Lib;
import pony.events.Signal1;
import pony.flash.FLTools;
import pony.magic.HasSignal;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.TextureSmoothing;

/**
 * StarlingBar
 * @author AxGord
 */
class StarlingBar extends StarlingProgressBar implements HasSignal {
	
	private var zone:DisplayObject;
	private var b:DisplayObject;
	@:auto public var onDynamic:Signal1<Float>;
	@:auto public var onComplete:Signal1<Float>;
	
	private var source:Sprite;
	
	public function new(source:Sprite) {
		super(source);
		this.source = source;
		bar.touchable = false;
		zone = untyped source.getChildByName("zone");
		zone.alpha = 0;
		zone.useHandCursor = true;
		b = untyped source.getChildByName("b");
		if (b != null) b.touchable = false;
		TouchManager.addListener(zone, beginMove, [TouchEventType.Down]);
	}
	
	private function beginMove(e:TouchManagerEvent):Void {
		touchHandler(e);
		TouchManager.addListener(zone, touchHandler, [TouchEventType.Move]);
	}
	
	private function endMove(e:TouchManagerEvent):Void {
		TouchManager.removeListener(zone, touchHandler);
		eComplete.dispatch(value);
	}
	
	private function touchHandler(e:TouchManagerEvent):Void {
		var p = (source.globalToLocal(new Point(e.globalX, e.globalY)));
		p.x = p.x + 1.5;
		if (p.x < 0) p.x = 0;
		else if (p.x > total) p.x = total;
		value = (p.x) / total;
	
	}
	
	override public function set_value(v:Float):Float {
		if (value == v) return v;
		super.set_value(v);
		eDynamic.dispatch(v);
		if (b != null) {
			b.x = bar.width - b.width / 2;
			if (b.x < 0) b.x = 0;
			else if (b.x > total) b.x = total;
		}
		return v;
	}
	
}