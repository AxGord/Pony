
package pony.heaps.ui.gui;

import h2d.Graphics;
import h2d.Object;
import h2d.Tile;

#if (heaps >= '2.0.0')
import h3d.Vector4 as Vector;
#else
import h3d.Vector;
#end

import pony.geom.Point;

/**
 * NodeRepeat
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
@:final class NodeRepeat extends Node {

	public var graphics: Graphics;

	public function new(tile: Tile, ?parent: Object) {
		super(new Point(tile.width, tile.height), parent);
		graphics = new Graphics(this);
		graphics.tileWrap = true;
		graphics.beginTileFill(tile);
		changeWh << updateSize;
		changeFlipx << changeFlipxHandler;
		changeFlipy << changeFlipyHandler;
		changeTint << updateColor;
		updateSize();
	}

	private function updateSize(): Void {
		graphics.clear();
		graphics.drawRect(0, 0, w, h);
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

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function updatePosition(): Void {
		graphics.setPosition(flipx ? x + w : x, flipy ? y + w : y);
	}

	override public function destroy(): Void {
		super.destroy();
		graphics.clear();
		@:nullSafety(Off) graphics = null;
	}

}