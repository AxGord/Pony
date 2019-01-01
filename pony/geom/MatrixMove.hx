package pony.geom;

import pony.events.Signal;
import pony.geom.IWards;
import pony.ui.keyboard.Keyboard;
import pony.ui.keyboard.Key;

typedef Matrix = Array < Array<Null<Int>> > ;

typedef MatrixIndex = { r:Int, c:Int };

/**
 * CameraMove
 * @author AxGord <axgord@gmail.com>
 */
class MatrixMove {
	
	private var moveMatrix:Matrix;
	private var wards:IWards<Dynamic>;
	
	public var change:Signal;
	
	public function new(moveMatrix:Matrix, wards:IWards<Dynamic>) {
		this.moveMatrix = moveMatrix;
		this.wards = wards;
		change = Reflect.field(wards, 'change');
	}
	
	public function arrowBinding():Void {
		Keyboard.press.sub(Key.Up).add(up);
		Keyboard.press.sub(Key.Down).add(down);
		Keyboard.press.sub(Key.Right).add(right);
		Keyboard.press.sub(Key.Left).add(left);
	}
	
	public function up():Void {
		var prev:MatrixIndex = getIndex();
		var index:MatrixIndex = {r:prev.r, c:prev.c};
		index.c++;
		setToIndex(prev, index);
	}
	
	
	public function down():Void {
		var prev:MatrixIndex = getIndex();
		var index:MatrixIndex = {r:prev.r, c:prev.c};
		index.c--;
		setToIndex(prev, index);
	}
	
	public function right():Void {
		var prev:MatrixIndex = getIndex();
		var index:MatrixIndex = {r:prev.r, c:prev.c};
		index.r++;
		setToIndex(prev, index);
	}
	
	public function left():Void {
		var prev:MatrixIndex = getIndex();
		var index:MatrixIndex = {r:prev.r, c:prev.c};
		index.r--;
		setToIndex(prev, index);
	}
	
	private function getIndex():MatrixIndex {
		for (r in 0...moveMatrix.length) for (c in 0...moveMatrix[r].length)
			if (Reflect.field(wards, 'currentPos')+1 == moveMatrix[r][c])
				return { r: r, c: c };
		return null;
	}
	
	private function setToIndex(prev:MatrixIndex, index:MatrixIndex):Void {
		trySet(prev, index) && trySet(prev, { r:index.r, c:index.c - 1 } ) && trySet(prev, { r:index.r, c:index.c + 1 } ) && 
		trySet(prev, { r:index.r-1, c:index.c } ) && trySet(prev, { r:index.r+1, c:index.c } );
	}
	
	private function trySet(prev:MatrixIndex, i:MatrixIndex):Bool {
		if (i.c == prev.c && i.r == prev.r) return true;
		if (moveMatrix[i.r] != null && moveMatrix[i.r][i.c] != null && moveMatrix[i.r][i.c] != 0) {
			change.dispatchArgs([moveMatrix[i.r][i.c] - 1]);
			return false;
		} else
			return true;
	}
	
}