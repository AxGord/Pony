package pony.openfl.ui;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * ...
 * @author meerfolk<meerfolk@gmail.com>
 */

class RubberLayout extends BaseLayout<RubberLayoutCore<DisplayObject>> {
	
	public function new(layoutWidth:Float, layoutHeight:Float, vert:Bool = false, ?border:Border<Int>, padding:Bool = true, ?align:Align) {
		layout = new RubberLayoutCore<DisplayObject>(vert, border, padding, align);
		layout.width = layoutWidth;
		layout.height = layoutHeight;
		super();
	}
	
}