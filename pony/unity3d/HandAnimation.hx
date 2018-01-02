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
package pony.unity3d;

import unityengine.RuntimeAnimatorController;
import unityengine.AnimationState;
import unityengine.Animation;

using hugs.HUGSWrapper;

/**
 * HandAnimation
 * @author AxGord
 */
abstract HandAnimation(AnimationState) {
	
	public var time(get, set):Float;
	
	inline public function new(anim:Animation) {
		for (a in anim) {
			this = a;
			break;
		}
		this.speed = 0;
	}
	
	inline private function get_time():Float return this.time;
	
	public function set_time(t:Float):Float {
		this.time = t;
		if (this.time < 0) this.time += Std.int(Math.abs(this.time) / this.length + 1) * this.length;
		return this.time -= Std.int(this.time / this.length) * this.length;
	}
	
	@:from inline static private function fromAnim(anim:Animation):HandAnimation return new HandAnimation(anim);
	
}
