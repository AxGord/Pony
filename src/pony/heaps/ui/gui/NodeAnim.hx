package pony.heaps.ui.gui;

import h2d.Anim;
import h2d.Object;
import h2d.Tile;
import pony.geom.Border;
import pony.geom.Point;
import pony.time.DT;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.time.Time;

/**
 * NodeAnim
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class NodeAnim extends Node {

	public final anim: Anim;

	/** The frame a parked sheet sits on: where every spin starts and where it lands. */
	public var restFrame(default, null): Int = 0;

	/**
	 * How much a spin backlog speeds the sheet up: every turn owed beyond the first adds this
	 * many times the base speed. Zero — the default — works the backlog off at a steady rate.
	 */
	public final boost: Float;

	/** Ceiling for that speed-up, in frames a second. Null lets it scale without bound. */
	public final maxSpeed: Null<Float>;

	private var delay: Null<DTimer>;

	/** Owns the frame subscription, so parking, landing and destruction cannot fall out of sync. */
	private var spinning(default, set): Bool = false;

	private var parked: Bool = false;

	/** How far into the current spin the sheet is, and where that spin ends, both in frames. */
	private var turned: Float = 0;

	private var target: Float = 0;

	public function new(
		tiles: Array<Tile>, speed: Float = 15, ?delay: Time, ?rest: Int, ?boost: Float, ?maxSpeed: Float, ?border: Border<Int>,
		?parent: Object
	) {
		super(new Point(tiles[0].width, tiles[0].height), border, parent);
		this.boost = boost != null ? boost : 0;
		this.maxSpeed = maxSpeed;
		anim = new Anim(tiles, speed, this);
		anim.setPosition(this.border.left, this.border.top);
		if (rest != null) {
			park(rest);
		} else if (delay != null) {
			this.delay = DTimer.createFixedTimer(delay);
			this.delay.complete << delayHandler;
			anim.loop = false;
			@:nullSafety(Off) anim.onAnimEnd = this.delay.start0;
		}
	}

	private function set_spinning(value: Bool): Bool {
		if (value != spinning) {
			if (value)
				DeltaTime.update << spinHandler;
			else
				DeltaTime.update >> spinHandler;
			spinning = value;
		}
		return value;
	}

	/** Stops the sheet playing and parks it on `frame`: from here `spin` is the only thing that moves it. */
	public function park(frame: Int = 0): Void {
		parked = true;
		restFrame = frame;
		settle();
	}

	/**
	 * Adds turns to whatever the sheet is already doing, so a burst keeps it going instead of
	 * restarting it each time, and the deeper the backlog the faster it works through it. The
	 * sheet always lands back on `restFrame`.
	 */
	public function spin(turns: Float = 1): Void {
		if (!parked) throw 'Park the animation before spinning it';
		target += turns * anim.frames.length;
		spinning = true;
	}

	override public function destroy(): Void {
		spinning = false;
		super.destroy();
	}

	private function spinHandler(dt: DT): Void {
		// The backlog only ever adds to the base rate, never eats into it — a rate that fell away
		// with the backlog would leave the last turn crawling towards a frame it never reaches.
		final owed: Float = (target - turned) / anim.frames.length;
		final rate: Float = anim.speed * (1 + Math.max(owed - 1, 0) * boost);
		final max: Null<Float> = maxSpeed;
		turned += (max != null && rate > max ? max : rate) * dt;
		if (turned >= target)
			settle();
		else
			anim.currentFrame = restFrame + turned;
	}

	/** Back onto the resting frame with nothing owed — the state `park` starts from and every spin ends in. */
	private function settle(): Void {
		spinning = false;
		turned = 0;
		target = 0;
		anim.pause = true;
		anim.currentFrame = restFrame;
	}

	private function delayHandler(): Void {
		@:nullSafety(Off) delay.reset();
		anim.currentFrame = 0;
		anim.pause = false;
	}

}
