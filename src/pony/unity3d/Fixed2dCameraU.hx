package pony.unity3d;

import unityengine.MonoBehaviour;
import unityengine.Camera;
import unityengine.Rect;
import unityengine.Screen;

/**
 * Fixed2dCameraU
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class Fixed2dCameraU extends MonoBehaviour {

	public var size:Int = 100;
	public var mainCamera:Camera;
	
	public function Start() {
		Fixed2dCamera.obj = this;
		Fixed2dCamera.SIZE = size;
		Fixed2dCamera.exists = true;
	}
	
	private function Update():Void {
		Fixed2dCamera.begin = Screen.width - size;
		mainCamera.pixelRect = new Rect(0, 0, Fixed2dCamera.begin, mainCamera.pixelRect.height);
		camera.pixelRect = new Rect(Fixed2dCamera.begin, 0, size, mainCamera.pixelRect.height);
	}
	
}