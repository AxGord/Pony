package pony.ui.gui;

import pony.geom.Point;
import pony.math.MathTools;
import pony.ui.touch.Touch;

/**
 * StepSliderCore
 * @author AxGord <axgord@gmail.com>
 */
class StepSliderCore extends SliderCore {

	public var posStep: Float = 0;
	public var percentStep(get, set): Float;
	public var valueStep(get, set): Float;
	private var percentRound: Int = -1;
	private var valueRound: Int = -1;

	public function new(button: ButtonCore = null, size: Float, isVertical: Bool = false, invert: Bool = false, draggable: Bool = true) {
		super(button, size, isVertical, invert, draggable);
	}

	@:extern public static inline function create(
		?button: ButtonCore, width: Float, height: Float, invert: Bool=false, draggable: Bool = true
	): StepSliderCore {
		var isVert = height > width;
		return new StepSliderCore(button, isVert ? height :  width, isVert, invert, draggable);
	}

	@:extern private inline function set_percentStep(v: Float): Float {
		posStep = size * v;
		percentRound = MathTools.lengthAfterComma(v);
		valueRound = -1;
		return v;
	}

	@:extern private inline function get_percentStep(): Float return posStep == 0 ? 0 : posStep / size;

	@:extern private inline function set_valueStep(v: Float): Float {
		percentStep = v / (max - min);
		valueRound = MathTools.lengthAfterComma(v);
		percentRound = -1;
		return v;
	}

	@:extern private inline function get_valueStep(): Float return percentStep * (max - min);

	override private function moveHandler(t: Touch): Void setStepPos(detectPos(t.point));

	override function changePosHandler(v: Float): Void {
		if (percentRound == -1)
			super.changePosHandler(v);
		else
			percent = MathTools.roundTo(v / size, percentRound);
	}

	override function updateValue(v: Float): Void {
		if (valueRound == -1)
			super.updateValue(v);
		else
			value = MathTools.roundTo(min + v * (max - min), valueRound);
	}

	public inline function setStepPos(p: Float): Void pos = limit(posStep == 0 ? p : (Math.round(p / posStep) * posStep));

	public inline function stepMoveToPoint(t: Point<Float>): Void {
		if (trackStartPoint != null) startPoint = -trackStartPoint;
		setStepPos(detectPos(t));
	}

}