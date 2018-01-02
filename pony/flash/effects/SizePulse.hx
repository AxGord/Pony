/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import flash.geom.Rectangle;
import pony.time.DeltaTime;
import pony.time.DT;

/**
 * SizePulse
 * @author AxGord <axgord@gmail.com>
 */
class SizePulse {

	public var targer:DisplayObject;

	private var maxSize:Float;
	private var speed:Float;
	private var mid:Bool;
	
	private var d:Int = 1;
	
	private var bRect:Rectangle;
	
	public function new(size:Float=1.2, speed:Float=1, mid:Bool=false) {
		maxSize = size;
		this.speed = speed;
		this.mid = mid;
	}

	
	public function start():Void {
		if (maxSize > 1) DeltaTime.fixedUpdate << updateToBig;
		else DeltaTime.fixedUpdate << updateToSmall;
		if (mid) {
			bRect = new Rectangle(targer.x, targer.y, targer.width, targer.height);
			DeltaTime.fixedUpdate << updateMid;
		}
	}
	
	public function stop():Void {
		if (maxSize > 1) DeltaTime.fixedUpdate >> updateToBig;
		else DeltaTime.fixedUpdate >> updateToSmall;
		if (mid) {
			DeltaTime.fixedUpdate >> updateMid;
			targer.scaleX = 1;
			targer.scaleY = 1;
			targer.x = bRect.x;
			targer.y = bRect.y;
		}
	}
	
	public function updateToBig(dt:DT):Void {
		dt *= speed;
		targer.scaleX = targer.scaleY += d * dt;
		if (targer.scaleX > maxSize) {
			d = -1;
			var ddt = dt - (targer.scaleX - maxSize);
			targer.scaleX = targer.scaleY += d * dt;
		} else if (targer.scaleX <= 1) {
			d = 1;
			var ddt = dt + (targer.scaleX-1);
			targer.scaleX = targer.scaleY += d * dt;
		}
	}
	
	public function updateToSmall(dt:DT):Void {
		dt *= speed;
		targer.scaleX = targer.scaleY += d * dt;
		if (targer.scaleX >= 1) {
			d = -1;
			var ddt = dt - (targer.scaleX - 1);
			targer.scaleX = targer.scaleY += d * dt;
		} else if (targer.scaleX <= maxSize) {
			d = 1;
			var ddt = dt + (targer.scaleX-maxSize);
			targer.scaleX = targer.scaleY += d * dt;
		}
	}
	
	private function updateMid():Void {
		var dw = targer.width - bRect.width;
		var dh = targer.height - bRect.height;
		targer.x = bRect.x - dw / 2;
		targer.y = bRect.y - dh / 2;
	
	}
	
}