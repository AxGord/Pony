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
import pony.events.LV;
import pony.events.Signal;
import pony.unity3d.ui.LoadScreen;
import unityengine.BoxCollider;
import unityengine.Input;
import unityengine.MonoBehaviour;
import unityengine.Transform;

using hugs.HUGSWrapper;
/**
 * MouseHelper
 * @author AxGord <axgord@gmail.com>
 * @author BoBaH6eToH
 */
class MouseHelper extends MonoBehaviour {

	public static var globalMiddleDown:Signal = new Signal();
	public static var globalMiddleUp:Signal = new Signal();
	public static var lock:LV<Int> = new LV(0);
	public static var middleMousePressed:Bool = false;
	private static var inited:Bool = false;
	
	@:isVar public var overed(get,never):Bool;
	public var over:Signal;
	public var out:Signal;
	public var down:Signal;
	public var middleDown:Signal;
	public var middleUp:Signal;
	
	private var _overed:Int = 0;
	private var ovr:MouseHelper;
	private var ovrs:Int = 0;
	
	public var sub:Bool = false;
	
	public static function updateStatic():Void
	{
		if (Input.GetMouseButton(2))
		{			
			if (!middleMousePressed) {
				middleMousePressed = true;
				globalMiddleDown.dispatch();
			}
		}
		else if (middleMousePressed) 
		{
			globalMiddleUp.dispatch();
			middleMousePressed = false;			
		}
	}
	
	public static function init():Void
	{
		if ( inited ) return;
		inited = true;
		DeltaTime.update.add(updateStatic);//todo: add if have listener
	}
	
	
	private function new() {
		super();
		over = new Signal();
		out = new Signal();
		down = new Signal();
		middleDown = new Signal();
		middleUp = new Signal();
		lock.add(resetOvrs);
		lock.add(updateOverState);
	}
	
	public function Start():Void {
		init();
		if (LoadScreen.lastLoader != null && !sub)
			LoadScreen.lastLoader.addAction(ft);
		else
			ft();
	}
	
	public function ft():Void {
		if (renderer != null && collider == null)
			gameObject.addTypedComponent(BoxCollider);
		
		for (e in gameObject.getComponentsInChildrenOfType(Transform)) {
			if (e == transform) continue;
			ovr = e.gameObject.getTypedComponent(MouseHelper);
			if (ovr == null) {
				ovr = e.gameObject.addTypedComponent(MouseHelper);
				ovr.sub = true;
			}
			ovr.over.add(subOver);
			ovr.out.add(subOut);
			ovr.down.add(down.dispatchEvent);
			ovr.middleDown.add(middleDown.dispatchEvent);
			ovr.middleUp.add(middleUp.dispatchEvent);
		}
		
	}
	
	private function resetOvrs():Void {
		if (overed) out.dispatch();
		ovrs = 0;
		_overed = 0;
	}
	
	private function subOver():Void {
		if (!overed)
			over.dispatch();
		ovrs++;
	}
	
	private function subOut():Void {
		ovrs--;
		if (!overed)
			out.dispatch();
	}
	
	private function Update():Void {
		if (lock.value > 0) return;
		if (_overed == 0) return;
		_overed--;
		if (_overed == 0) updateOverState();
	}
	
	private function OnMouseOver():Void {
		if (lock.value > 0) return;
		if (_overed == 2) return;
		_overed = 2;
		updateOverState();
	}
	
	private function updateOverState():Void {
		if (_overed == 2 && lock.value == 0) {
			if (!overed) {
				ovrs++;
				over.dispatch();
				globalMiddleDown.add(middleDown.dispatchEvent);
				globalMiddleUp.add(middleUp.dispatchEvent);
			}
		} else {
			if (overed) {
				ovrs--;
				out.dispatch();
				globalMiddleDown.remove(middleDown.dispatchEvent);
				globalMiddleUp.remove(middleUp.dispatchEvent);
			}
		}
	}
	
	private function OnMouseDown():Void {
		if (overed)
			down.dispatch();
	}
	
	private function get_overed():Bool return ovrs > 0;
}