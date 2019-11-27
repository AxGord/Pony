
package pony.heaps.ui.gui.layout;

import h2d.Object;
import h2d.Bitmap;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * BGLayout
 * @author AxGord <axgord@gmail.com>
 */
class BGLayout extends BaseLayout<RubberLayoutCore<Object>> {

	public function new(img: Bitmap, vert: Bool = false, ?border: Border<Int>) {
		layout = new RubberLayoutCore<Object>(vert, border);
		layout.width = img.tile.width * img.scaleX;
		layout.height = img.tile.height * img.scaleY;
		super();
		addChild(img);
	}

}