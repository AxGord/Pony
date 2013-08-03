package pony.unity3d;

import unityengine.GameObject;
import unityengine.MonoBehaviour;
import unityengine.Quaternion;
import unityengine.Time;
import unityengine.Transform;
import unityengine.Vector3;

/**
 * Wards
 * @author AxGord <axgord@gmail.com>
 */

class WardsUCore extends MonoBehaviour 
{
	public var withRotation:Bool = true;
	public var withTimeScale:Bool = true;
	public var speed:Single = 200;
	public var currentPos:Int = 0;
	
	public var target:GameObject;
	private var wards:Array<Transform>;
	private var toN:Null<Int>;
	private var toObj:Transform;
	private var rn:Single = 0;
	
	public function Start():Void 
	{
		wards = [];
		for (i in 1...10000) {
			var t:Transform = transform.Find(Std.string(i));
			if (t == null) break;
			wards.push(t);
		}
	}
	
	public function goto(n:Int):Void {
		if (n == currentPos) return;
		toN = n;
		toObj = wards[n];
	}
	
	public function Update():Void 
	{
		if (toObj == null) return;
		var dt:Single = withTimeScale ? Time.deltaTime : Time.fixedDeltaTime;
		var p:Vector3 = toObj.position;
		var r:Quaternion = toObj.rotation;
		target.transform.position = Vector3_Static.MoveTowards(target.transform.position, p, speed*dt);
		if (withRotation)
			target.transform.rotation = Quaternion_Static.Slerp(target.transform.rotation, r, speed*(rn+=speed*2)*dt);
		if (target.transform.position == p) {
			currentPos = toN;
			toN = null;
			toObj = null;
			rn = 0;
		}
	}
	
}