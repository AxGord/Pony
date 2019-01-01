package pony.pixi.nape;

import pixi.core.graphics.Graphics;
import pony.physics.nape.BodyBox;

/**
 * BodyBoxView
 * @author AxGord <axgord@gmail.com>
 */
class BodyBoxView extends BodyBaseView<BodyBox> {
	
	override function drawDebug(g:Graphics):Void {
		g.drawRect(0, 0, core.size.x, core.size.y);
		g.position.set(-core.size.x / 2, -core.size.x / 2);
	}

}