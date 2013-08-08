package pony.unity3d.scene;

import pony.DeltaTime;
import pony.events.LV;
import pony.events.Signal;
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
	
	@:isVar public var overed(get,set):Bool;
	public var over:Signal;
	public var out:Signal;
	public var down:Signal;
	public var middleDown:Signal;
	public var middleUp:Signal;
	
	private var _overed:Int = 0;

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
		lock.add(updateOverState);
	}
	
	private function get_overed():Bool {
		for (e in gameObject.getComponentsInChildrenOfType(MouseHelper)) {
			if (e == this) continue;
			if (e.overed) return true;
		}
		return overed;
	}
	
	private function set_overed(v:Bool):Bool return overed = v;
	
	private function Start():Void {
		if (renderer != null && collider == null)
			gameObject.addTypedComponent(BoxCollider);
		
		for (e in gameObject.getComponentsInChildrenOfType(Transform)) {
			if (e == transform) continue;
			var ovr:MouseHelper = e.gameObject.getTypedComponent(MouseHelper);
			if (ovr == null)
				ovr = e.gameObject.addTypedComponent(MouseHelper);
			ovr.over.add(over.dispatchEvent);
			ovr.out.add(out.dispatchEvent);
			ovr.down.add(down.dispatchEvent);
			ovr.middleDown.add(middleDown.dispatchEvent);
			ovr.middleUp.add(middleUp.dispatchEvent);
		}
		init();
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
				overed = true;
				over.dispatch();
				globalMiddleDown.add(middleDown.dispatchEvent);
				globalMiddleUp.add(middleUp.dispatchEvent);
			}
		} else {
			if (overed) {
				overed = false;
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
}