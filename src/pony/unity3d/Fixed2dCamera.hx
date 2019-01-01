package pony.unity3d;

import pony.time.DeltaTime;

/**
 * Fixed2dCamera
 * @author AxGord
 */
@:nativeGen class Fixed2dCamera {
	
	public static var begin:Single = 0;
	public static var exists:Bool = false;
	
	/**
	 * Warning! [visible = false; => true;]
	 */
	public static var visible(default, set):Bool = true;
	
	public static var SIZE:Int = 0;
	
	public static var obj:Fixed2dCameraU;
	
	private static function set_visible(v:Bool):Bool {
		if (obj == null)
			DeltaTime.update.once(set_visible.bind(v));
		else if (v != visible) {
			obj.size = v ? SIZE : 0;
			visible = v;
		}
		return true;
	}
}