package pony.ui.gui;

import pony.events.Signal1;
import pony.geom.Angle;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.ExtendedProperties;
import pony.magic.HasSignal;
import pony.math.MathTools;

/**
 * Turning
 * @author AxGord <axgord@gmail.com>
 */
class TurningCore implements Declarator implements ExtendedProperties implements HasSignal {
	
	public var currentAngle(_, set):Angle;
	@:auto public var changeAngle:Signal1<Angle>;
	public var current(_, set):Float;
	@:auto public var change:Signal1<Float>;
	public var minAngle:Null<Angle>;
	public var maxAngle:Null<Angle>;
	
	private function set_currentAngle(v:Angle):Angle {
		if (minAngle != null && maxAngle != null) {
			v -= maxAngle;
			minAngle -= maxAngle;
			
			var mid:Angle = minAngle / 2;
			if (v < minAngle && v > mid*1.5) v = minAngle;
			else if (v < mid*0.5) v = 0;
			else if (v >= mid * 0.5 && v <= mid * 1.5) {
				minAngle += maxAngle;
				v += maxAngle;
				return v;
			}
			
			minAngle += maxAngle;
			v += maxAngle;
		}
		if (v == currentAngle) return v;
		eChangeAngle.dispatch(currentAngle = v);
		eChange.dispatch(current = angleToValue(v));
		return v;
	}
	
	private function angleToValue(a:Angle):Float {
		if (minAngle != null && maxAngle != null) {
			var m:Angle = 360 - minAngle;
			return MathTools.percentBackCalc(a + m, 0, maxAngle+m);
		} else {
			return MathTools.percentBackCalc(a, 0, 360);
		}
	}
	
	private function valueToAngle(v:Float):Angle {
		if (minAngle != null && maxAngle != null) {
			var m:Angle = 360 - minAngle;
			return MathTools.percentCalc(v, 0, maxAngle+m) - m;
		} else {
			return MathTools.percentCalc(v, 0, 360); 
		}
	}
	
	private function set_current(v:Float):Float {
		if (v == current) return v;
		current = v;
		eChangeAngle.dispatch(currentAngle = valueToAngle(v));
		return v;
	}
	
	inline public function toPoint(p:Point<Float>):Void set_currentAngle(Math.atan2(p.y, p.x) * 180 / Math.PI);
	
}