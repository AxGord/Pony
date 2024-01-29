package pony.heaps;

import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.geom.Point;
import pony.geom.Rect;

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract SmallDeviceQuality(Int) to Int {
	var ideal = 1;
	var low = 2;
	var normal = 3;
	var good = 4;
}

@:nullSafety(Off) @:final class SmartCanvas implements HasSignal {

	@:auto public var onStageResize: Signal2<Float, Rect<Float>>;
	@:auto public var onDynStageResize: Signal1<Rect<Float>>;

	public var width(default, null): Int;
	public var height(default, null): Int;
	public var stageWidth(default, null): Int = 0;
	public var stageHeight(default, null): Int = 0;
	public var stageInitSize(default, null): Point<Int>;
	public var scale(default, null): Float;
	public var ratio(default, null): Float;
	public var dynStage(get, never): Rect<Float>;
	public var rect: Rect<Float>;
	public var noScale: Bool = false;
	public var smallDeviceQuality(default, set): SmallDeviceQuality;
	private var smallDeviceQualityOffset: Float;

	public function new(?size: Point<UInt>, smallDeviceQuality: SmallDeviceQuality = SmallDeviceQuality.ideal) {
		stageInitSize = size;
		if (size != null) {
			stageWidth = size.x;
			stageHeight = size.y;
		}
		rect = new Rect<Float>(0, 0, size.x, size.y);
		width = size.x;
		height = size.y;
		eDynStageResize.onTake << takeDynStageHandler;
		eDynStageResize.onLost << lostDynStageHandler;
	}

	private function takeDynStageHandler(): Void onStageResize << dynStageResize;
	private function lostDynStageHandler(): Void onStageResize >> dynStageResize;
	private function dynStageResize(): Void eDynStageResize.dispatch(dynStage);

	public inline function set_smallDeviceQuality(q: SmallDeviceQuality): SmallDeviceQuality {
		if (this.smallDeviceQuality != q) {
			this.smallDeviceQuality = q;
			smallDeviceQualityOffset = 1 - 1 / q;
			setSize(width, height);
		}
		return q;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_dynStage(): Rect<Float> {
		return new Rect(-rect.x, -rect.y, width / scale, height / scale);
	}

	private function setSize(w: Int, h: Int): Void {
		width = w;
		height = h;
		if (stageInitSize != null) setStageSize(w, h);
	}

	public inline function updateSize(): Void {}
	public dynamic function ratioMod(value: Float): Float return value;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function setStageSize(w: Int, h: Int): Void {
		if (noScale) {
			scale = 1;
			ratio = 1;
			rect = new Rect((w - stageInitSize.x) / 2, (h - stageInitSize.y) / 2, w, h);
		} else {
			var wd = w / stageInitSize.x;
			var hd = h / stageInitSize.y;
			scale = wd > hd ? hd : wd;

			ratio = (smallDeviceQuality: Int) <= 1 ? 1 :  smallDeviceQualityOffset + scale / smallDeviceQuality;
			if (ratio > 1) ratio = 1;
			ratio = ratioMod(ratio);

			var wr: Float = w / scale * ratio;
			var hr: Float = h / scale * ratio;

			var xr: Float = 0;
			var yr: Float = 0;
			if (wd > hd)
				xr = (wr - stageInitSize.x * ratio) / 2;
			else
				yr = (hr - stageInitSize.y * ratio) / 2;

			rect = new Rect(xr, yr, wr, hr);
		}
		eStageResize.dispatch(ratio, rect);
	}

}