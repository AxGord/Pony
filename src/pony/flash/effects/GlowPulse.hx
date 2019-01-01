package pony.flash.effects;

import flash.display.DisplayObject;
import flash.filters.GlowFilter;
import pony.time.DeltaTime;
import pony.time.DT;

/**
 * GlowPulse
 * @author AxGord <axgord@gmail.com>
 */
class GlowPulse {

	public var targer:DisplayObject;
	
	private var filter:GlowFilter;
	private var maxStrength:Int;
	private var speed:Float;
	
	private var d:Int = 1;
	
	public function new(color:Int=0xFF0000, size:Int=30, strength:Int=2, speed:Float=1) {
		filter = new GlowFilter(color, 1, size, size, 0);
		this.maxStrength = strength;
		this.speed = speed;
	}
	
	public function start():Void DeltaTime.fixedUpdate << update;
	
	public function stop():Void {
		targer.filters = [];
		filter.strength = 0;
		DeltaTime.fixedUpdate >> update;
	}
	
	public function update(dt:DT):Void {
		dt *= speed;
		filter.strength += d * dt;
		if (filter.strength > maxStrength) {
			d = -1;
			var ddt = dt - (filter.strength - maxStrength);
			filter.strength += d * dt;
		} else if (filter.strength <= 0) {
			d = 1;
			var ddt = dt + filter.strength;
			filter.strength += d * dt;
		}
		targer.filters = [filter];
	}
	
}