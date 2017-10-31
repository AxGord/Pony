/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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