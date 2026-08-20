package pony.pixi.ui;

import pixi.core.display.Container;
import pony.ui.touch.Touch;
import pony.ui.touch.pixi.Touchable;

/**
 * Scrollable
 * @author AxGord <axgord@gmail.com>
 */
class Scrollable extends Touchable {

	public var pos(default, set): Int = 0;

	private final totalSize: Float;
	private final vert: Bool;

	private var inited: Bool = false;
	private var contentSize: Float;
	private var startTPos: Float;
	private var startTPosBefore: Int;

	public function new(obj: Container, totalSize: Float, vert: Bool) {
		super(obj);
		this.totalSize = totalSize;
		this.vert = vert;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_pos(v: Int): Int {
		if (v != pos) {
			pos = v;
			if (pos > 0) pos = 0;
			if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
			updatePos();
		}
		return pos;
	}

	public function updateContent(obj: Container): Void {
		_updateContent(vert ? obj.height : obj.width);
	}

	public function _updateContent(size: Float): Void {
		if (!inited) {
			inited = true;
			onDown < beginMove;
			onWheel << mouseWheelHandler;
		}
		contentSize = size;
		if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
		updatePos();
	}

	public dynamic function onChangePosition(v: Int): Void {}

	public inline function scroll(delta: Int): Void pos += delta;

	public function scrollToEnd(): Void {
		pos = Std.int(totalSize - contentSize);
		updatePos();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function updatePos(): Void {
		if (vert)
			obj.y = pos;
		else
			obj.x = pos;
		onChangePosition(pos);
	}

	private function mouseWheelHandler(delta: Int): Void scroll(Std.int(delta / 2));

	private function beginMove(t: Touch): Void {
		startTPosBefore = pos;
		startTPos = vert ? t.y : t.x;
		t.onMove << move;
		t.onUp < endMove;
		t.onOutUp < endMove;
	}

	private function endMove(t: Touch): Void {
		t.onUp >> endMove;
		t.onOutUp >> endMove;
		t.onMove >> move;
		move(t);
		onDown < beginMove;
	}

	private function move(t: Touch): Void pos = startTPosBefore - Std.int(startTPos - (vert ? t.y : t.x));

}
