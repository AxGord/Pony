package pony.pixi.nape;

import pixi.core.graphics.Graphics;
import haxe.io.BytesInput;
import pony.Byte;
import pony.physics.nape.BodyShape;

/**
 * BodyShapeView
 * @author AxGord <axgord@gmail.com>
 */
class BodyShapeView extends BodyBaseView<BodyShape> {

	override private function drawDebug(g:Graphics):Void {
		var bi = new BytesInput(core.sbytes);
		var pb:Byte = bi.readByte();
		var fp:Byte = bi.readByte();
		g.moveTo(fp.a * core.resolution, fp.b * core.resolution);
		while (bi.position < bi.length) {
			var p:Byte = bi.readByte();
			g.lineTo(p.a * core.resolution, p.b * core.resolution);
		}
		g.lineTo(fp.a * core.resolution, fp.b * core.resolution);
		g.beginFill(g.lineColor = debugLines.pivotColor);
		g.x = -pb.a * core.resolution;
		g.y = -pb.b * core.resolution;
		g.drawCircle(-g.x, -g.y, debugLines.pivotSize);
	}

}