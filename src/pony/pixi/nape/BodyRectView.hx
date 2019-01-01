package pony.pixi.nape;

import pixi.core.graphics.Graphics;
import pony.physics.nape.BodyRect;

/**
 * BodyRectView
 * @author AxGord <axgord@gmail.com>
 */
class BodyRectView extends BodyBaseView<BodyRect> {

	override private function drawDebug(g:Graphics):Void {
		g.drawRect(0, 0, core.size.width - core.size.x, core.size.height - core.size.y);
		g.x = core.size.x;
		g.y = core.size.y;
	}

}