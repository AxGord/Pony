package pony.unity3d;

import unityengine.Animation;
import unityengine.AnimationState;
import unityengine.RuntimeAnimatorController;

using hugs.HUGSWrapper;

/**
 * HandAnimation
 * @author AxGord
 */
abstract HandAnimation(AnimationState) {

	public var time(get, set): Float;

	public inline function new(anim: Animation) {
		for (a in anim) {
			this = a;
			break;
		}
		this.speed = 0;
	}

	private inline function get_time(): Float return this.time;

	public function set_time(t: Float): Float {
		this.time = t;
		if (this.time < 0) this.time += Std.int(Math.abs(this.time) / this.length + 1) * this.length;
		return this.time -= Std.int(this.time / this.length) * this.length;
	}

	@:from private static inline function fromAnim(anim: Animation): HandAnimation return new HandAnimation(anim);

}
