package pony.openfl.ui;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import pony.geom.Align;
import pony.geom.Border;
import pony.openfl.ui.BaseLayout;
import pony.ui.gui.AlignLayoutCore;

/**
 * AlignLayout
 * @author meerfolk<meerfolk@gmail.com>
 */
class AlignLayout extends BaseLayout<AlignLayoutCore<DisplayObject>> {

	public function new(?align:Align, ?border:Border<Int>) {
		layout = new AlignLayoutCore<DisplayObject>(align, border);
		super();
	}
	
}