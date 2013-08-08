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
class MouseLocker extends MonoBehaviour {

	public var panel:Bool = false;
	private var prevState:Bool = false;
	
	private function Update() {
		var h = panel
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