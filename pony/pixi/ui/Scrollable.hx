package pony.pixi.ui;

import pixi.core.display.Container;
import pony.ui.touch.Touch;
import pony.ui.touch.pixi.Touchable;

/**
 * Scrollable
 * @author AxGord <axgord@gmail.com>
 */
class Scrollable extends Touchable {
	
	public var pos(default, set):Int = 0;
	private var totalSize:Float;
	private var contentSize:Float;
	private var startTPos:Float;
	private var startTPosBefore:Int;
	private var vert:Bool;
	private var inited:Bool = false;

	public function new(obj:Container, totalSize:Float, vert:Bool) {
		super(obj);
		this.totalSize = totalSize;
		this.vert = vert;
	}
	
	public function updateContent(obj:Container):Void {
		if (vert)
			_updateContent(obj.height);
		else
			_updateContent(obj.width);
	}
	
	public function _updateContent(size:Float):Void {
		if (!inited) {
			inited = true;
			onDown < beginMove;
			onWheel << mouseWheelHandler;
		}
		contentSize = size;
		if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
		updatePos();
	}
	
	public dynamic function onChangePosition(v:Int):Void {}
	
	private function mouseWheelHandler(delta:Int):Void scroll(Std.int(delta / 2));
	
	public function scroll(delta:Int):Void pos += delta;
	
	@:extern inline private function set_pos(v:Int):Int {
		if (v != pos) {
			pos = v;
			if (pos > 0) pos = 0;
			if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
			updatePos();
		}
		return pos;
	}
	
	public function scrollToEnd():Void {
		pos = Std.int(totalSize - contentSize);
		updatePos();
	}
	
	@:extern inline private function updatePos():Void {
		if (vert)
			obj.y = pos;
		else
			obj.x = pos;
		onChangePosition(pos);
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
		move(t);
		onDown < beginMove;
	}
	
	private function move(t:Touch):Void pos = startTPosBefore - Std.int(startTPos - (vert ? t.y : t.x));
	
}