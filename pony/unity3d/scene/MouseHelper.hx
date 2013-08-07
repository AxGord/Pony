package pony.unity3d.scene;

import pony.events.Signal;
import unityengine.BoxCollider;
import unityengine.MonoBehaviour;
import unityengine.Transform;

using hugs.HUGSWrapper;
/**
 * MouseHelper
 * @author AxGord <axgord@gmail.com>
 */
class MouseHelper extends MonoBehaviour {

	public var over:Signal;
	public var out:Signal;
	public var down:Signal;
	
	private var overed:Int = 0;
	
	private function new() {
		super();
		over = new Signal();
		out = new Signal();
		down = new Signal();
	}
	
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
		}
	}
	
	private function Update():Void {
		if (overed == 0) return;
		overed--;
		if (overed == 0) {
			out.dispatch();
		}
	}
	
	private function OnMouseOver():Void {
		if (overed == 2) return;
		if (overed == 0) {
			over.dispatch();
		}
		overed = 2;
	}
	
	private function OnMouseDown():Void {
		down.dispatch();
	}
}