package pony.pixi.ui;

import pixi.core.display.Container;
import pony.ui.gui.ZeroPlaceCore;

/**
 * ZeroPlace
 * @author AxGord <axgord@gmail.com>
 */
class ZeroPlace extends BaseLayout<ZeroPlaceCore<Container>> {

	public function new() {
		layout = new ZeroPlaceCore<Container>();
		super();
	}
	
}