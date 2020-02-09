package pony.flash.effects;

import flash.display.DisplayObject;
import flash.geom.Rectangle;
import pony.time.DeltaTime;
import pony.time.DT;

/**
 * SizePulse
 * @author AxGord <axgord@gmail.com>
 */
class SizePulse {

	public var targer: DisplayObject;

	private var maxSize: Float;
	private var speed: Float;
	private var mid: Bool;

	private var d: Int = 1;

	private var bRect: Rectangle;

	public function new(size: Float = 1.2, speed: Float = 1, mid: Bool = false) {
		maxSize = size;
		this.speed = speed;
		this.mid = mid;
	}

	public function start(): Void {
		if (maxSize > 1)
			DeltaTime.fixedUpdate << updateToBig;
		else
			DeltaTime.fixedUpdate << updateToSmall;
		if (mid) {
			bRect = new Rectangle(targer.x, targer.y, targer.width, targer.height);
			DeltaTime.fixedUpdate << updateMid;
		}
	}

	public function stop(): Void {
		if (maxSize > 1)
			DeltaTime.fixedUpdate >> updateToBig;
		else
			DeltaTime.fixedUpdate >> updateToSmall;
		if (mid) {
			DeltaTime.fixedUpdate >> updateMid;
			targer.scaleX = 1;
			targer.scaleY = 1;
			targer.x = bRect.x;
			targer.y = bRect.y;
		}
	}

	public function updateToBig(dt: DT): Void {
		dt *= speed;
		targer.scaleX = targer.scaleY += d * dt;
		if (targer.scaleX > maxSize) {
			d = -1;
			var ddt = dt - (targer.scaleX - maxSize);
			targer.scaleX = targer.scaleY += d * dt;
		} else if (targer.scaleX <= 1) {
			d = 1;
			var ddt = dt + (targer.scaleX - 1);
			targer.scaleX = targer.scaleY += d * dt;
		}
	}

	public function updateToSmall(dt: DT): Void {
		dt *= speed;
		targer.scaleX = targer.scaleY += d * dt;
		if (targer.scaleX >= 1) {
			d = -1;
			var ddt = dt - (targer.scaleX - 1);
			targer.scaleX = targer.scaleY += d * dt;
		} else if (targer.scaleX <= maxSize) {
			d = 1;
			var ddt = dt + (targer.scaleX - maxSize);
			targer.scaleX = targer.scaleY += d * dt;
		}
	}

	private function updateMid(): Void {
		var dw = targer.width - bRect.width;
		var dh = targer.height - bRect.height;
		targer.x = bRect.x - dw / 2;
		targer.y = bRect.y - dh / 2;

	}

}