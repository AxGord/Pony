package pony.heaps;

import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.geom.Point;
import pony.geom.Rect;

@:nullSafety(Off) @:final class SmartCanvas implements HasSignal {

	@:auto public var onStageResize: Signal2<Float, Rect<Float>>;
	@:auto public var onDynStageResize: Signal1<Rect<Float>>;

	public var width(get, never): Int;
	public var height(get, never): Int;
	public var stageWidth(default, null): Int = 0;
	public var stageHeight(default, null): Int = 0;
	public var stageInitSize(default, null): Point<Int>;
	public var scale(default, null): Float;
	public var ratio(default, null): Float;
	public var dynStage(get, never): Rect<Float>;
	public var rect: Rect<Float>;
	public var noScale: Bool = false;

	public function new(?size: Point<UInt>) {
		stageInitSize = size;
		rect = new Rect<Float>(0, 0, size.x, size.y);
	}

	@:extern private inline function get_dynStage(): Rect<Float> {
		return new Rect(-rect.x, -rect.y, width / scale, height / scale);
	}

	@:extern private inline function get_width(): Int return 800;
	@:extern private inline function get_height(): Int return 600;

	public inline function updateSize(): Void {}

}