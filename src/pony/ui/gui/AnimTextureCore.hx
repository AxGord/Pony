package pony.ui.gui;

import pony.time.Time;
import pony.math.MathTools;

/**
 * AnimSmoothMode
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract AnimSmoothMode(Int) to Int from Int {

	var None = 1;
	var Simple = 2;
	var Super = 3;

	@:from public static function fromString(s: String): AnimSmoothMode {
		return if (s == null)
			None;
		else switch StringTools.trim(s).toLowerCase() {
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
class AnimTextureCore extends AnimCore {

	private var smooth: AnimSmoothMode;
	private var additionalSrc: UInt;

	public function new(frameTime: Time, fixedTime: Bool = false, smooth: AnimSmoothMode = AnimSmoothMode.None, additionalSrc: UInt = 0) {
		if (additionalSrc > 1) throw 'Not supported';
		super(frameTime, fixedTime);
		this.smooth = smooth;
		this.additionalSrc = additionalSrc;
		if (additionalSrc == 1) switch smooth {
			case AnimSmoothMode.None: onFrame << frameNoneOddHandler;
			case AnimSmoothMode.Simple: onFrame << frameSimpleOddHandler;
			case AnimSmoothMode.Super: onFrame << frameSuperOddHandler;
		} else switch smooth {
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
		var map: Map<Int, Int> = MathTools.clipSmoothOddSimple(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	private function frameSuperHandler(n: Int): Void {
		var map: Map<Int, Int> = MathTools.clipSmooth(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	private function frameSuperOddHandler(n: Int): Void {
		var map: Map<Int, Int> = MathTools.clipSmoothOdd(n, totalFrames);
		for (k in map.keys()) setTexture(k, map[k]);
	}

	@:abstract private function setTexture(n: Int, f: Int): Void;

	override private function get_totalFrames(): Int return throw 'abstract';

}