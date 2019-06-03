
package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.AlignLayoutCore;

/**
 * AlignLayout
 * @author AxGord <axgord@gmail.com>
 */
class AlignLayout extends BaseLayout<AlignLayoutCore<Object>> {

	public function new(?align:Align, ?border:Border<Int>) {
		layout = new AlignLayoutCore<Object>(align, border);
		super();
	}
	
}