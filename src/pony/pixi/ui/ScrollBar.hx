package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pony.events.Signal0;
import pony.geom.Point;
import pony.pixi.ui.Bar;
import pony.ui.touch.pixi.Touchable;
import pony.ui.touch.Touch;

/**
 * ScrollBar
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBar extends Sprite {

	public var onReady:Signal0;
	private var bar:Bar;
	private var totalSize:Float;
	public var pos(default, set):Int = 0;
	private var contentSize:Float;
	private var touchable:Touchable;
	private var startTPos:Float;
	private var startTPosBefore:Int;
	private var vert:Bool;

	public function new(
		size:Int,
		begin:String,
		body:String,
		vert:Bool = true,
		?offset:Point<Int>,
		useSpriteSheet:Bool = false,
		creep:Float = 0
	) {
		super();
		this.vert = vert;
		totalSize = size;
		var point = vert ? new Point(0, size) : new Point(size, 0);
		bar = new Bar(point, begin, body, offset, false, useSpriteSheet, creep);
		addChild(bar);
		onReady = bar.onReady;
	}

	public function updateContent(size:Float):Void {
		contentSize = size;
		bar.core.percent = size > totalSize ? totalSize / size : 1;
		if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
		updatePos();
	}

	public dynamic function onChangePosition(v:Int):Void {}

	public function scroll(delta:Int):Void pos += delta;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_pos(v:Int):Int {
		if (v != pos) {
			pos = v;
			if (pos > 0) pos = 0;
			if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
			updatePos();
		}
		return pos;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function updatePos():Void {
		onChangePosition(pos);
		var p = ( pos / (totalSize - contentSize));
		var v = (totalSize - bar.core.pos) * p;
		if (vert)
			bar.y = v;
		else
			bar.x = v;
	}

	public function setTouchable(t:Touchable):Void {
		touchable = t;
		touchable.onDown < beginMove;
	}

	private function beginMove(t:Touch):Void {
		startTPosBefore = pos;
		startTPos = vert ? t.y : t.x;
		t.onMove << move;
		t.onUp < endMove;
		t.onOutUp < endMove;
	}

	private function endMove(t:Touch):Void {
		t.onUp >> endMove;
		t.onOutUp >> endMove;
		t.onMove >> move;
		if (onReady == null) return;
		move(t);
		touchable.onDown < beginMove;
	}

	private function move(t:Touch):Void pos = startTPosBefore - Std.int(startTPos - (vert ? t.y : t.x));

	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		onChangePosition = null;
		removeChild(bar);
		bar.destroy();
		bar = null;
		onReady = null;
		touchable = null;
		super.destroy(options);
	}

}