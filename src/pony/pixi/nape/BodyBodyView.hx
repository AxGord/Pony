package pony.pixi.nape;

import haxe.io.BytesInput;
import nape.geom.Vec2;
import nape.shape.Shape;
import nape.shape.ShapeList;
import pixi.core.graphics.Graphics;
import pony.Byte;
import pony.physics.nape.BodyBody;

/**
 * BodyBodyView
 * @author AxGord <axgord@gmail.com>
 */
class BodyBodyView extends BodyBaseView<BodyBody> {

	override private function drawDebug(g: Graphics): Void {
		var shapes: ShapeList = core.body.shapes;
		for (i in 0...shapes.length) {
			final sh: Shape = shapes.at(i);
			final v = sh.castPolygon.localVerts;
			var first: Vec2 = null;
			for (j in 0...v.length) {
				final p: Vec2 = v.at(j);
				if (first == null) {
					first = p;
					g.moveTo(p.x, p.y);
				} else {
					g.lineTo(p.x, p.y);
				}
			}
			g.lineTo(first.x, first.y);
		}
		g.beginFill(g.lineColor = debugLines.pivotColor);
		g.drawCircle(-debugLines.pivotSize / 2, -debugLines.pivotSize / 2, debugLines.pivotSize);
	}

}
