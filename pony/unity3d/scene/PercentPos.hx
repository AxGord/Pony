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
 * PercentPos
 * @author AxGord <axgord@gmail.com>
 */

class PercentPos extends MonoBehaviour implements IPercent {

	@:meta(UnityEngine.HideInInspector)
	public var percent(default, set):Float = 1;
	
	public var nullPos:Float;
	
	@:meta(UnityEngine.HideInInspector)
	private var initPos:Float;
	@:meta(UnityEngine.HideInInspector)
	private var size:Float;
	
	private function Start():Void {
		initPos = transform.localPosition.y;
		size = Math.abs(nullPos > initPos ? nullPos - initPos : initPos - nullPos);
	}
	
	public function set_percent(v:Float):Float {
		if (v > 1) v = 1;
		if (v < 0) v = 0;
		
		if (size == 0) {
			if (renderer != null) renderer.enabled = false;
			return v;
		}
		//if (v > 0 || renderer == null) {
			transform.localPosition = new Vector3(transform.localPosition.x, nullPos + size * v, transform.localPosition.z);
			if (renderer != null) renderer.enabled = true;
		//} else {
		//	renderer.enabled = false;
		//}
		return percent = v;
	}
}