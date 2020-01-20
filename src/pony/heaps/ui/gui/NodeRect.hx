package pony.heaps.ui.gui;

import h2d.Graphics;
import h2d.Object;
import h3d.Vector;
import pony.Pair;
import pony.geom.Point;
import pony.color.UColor;

/**
 * NodeRect
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety @:final class NodeRect extends Node {

	public var graphics: Graphics;
	private var round: Float;
	private var lineStyle: Null<Pair<UColor, Float>>;

	public function new(size: Point<Float>, ?lineStyle: Pair<UColor, Float>, ?color: UColor, round: Float = 0, ?parent: Object) {
		super(size, parent);
		this.round = round;
		this.lineStyle = lineStyle;
		graphics = new Graphics(this);
		if (color != null) graphics.beginFill(color.rgb, color.invertAlpha.af);
		changeWh << updateSize;
		changeFlipx << changeFlipxHandler;
		changeFlipy << changeFlipyHandler;
		changeTint << updateColor;
		updateSize();
	}

	private function updateSize(): Void {
		graphics.clear();
		if (lineStyle != null) graphics.lineStyle(lineStyle.b, lineStyle.a.rgb, lineStyle.a.invertAlpha.af);
		if (round == 0)
			graphics.drawRect(0, 0, w, h);
		else
			graphics.drawRoundedRect(0, 0, w, h, round);
		updatePosition();
	}

	private function updateColor(v: Vector): Void {
		graphics.color = v;
	}

	private function changeFlipxHandler(flip: Bool): Void {
		graphics.scaleX = flip ? -1 : 1;
		updatePosition();
	}

	private function changeFlipyHandler(flip: Bool): Void {
		graphics.scaleY = flip ? -1 : 1;
		updatePosition();
	}

	@:extern private inline function updatePosition(): Void {
		graphics.setPosition(flipx ? x + w : x, flipy ? y + w : y);
	}

	override public function destroy(): Void {
		super.destroy();
		graphics.clear();
		@:nullSafety(Off) graphics = null;
	}

}