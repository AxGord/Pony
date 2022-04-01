package pony.heaps.sound;

import hxd.snd.Channel;
import hxd.snd.Effect;

import pony.events.Signal1;
import pony.magic.HasLink;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.time.Time;
import pony.time.TimeInterval;

/**
 * ChannelController
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class ChannelController implements HasSignal implements HasLink {

	private static inline var END_OFFSET: Int = 64;

	@:auto public var onComplete: Signal1<ChannelController>;

	public var mute(link, link): Bool = channel.mute;
	public var effects(link, link): Array<Effect> = channel.effects;
	public var pause(default, set): Bool = false;
	public var timeLeft(link, never): Time = timer.time.max - timer.currentTime;
	public var loop(default, null): Bool = false;

	private var channel: Channel;
	private var timer: DTimer;
	private var completed: Bool = true;

	public function new(channel: Channel) {
		this.channel = channel;
		timer = DTimer.createFixedTimer(0);
		timer.complete << completeHandler;
	}

	private function set_pause(value: Bool): Bool {
		if (!completed) {
			pause = value;
			channel.pause = value;
			if (value) {
				timer.stop();
			} else {
				if (loop) {
					start();
					timer.reset();
				}
				timer.start();
			}
		}
		return value;
	}

	public inline function equal(pos: TimeInterval): Bool return !completed && timer.time.min == pos.min && timer.time.max == getMax(pos);

	public function play(pos: TimeInterval, loop: Bool, volume: Float) {
		completed = false;
		this.loop = loop;
		timer.time = TimeInterval.create(pos.min, getMax(pos));
		timer.repeatCount = loop ? -1 : 0;
		if (!loop) start();
		channel.volume = volume;
		timer.reset();
		pause = false;
	}

	private inline function start() channel.position = timer.time.min.totalMs / 1000;

	public function stop() {
		completed = true;
		timer.stop();
		channel.pause = true;
		eComplete.dispatch(this);
	}

	private function completeHandler(): Void {
		if (timer.repeatCount == 0)
			stop();
		else
			start();
	}

	public inline function addEffect<T: Effect>(e: T): T return channel.addEffect(e);
	public inline function getEffect<T: Effect>(etype: Class<T>): T return channel.getEffect(etype);
	public inline function removeEffect(e: Effect) channel.removeEffect(e);

	private inline function getMax(pos: TimeInterval): Int return (pos.max == 0 ? Std.int(channel.duration * 1000) : pos.max) - END_OFFSET;

}