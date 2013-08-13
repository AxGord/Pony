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
 * @author BoBaH6eToH <freezedunk@gmail.com>
 */

class WardsUCore extends MonoBehaviour 
{
	public var withRotation:Bool = true;
	public var withTimeScale:Bool = true;
	public var speed:Single = 200;
	public var currentPos:Int = -1;
	
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
		goto(0);
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
	
	public function goNext():Void 
	{
		if (currentPos < wards.length-1) 
			goto(currentPos + 1);
	}
	
	public function goPrev():Void
	{
		if (currentPos > 0) 
			goto(currentPos - 1);
	}
	
}