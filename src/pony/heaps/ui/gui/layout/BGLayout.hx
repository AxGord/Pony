
package pony.heaps.ui.gui.layout;

import h2d.Object;
import h2d.Bitmap;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * BGLayout
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class BGLayout extends BaseLayout<RubberLayoutCore<Object>> {

	public function new(img: Bitmap, vert: Bool = false, ?border: Border<Int>, mask: Bool = false) {
		var layout: RubberLayoutCore<Object> = new RubberLayoutCore<Object>(vert, border, mask);
		layout.width = img.tile.width * img.scaleX;
		layout.height = img.tile.height * img.scaleY;
		super(layout);
		addChild(img);
	}

}