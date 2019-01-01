package pony.ui.gui;

/**
 * ZeroPlaceCore
 * @author AxGord <axgord@gmail.com>
 */
class ZeroPlaceCore<T> extends BaseLayoutCore<T> {
	
	override public function update():Void {
		if (objects == null) return;
		if (!ready) return;
		if (objects.length == 0) {
			_w = 0;
			_h = 0;
		} else if (objects.length == 1) {
			_w = getObjSize(objects[0]).x;
			_h = getObjSize(objects[0]).y;
			setXpos(objects[0], -_w/2);
			setYpos(objects[0], -_h/2);
		} else {
			_w = 0;
			_h = 0;
			for (obj in objects) {
				var sw = getObjSize(obj).x;
				var sh = getObjSize(obj).y;
				if (sw > _w) _w = sw;
				if (sh > _h) _h = sh;
				setXpos(obj, -sw/2);
				setYpos(obj, -sh/2);
			}
		}
	}
	
}