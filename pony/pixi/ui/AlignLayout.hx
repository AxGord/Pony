package pony.pixi.ui;

import pixi.core.display.Container;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.AlignLayoutCore;

/**
 * IntervalLayout
 * @author AxGord <axgord@gmail.com>
 */
class AlignLayout extends BaseLayout<AlignLayoutCore<Container>> {

	public function new(?align:Align, ?border:Border<Int>) {
		layout = new AlignLayoutCore<Container>(align, border);
		super();
	}
	
}