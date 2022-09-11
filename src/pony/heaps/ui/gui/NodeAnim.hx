package pony.heaps.ui.gui;

import h2d.Anim;
import h2d.Object;
import h2d.Tile;

import pony.geom.Point;
import pony.time.DTimer;
import pony.time.Time;

/**
 * NodeAnim
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class NodeAnim extends Node {

	private var anim: Anim;
	private var delay: Null<DTimer>;

	public function new(tiles: Array<Tile>, speed: Float = 15, ?delay: Time, ?parent: Object) {
		super(new Point(tiles[0].width, tiles[0].height), parent);
		anim = new Anim(tiles, speed, this);
		if (delay != null) {
			this.delay = DTimer.createFixedTimer(delay);
			this.delay.complete << delayHandler;
			anim.loop = false;
			@:nullSafety(Off) anim.onAnimEnd = this.delay.start0;
		}
	}

	private function delayHandler(): Void {
		@:nullSafety(Off) delay.reset();
		anim.currentFrame = 0;
		anim.pause = false;
	}

}