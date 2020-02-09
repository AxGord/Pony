package pony.ui.touch.starling;

import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
import pony.ui.touch.TouchableBase;

/**
 * Toucheble
 * todo: fix over buf after mouse down
 * @author AxGord <axgord@gmail.com>
 */
class Touchable extends TouchableBase {

	public var leave: Bool = false;

	private var prev: TouchEventType;

	public function new(object: Dynamic) {
		super();
		TouchManager.addListener(object, eventHandler);
	}

	private function eventHandler(event: TouchManagerEvent): Void {
		switch event.type {
			case TouchEventType.Hover:
				dispatchOver(event.touchID);
				leave = false; // trace('Hover');
			case TouchEventType.HoverOut:
				dispatchOut(event.touchID);
				leave = true; // trace('HoverOut');
			case TouchEventType.Over:
				dispatchOverDown(event.touchID);
				leave = false; // trace('Over');
			case TouchEventType.Out:
				dispatchOutDown(event.touchID);
				leave = true; // trace('Out');
			case TouchEventType.Down:
				dispatchDown(event.touchID, event.globalX, event.globalY); // trace('Down');
			case TouchEventType.Up:
				leave ? dispatchOutUp(event.touchID) : dispatchUp(); // trace('Up');
			case _:
		}
		prev = event.type;
	}

}