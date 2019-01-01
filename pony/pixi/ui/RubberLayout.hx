package pony.pixi.ui;

import pixi.core.display.Container;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * RubberLayout
 * @author AxGord <axgord@gmail.com>
 */
class RubberLayout extends BaseLayout<RubberLayoutCore<Container>> {
	
	public function new(layoutWidth:Float, layoutHeight:Float, vert:Bool = false, ?border:Border<Int>, padding:Bool = true, ?align:Align) {
		layout = new RubberLayoutCore<Container>(vert, border, padding, align);
		layout.width = layoutWidth;
		layout.height = layoutHeight;
		super();
	}
	
}