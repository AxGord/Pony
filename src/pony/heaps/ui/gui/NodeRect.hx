package pony.heaps.ui.gui;

import h2d.Graphics;
import h2d.Object;

import h3d.Vector;

import pony.Pair;
import pony.color.UColor;
import pony.geom.Point;

/**
 * NodeRect
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety @:final class NodeRect extends Node {

	public var graphics: Graphics;
	private var round: Float;
	private var color: Null<UColor>;
	private var lineStyle: Null<Pair<UColor, Float>>;

	public function new(size: Point<Float>, ?lineStyle: Pair<UColor, Float>, ?color: UColor, round: Float = 0, ?parent: Object) {
		super(size, parent);
		this.round = round;
		this.color = color;
		this.lineStyle = lineStyle;
		graphics = new Graphics(this);
		changeWh << updateSize;
		changeFlipx << changeFlipxHandler;
		changeFlipy << changeFlipyHandler;
		changeTint << updateColor;
		updateSize();
	}

	private function updateSize(): Void {
		graphics.clear();
		if (color != null) graphics.beginFill(color, color.invertAlpha.af);
		if (lineStyle != null) graphics.lineStyle(lineStyle.b, lineStyle.a.rgb, lineStyle.a.invertAlpha.af);
		if (round == 0)
			graphics.drawRect(0, 0, 100, 100);
		else
			graphics.drawRoundedRect(0, 0, w, h, round);
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
		graphics.setPosition(flipx ? w : 0, flipy ? h : 0);
	}

	override public function destroy(): Void {
		super.destroy();
		graphics.clear();
		@:nullSafety(Off) graphics = null;
	}

}