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
package pony.unity3d.ui;

import pony.events.Signal;
import pony.ui.gui.SwitchableList;
import pony.ui.gui.ButtonCore;
import unityengine.MonoBehaviour;
using hugs.HUGSWrapper;

/**
 * Switcher
 * @author AxGord
 */
@:nativeGen class Switcher extends MonoBehaviour {
	
	public var select:Signal;
	public var core:SwitchableList;
	public var names:Array<String>;
	
	public function new() {
		super();
		select = new Signal();
	}
	
	private function Start():Void {
		var a:NativeArrayIterator<TintButton> = getComponentsInChildrenOfType(TintButton);
		names = [for (e in a) e.name];
		a.i = 0;
		core = new SwitchableList([for (e in a) e.core], 0, 1);
		core.change.add(sw);
	}
	
	private function sw(n:Int):Void select.dispatch(names[n]);
	
	public function set(name:String):Void {
		sw(Lambda.indexOf(names, name));
	}
	
}