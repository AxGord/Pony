package pony.unity3d.scene;

import unityengine.MonoBehaviour;
import unityengine.Quaternion;
import unityengine.Vector3;

/**
 * ShowTransformInfo
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class ShowTransformInfo extends MonoBehaviour {
	#if debug
	public var infoRotation:Quaternion;
	public var infoPosition:Vector3;
	
	public function Update():Void {
		infoRotation = transform.rotation;
		infoPosition = transform.position;
	}
	#end
}