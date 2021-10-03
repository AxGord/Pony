package pony.midi.devices;

import pony.events.Signal2;
import pony.geom.Point.IntPoint;
import pony.math.Matrix;
import pony.midi.devices.LaunchpadColor;

/**
 * VirtualLaunchpad
 * @author AxGord
 */
class VirtualLaunchpad extends Logable implements ILaunchpad {

	public var areaState(default, null):Matrix<LaunchpadColor>;
	public var topState(default, null):Array<LaunchpadColor>;
	public var rightState(default, null):Array<LaunchpadColor>;

	@:auto public var onArea:Signal2<IntPoint, Bool>;
	@:auto public var onTop:Signal2<Int, Bool>;
	@:auto public var onRight:Signal2<Int, Bool>;

	public function new() {
		super();
		reset();
	}

	inline public function setAreaPoint(p:IntPoint, color:LaunchpadColor = AmberFull):Void {
		if (areaState.get(p) != color) {
			areaState.set(p, color);
		}
	}

	inline public function setMatrixCI(m:Matrix<Int>):Void setMatrix(m.map(LaunchpadColor.fromIndex));

	public function setMatrix(m:Matrix<LaunchpadColor>):Void {
		m = m.cut(8, 8);
		for (y in 0...m.length) for (x in 0...m[y].length) setAreaPoint(new IntPoint(x, y), m[y][x]);
	}

	public function setTop(p:Int, color:LaunchpadColor = AmberFull):Void {
		if (topState[p] != color) {
			topState[p] = color;
		}
	}

	public function setRight(p:Int, color:LaunchpadColor = AmberFull):Void {
		if (rightState[p] != color) {
			rightState[p] = color;
		}
	}

	public function reset():Void {
		areaState = [for (_ in 0...8) [for (_ in 0...8) Off] ];
		topState = [for (_ in 0...8) Off];
		rightState = [for (_ in 0...8) Off];
	}


}