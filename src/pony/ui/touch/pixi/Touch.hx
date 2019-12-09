package pony.ui.touch.pixi;

import haxe.Int64;
import pixi.core.display.Container;
import pixi.interaction.InteractionEvent;
import pony.events.Signal1;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

typedef TouchObj = {
	x: Float,
	y: Float,
	id: UInt
}

/**
 * PixiJS Touch
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements Declarator implements HasSignal {

	@:auto public static var onMove: Signal1<TouchObj>;
	@:auto public static var onStart: Signal1<TouchObj>;
	@:auto public static var onEnd: Signal1<TouchObj>;
	@:auto public static var onCancle: Signal1<UInt>;

	private static var tMove: Map<String, TouchObj> = new Map<String, TouchObj>();
	private static var startStack: Array<TouchObj> = [];
	private static var endStack: Array<TouchObj> = [];

	private static var obj: Container;

	public  static var inited(default, null): Bool = false;

	public static function reg(obj: Container): Void {
		if (Touch.obj == null) {
			Touch.obj = obj;
			if (inited) _init();
		}
	}

	public static function init(): Void {
		if (inited) return;
		inited = true;
		if (obj != null) _init();
	}

	public static function _init(): Void {
		regSub(obj);
	}

	public static function regSub(obj: Container): Void {
		obj.interactive = true;
		eMove.onTake << function() obj.on('touchstart', startHandler);
		eMove.onLost << function() obj.removeListener('touchstart', startHandler);
		eEnd.onTake << function() obj.on('touchend', endHandler);
		eEnd.onLost << function() obj.removeListener('touchend', endHandler);
		eMove.onTake << function() obj.on('touchmove', moveHandler);
		eMove.onLost << function() obj.removeListener('touchmove', moveHandler);
		eCancle.onTake << function() obj.on('touchendoutside', handleTouchEvent);
		eCancle.onLost << function() obj.removeListener('touchendoutside', handleTouchEvent);
	}

	private static function handleTouchEvent(e: InteractionEvent): Void {
		eCancle.dispatch(untyped e.data.identifier);
	}

	@:extern private static inline function pack(e: InteractionEvent): TouchObj {
		var p = correction(e.data.global.x, e.data.global.y);
		return { id: untyped e.data.identifier, x:p.x, y:p.y };
	}

	private static function moveHandler(e:InteractionEvent):Void {
		tMove[Std.string(untyped e.data.identifier)] = pack(e);
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
	}

	private static function moveDispatch(): Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map<String, TouchObj>();
	}

	private static function startHandler(e: InteractionEvent): Void {
		startStack.push(pack(e));
		DeltaTime.fixedUpdate.once(startDispatch, -9);
	}

	private static function startDispatch(): Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}

	private static function endHandler(e: InteractionEvent): Void {
		endStack.push(pack(e));
		DeltaTime.fixedUpdate.once(endDispatch, -7);
	}

	private static function endDispatch(): Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}

	public static dynamic function correction(x: Float, y: Float): Point<Float> return new Point(x, y);

}