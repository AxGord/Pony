package pony.pixi.nape;

import pixi.core.graphics.Graphics;
import pony.physics.nape.BodyCircle;

/**
 * BodyCircleView
 * @author AxGord <axgord@gmail.com>
 */
class BodyCircleView extends BodyBaseView<BodyCircle> {

	override private function drawDebug(g:Graphics):Void {
		g.drawCircle(core.radius, core.radius, core.radius);
		g.moveTo(core.radius, core.radius);
		g.lineTo(core.radius * 2, core.radius);
		g.x = -core.radius;
		g.y = -core.radius;
	}

}