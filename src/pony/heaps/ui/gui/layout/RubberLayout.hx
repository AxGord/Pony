package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.Point;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * RubberLayout
 * @author AxGord <axgord@gmail.com>
 */
class RubberLayout extends BaseLayout<RubberLayoutCore<Object>> {
	
	public function new(layoutWidth:Float, layoutHeight:Float, vert:Bool = false, ?border:Border<Int>, padding:Bool = true, ?align:Align) {
		layout = new RubberLayoutCore<Object>(vert, border, padding, align);
		super();
		changeWh << changeWhHandler;
		wh = new Point(layoutWidth, layoutHeight);
	}

	private function changeWhHandler(p:Point<Float>):Void {
		layout.width = p.x;
		layout.height = p.y;
		layout.update();
	}
	
}