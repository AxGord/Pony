package pony.flash.starling.ui;

import flash.geom.Point;
import pony.geom.Angle;
import pony.ui.gui.TurningCore;
import starling.display.Sprite;
import starling.display.DisplayObject;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;

/**
 * TurningStarling
 * @author Maletin
 */
class StarlingTurningFree extends Sprite {

	private static var _id: Int = 0;

	public var id: Int = _id++;

	private var _source: Sprite;

	private var handle: DisplayObject;
	private var lmin: DisplayObject;
	private var lmax: DisplayObject;
	private var button: StarlingButton;

	private var _handleInitAngleDeg: Float;
	private var _zero: Point = new Point(0, 0);
	private var _bufferPoint: Point = new Point(0, 0);

	public var core: TurningCore;

	public function new(source: Sprite, core: TurningCore, flashSource: flash.display.Sprite) {
		super();

		_source = source;
		this.core = core;

		this.transformationMatrix = _source.transformationMatrix;

		handle = _source.getChildByName('handle');
		lmin = _source.getChildByName('lmin');
		lmax = _source.getChildByName('lmax');
		button = cast _source.getChildByName('button');

		while (_source.numChildren > 0) {
			addChild(_source.getChildAt(0));
		}

		handle.touchable = false;
		button.touchable = true;

		_handleInitAngleDeg = untyped flashSource.handle.rotation;

		core.changeAngle << function(r: Angle) handle.rotation = (r - _handleInitAngleDeg) / 180 * Math.PI;

		if (lmin != null)
			lmin.visible = false;
		if (lmax != null)
			lmax.visible = false;

		if (lmin != null)
			core.minAngle = untyped flashSource.lmin.rotation;
		if (lmax != null)
			core.maxAngle = untyped flashSource.lmax.rotation;
		core.currentAngle = _handleInitAngleDeg;

		TouchManager.addListener(this, onMove, [TouchEventType.Down, TouchEventType.Move]);
	}

	private function onMove(e: TouchManagerEvent): Void {
		localToGlobal(_zero, _bufferPoint);
		core.toPoint({x: e.globalX - _bufferPoint.x, y: e.globalY - _bufferPoint.y});
	}

}