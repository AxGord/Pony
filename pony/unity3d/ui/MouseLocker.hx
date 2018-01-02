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
package pony.unity3d.ui;
import pony.unity3d.Fixed2dCamera;
import pony.unity3d.scene.MouseHelper;
import unityengine.Input;
import unityengine.MonoBehaviour;
import unityengine.Screen;
import unityengine.Vector3;

/**
 * MouseLocker
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class MouseLocker extends MonoBehaviour {

	public var panel:Bool = false;
	@:meta(UnityEngine.HideInInspector)
	private var prevState:Bool = false;
	
	private function Update() {
		var h = !panel
			? guiTexture.HitTest(new Vector3(Input.mousePosition.x - Fixed2dCamera.begin, Input.mousePosition.y))
			: guiTexture.HitTest(new Vector3(Input.mousePosition.x +(Screen.width - Fixed2dCamera.begin)/2, Input.mousePosition.y));
		if (prevState != h) {
			if (h) MouseHelper.lock.value++;
			else MouseHelper.lock.value--;
			prevState = h;
		}
	}
	
	private function OnDisable():Void {
		if (prevState) {
			prevState = false;
			MouseHelper.lock.value--;
		}
	}
	
}