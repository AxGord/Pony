package pony.touchManager;

import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
import pony.touchManager.TouchebleBase;

/**
 * Toucheble
 * todo: over after mouse down
 * @author AxGord <axgord@gmail.com>
 */
class Toucheble extends TouchebleBase {

	public var leave:Bool = false;
	private var prev:TouchEventType;
	
	public function new(object:Dynamic) {
		super();
		TouchManager.addListener(object, eventHandler);
	}
	
	private function eventHandler(event:TouchManagerEvent):Void {
		switch event.type {
			case TouchEventType.Hover: eOver.dispatch(); leave = false; trace('Hover');
			case TouchEventType.HoverOut: eOut.dispatch(); leave = true; trace('HoverOut');
			case TouchEventType.Over: eOverDown.dispatch(); leave = false; trace('Over');
			case TouchEventType.Out: eOutDown.dispatch(); leave = true; trace('Out');
			case TouchEventType.Down: eDown.dispatch(); trace('Down');
			case TouchEventType.Up: if (leave) eOutUp.dispatch() else eUp.dispatch(); trace('Up');
			case _:
		}
		prev = event.type;
	}
	
}