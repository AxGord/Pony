package pony.unity3d.scene;
import pony.events.Signal;
import unityengine.MonoBehaviour;

/**
 * MouseHelper
 * @author AxGord <axgord@gmail.com>
 */
class MouseHelper extends MonoBehaviour {

	public var over:Signal;
	public var out:Signal;
	
	private var overed:Int = 0;
	
	public function new() {
		super();
		over = new Signal();
		out = new Signal();
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
	
}