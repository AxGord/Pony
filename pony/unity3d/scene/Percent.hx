/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.unity3d.scene;

import pony.time.DeltaTime;
import unityengine.MonoBehaviour;
import unityengine.Vector3;
using hugs.HUGSWrapper;

/**
 * ProcentUCore
 * @author AxGord <axgord@gmail.com>
 */

@:nativeGen class Percent extends MonoBehaviour {

	public var percent:Float = 1;
	public var vector:Vector3;
	
	public function new() {
		super();
		vector = new Vector3(1, 0, 0);
	}
	
	private function Start():Void {
		DeltaTime.update.add(if (vector.x != 0) updateX else if (vector.y != 0) updateY else updateZ);
		vector = new Vector3(transform.localScale.x, transform.localScale.y, transform.localScale.z);
	}
	
	private function updateX():Void transform.localScale = new Vector3(vector.x * percent, vector.y, vector.z);
	private function updateY():Void transform.localScale = new Vector3(vector.x, vector.y * percent, vector.z);
	private function updateZ():Void transform.localScale = new Vector3(vector.x, vector.y, vector.z * percent);
	
}