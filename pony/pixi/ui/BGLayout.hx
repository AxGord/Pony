package pony.pixi.ui;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

using pony.pixi.PixiExtends;

/**
 * BGLayout
 * @author AxGord <axgord@gmail.com>
 */
class BGLayout extends BaseLayout<RubberLayoutCore<Container>> {
	
	public function new(img:Sprite, vert:Bool = false, ?border:Border<Int>) {
		layout = new RubberLayoutCore<Container>(vert, border);
		layout.tasks.add();
		super();
		addChild(img);
		img.loaded(function(){
			layout.width = img.width;
			layout.height = img.height;
			layout.tasks.end();
		});
	}
	
}