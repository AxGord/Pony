package pony.ui.touch;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.geom.Point;

/**
 * Touch
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:nullSafety class Touch implements HasSignal {

	@:auto public var onOver: Signal1<Touch>;
	@:auto public var onOut: Signal1<Touch>;
	@:auto public var onOutUp: Signal1<Touch>;
	@:auto public var onOverDown: Signal1<Touch>;
	@:auto public var onOutDown: Signal1<Touch>;
	@:auto public var onDown: Signal1<Touch>;
	@:auto public var onUp: Signal1<Touch>;
	@:auto public var onMove: Signal1<Touch>;

	public var x(default, null): Float = 0;
	public var y(default, null): Float = 0;
	public var point(get, never): Point<Float>;

	public function new() {}

	public function clear(): Void {
		onOver.clear();
		onOut.clear();
		onOutUp.clear();
		onOverDown.clear();
		onOutDown.clear();
		onDown.clear();
		onUp.clear();
		onMove.clear();
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set(newX: Float, newY: Float): Touch {
		x = newX;
		y = newY;
		return this;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_point(): Point<Float> return new Point<Float>(x, y);

}