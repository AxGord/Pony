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

import pony.events.Signal;
import pony.events.Signal1;
import pony.geom.IWards;
import unityengine.GameObject;
import unityengine.MonoBehaviour;
import unityengine.Quaternion;
import unityengine.Time;
import unityengine.Transform;
import unityengine.Vector3;

using hugs.HUGSWrapper;

/**
 * Wards
 * @author AxGord <axgord@gmail.com>
 * @author BoBaH6eToH <freezedunk@gmail.com>
 */

class Wards extends MonoBehaviour implements IWards<Wards>
{
	public var withRotation:Bool = true;
	public var withTimeScale:Bool = true;
	public var speed:Single = 200;
	public var currentPos:Int = -1;
	public var change(default, null):Signal1<Wards, Int>;
	public var changed(default, null):Signal;
	
	public var target:GameObject;
	private var wards:Array<Transform>;
	private var toN:Null<Int>;
	private var toObj:Transform;
	private var rn:Single = 0;
	
	public function new():Void {
		super();
		change = Signal.create(this);
		change.add(changeHandler);
		changed = new Signal(this);
	}
	
	public function Start():Void 
	{
		if (target == null) target = gameObject.getChildGameObject('obj');
		
		wards = [];
		for (i in 1...10000) {
			var t:Transform = transform.Find(Std.string(i));
			if (t == null) break;
			wards.push(t);
		}
		goto(0);
	}
	
	public function changeHandler(n:Int):Void {
		if (n == currentPos) return;
		currentPos = n;
		toN = n;
		toObj = wards[n];
	}
	
	inline public function goto(n:Int):Void change.dispatch(n);
	
	public function Update():Void 
	{
		if (toObj == null) return;
		var dt:Single = withTimeScale ? Time.deltaTime : Time.fixedDeltaTime;
		var p:Vector3 = toObj.position;
		var r:Quaternion = toObj.rotation;
		target.transform.position = Vector3.MoveTowards(target.transform.position, p, speed*dt);
		if (withRotation)
			target.transform.rotation = Quaternion.Slerp(target.transform.rotation, r, speed*(rn+=speed*2)*dt);
		if (target.transform.position == p) {
			//currentPos = toN;
			toN = null;
			toObj = null;
			rn = 0;
			changed.dispatch(currentPos);
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