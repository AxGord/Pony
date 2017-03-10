/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
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