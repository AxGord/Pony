package pony.ui.gui;

import pony.math.MathTools;
import pony.time.Time;

using StringTools;

/**
 * AnimSmoothMode
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract AnimSmoothMode(Int) to Int from Int {

	final None = 1;
	final Simple = 2;
	final Super = 3;

	@:from public static function fromString(s: String): AnimSmoothMode {
		return if (s == null)
			None;
		else
			switch s.trim().toLowerCase() {
				case 'simple': Simple;
				case 'super': Super;
				case _: None;
			}
	}

}

/**
 * AnimTextureCore
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) abstract #end
class AnimTextureCore extends AnimCore {

	private final smooth: AnimSmoothMode;
	private final additionalSrc: UInt;

	public function new(
		frameTime: Time, fixedTime: Bool = false, smooth: AnimSmoothMode = AnimSmoothMode.None, additionalSrc: UInt = 0
	) {
		if (additionalSrc > 1) throw 'Not supported';
		super(frameTime, fixedTime);
		this.smooth = smooth;
		this.additionalSrc = additionalSrc;
		if (additionalSrc == 1)
			switch smooth {
				case AnimSmoothMode.None: onFrame << frameNoneOddHandler;
				case AnimSmoothMode.Simple: onFrame << frameSimpleOddHandler;
				case AnimSmoothMode.Super: onFrame << frameSuperOddHandler;
			}
		else
			switch smooth {
				case AnimSmoothMode.None: onFrame << frameNoneHandler;
				case AnimSmoothMode.Simple: onFrame << frameSimpleHandler;
				case AnimSmoothMode.Super: onFrame << frameSuperHandler;
			}
	}

	private function frameNoneHandler(n: Int): Void {
		setTexture(0, n);
	}

	private function frameNoneOddHandler(n: Int): Void {
		setTexture(n % 2, n);
	}

	private function frameSimpleHandler(n: Int): Void {
		setTexture(n % 2, n);
		setTexture(1 - n % 2, n == totalFrames - 1 ? 0 : n + 1);
	}

	private function frameSimpleOddHandler(n: Int): Void {
		final map: Map<Int, Int> = MathTools.clipSmoothOddSimple(n, totalFrames);
		for (k => value in map) setTexture(k, value);
	}

	private function frameSuperHandler(n: Int): Void {
		final map: Map<Int, Int> = MathTools.clipSmooth(n, totalFrames);
		for (k => value in map) setTexture(k, value);
	}

	private function frameSuperOddHandler(n: Int): Void {
		final map: Map<Int, Int> = MathTools.clipSmoothOdd(n, totalFrames);
		for (k => value in map) setTexture(k, value);
	}

	@:abstract private function setTexture(n: Int, f: Int): Void;

	#if (haxe_ver < 4.2)
	private function get_totalFrames(): Int return throw 'abstract';
	#end

}
