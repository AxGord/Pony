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
package pony.unity3d.scene;

import pony.IPercent;
import unityengine.MonoBehaviour;
import unityengine.Vector3;
using hugs.HUGSWrapper;

/**
 * PercentSizeUCore
 * @author AxGord <axgord@gmail.com>
 */
class PercentSize extends MonoBehaviour implements IPercent {
	
	public var percent(default, set):Float = 1;
	public var zeroInCenter:Bool = true;
	public var d:Float = 2;
	
	private var initValue:Float;
	private var initPos:Float;
	
	private function Start():Void {
		initValue = transform.lossyScale.y;
		initPos = transform.localPosition.y;
	}
	
	public function set_percent(v:Float):Float {
		if (v > 0) {
			renderer.enabled = true;
			transform.localScale = new Vector3(transform.localScale.x, v * initValue, transform.localScale.z);
			if (zeroInCenter)
				transform.localPosition = new Vector3(transform.localPosition.x, initPos - ( v < 1 ? ((1 - v) * initValue) / d : 0), transform.localPosition.z);
		} else {
			renderer.enabled = false;
		}
		return percent = v;
	}
	
}