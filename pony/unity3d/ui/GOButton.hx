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
package pony.unity3d.ui;

import cs.NativeArray.NativeArray;
import pony.events.Event;
import pony.unity3d.ui.TextureButton;
import pony.ui.gui.ButtonCore;
import unityengine.GameObject;

/**
 * GOButton
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class GOButton extends TextureButton {

	private var goDefs:NativeArray<GameObject>;
	private var goOvers:NativeArray<GameObject>;
	private var goPress:NativeArray<GameObject>;
	
	private var glast:GameObject;
	
	override function Start():Void {
		
		core.changeVisual.add(goRestore);
		
		for (i in 0...goOvers.Length) if (goOvers[i] != null) {
			goOvers[i].active = false;
			core.changeVisual.sub(Focus, i).add(goset.bind(goOvers[i]));
			core.changeVisual.sub(Leave, i).add(goset.bind(goOvers[i]));
		}
		
		for (i in 0...goPress.Length) if (goPress[i] != null) {
			goPress[i].active = false;
			core.changeVisual.sub(Press, i).add(goset.bind(goPress[i]));
		}
		
		for (i in 0...goDefs.Length) if (goDefs[i] != null) {
			goDefs[i].active = false;
			core.changeVisual.sub(Default, i).add(goset.bind(goDefs[i]));
		}
		
		super.Start();
	}
	
	private function goset(g:GameObject, e:Event):Void {
		restoreColor();
		guiTexture.enabled = false;
		g.active = true;
		glast = g;
		e.stopPropagation();
	}
	
	private function goRestore():Void {
		guiTexture.enabled = true;
		if (glast != null) glast.active = false;
	}
	
}