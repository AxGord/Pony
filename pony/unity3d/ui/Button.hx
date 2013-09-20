/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d.ui;

import pony.DeltaTime;
import pony.ui.ButtonCore;
import pony.unity3d.Tooltip;
import unityengine.Input;
import unityengine.MonoBehaviour;
import unityengine.Screen;
import unityengine.Vector3;
import pony.unity3d.Fixed2dCamera;

/**
 * Simple Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */

class Button extends MonoBehaviour {
	
	public var defaultMode:Int = 0;
	public var panel:Bool = true;
	public var tooltip:String = '';
	private var autoSwith:Bool = false;
	
	public var core:ButtonCore;
	private var prevState:Bool = false;
	
	public function new() {
		super();
		core = new ButtonCore();
	}
	
	function Start() {
		core.mode = defaultMode;
		if (autoSwith) {
			core.click.add(sw);
		}
		if (tooltip != '') {
			core.change.sub([ButtonStates.Focus]).add(over);
			core.change.sub([ButtonStates.Default]).add(out);
			core.change.sub([ButtonStates.Press]).add(out);
			core.change.sub([ButtonStates.Leave]).add(out);
			
		}
	}
	
	private function out():Void {
		Tooltip.hideText(this);
	}
	
	private function over():Void {
		Tooltip.showText(tooltip, "", this, gameObject.layer, true);
	}
	
	private function sw(mode:Int):Void {
		core.mode = mode == 0 ? 2 : (mode == 2 ? 0 : mode);
	}
	
	function Update() {
		var h = panel || !Fixed2dCamera.exists
			? guiTexture.HitTest(new Vector3(Input.mousePosition.x - Fixed2dCamera.begin, Input.mousePosition.y))
			: guiTexture.HitTest(new Vector3(Input.mousePosition.x +(Screen.width - Fixed2dCamera.begin)/2, Input.mousePosition.y));
		var down = Input.GetMouseButton(0);
		if (prevState != h) {
			if (h) core.mouseOver(down);
			else core.mouseOut();
			prevState = h;
		}
		if (down) core.mouseDown();
		else core.mouseUp();
	}
	
}