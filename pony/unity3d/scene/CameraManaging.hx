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

import unityengine.Time;

using hugs.HUGSWrapper;

/**
 * Camera
 * @author DIS
 */
@:nativeGen class CameraManaging extends unityengine.MonoBehaviour
{
	public var target:unityengine.Transform;
	
	private var distance:Float = 10.0;
	private var distanceX:Float = 0;

	private var xActualSpeed:Float = 0.0;
	private var yActualSpeed:Float = 0.0;
	
	private var xConstSpeed:Float = 250.0;
	private var yConstSpeed:Float = 125.0;
	
	private var xDempf:Float = 0.95;
	private var yDempf:Float = 0.95;

	private var yMinLimit:Int = -20;
	private var yMaxLimit:Int = 80;

	private var maxDist:Float = 200;
	private var minDist:Float = 30;
	private var zoomSpeed:Float = 5;
	
	private var keyZoomUp:unityengine.KeyCode = unityengine.KeyCode.KeypadPlus;
	private var keyZoomOut:unityengine.KeyCode = unityengine.KeyCode.KeypadMinus;
	
	private var keyTurnUp:unityengine.KeyCode = unityengine.KeyCode.UpArrow;
	private var keyTurnDown:unityengine.KeyCode = unityengine.KeyCode.DownArrow;
	private var keyTurnLeft:unityengine.KeyCode = unityengine.KeyCode.LeftArrow;
	private var keyTurnRight:unityengine.KeyCode = unityengine.KeyCode.RightArrow;
	
	private var isInverted:Bool;
	
	private var isInerted:Bool = false;
	
	private var liveUpdate:Bool = false;

	@:meta(UnityEngine.HideInInspector)
	private var x:Float = 0.0;
	@:meta(UnityEngine.HideInInspector)
	private var y:Float = 0.0;
	@:meta(UnityEngine.HideInInspector)
	private var vector:unityengine.Vector3;
	
	private function clampAngle(angle:Float, min:Float, max:Float)
	{
		if (angle < -360) angle -= 360;
		if (angle > 360) angle += 360;
		return unityengine.Mathf.Clamp(angle, min, max);
	}	
	
	
	private function Start():Void 
	{
		var angles:unityengine.Vector3 = this.transform.eulerAngles;
		x = angles.y;
		y = angles.x;
		/*
		if (target.rigidbody != null && target.rigidbody.active) 
		{
			target.rigidbody.freezeRotation = true;
		}*/
	}
	
	private function LateUpdate():Void 
	{
		
		var changed:Bool = liveUpdate;
		#if touchscript
		
		if (target.active && Helper.touchDown && !Helper.doubleDown)
		{
			x += Helper.touchDX * xSpeed * 0.001;
			y -= Helper.touchDY * ySpeed * 0.001;
			changed = true;
		}
		#else
		
		if (target.gameObject.active && unityengine.Input.GetMouseButton(1))
		{
			xActualSpeed = unityengine.Input.GetAxis("Mouse X") * xConstSpeed;
			yActualSpeed = -unityengine.Input.GetAxis("Mouse Y") * yConstSpeed;
			x += xActualSpeed * 0.02;
			y += yActualSpeed * 0.02;
			changed = true;
		}
		
		#end

		var dt:Float = Time.timeScale == 0 ? 0 : Time.deltaTime / Time.timeScale;
		
		if (unityengine.Input.GetKey(keyTurnUp)) 
		{
			yActualSpeed = (1 - yDempf) * yConstSpeed + yDempf * yActualSpeed;
			y += yActualSpeed * dt / 2;
			changed = true;
		}
		else if ((yActualSpeed > 0) && (!unityengine.Input.GetMouseButton(1)))
		{
			yActualSpeed *= yDempf;
			if (Math.abs(yActualSpeed) < 0.001) yActualSpeed = 0;
			y += yActualSpeed * dt / 2;
			changed = true;
		}
		
		if (unityengine.Input.GetKey(keyTurnDown)) 
		{
			yActualSpeed = (yDempf - 1) * yConstSpeed + yDempf * yActualSpeed;
			y += yActualSpeed * dt / 2;
			changed = true;
		}
		else if ((yActualSpeed < 0) && (!unityengine.Input.GetMouseButton(1)))
		{
			yActualSpeed *= yDempf;
			if (Math.abs(yActualSpeed) < 0.001) yActualSpeed = 0;
			y += yActualSpeed * dt / 2;
			changed = true;
		}
		
		if (unityengine.Input.GetKey(keyTurnLeft)) 
		{
			xActualSpeed = (1 - xDempf) * xConstSpeed + xDempf * xActualSpeed;
			x += xActualSpeed * dt / 2;
			changed = true;
		}
		else if ((xActualSpeed > 0) && (!unityengine.Input.GetMouseButton(1)))
		{
			xActualSpeed *= xDempf;
			if (Math.abs(xActualSpeed) < 0.001) xActualSpeed = 0;
			x += xActualSpeed * dt / 2;
			changed = true;
		}
		
		if (unityengine.Input.GetKey(keyTurnRight)) 
		{
			xActualSpeed = (xDempf - 1) * xConstSpeed + xDempf * xActualSpeed;
			x += xActualSpeed * dt / 2;
			changed = true;
		}
		else if ((xActualSpeed < 0) && (!unityengine.Input.GetMouseButton(1)))
		{
			xActualSpeed *= xDempf;
			if (Math.abs(xActualSpeed) < 0.001) xActualSpeed = 0;
			x += xActualSpeed * dt / 2;
			changed = true;
		}
		
		if (changed) {
			y = clampAngle(y, yMinLimit, yMaxLimit);
			vector.Set(0.0, 0.0, -distance);
			transform.rotation = unityengine.Quaternion.Euler(y, x, 0);
			transform.position = transform.rotation.mulVector3(vector).add(target.position);
		}
		#if touchscript

			if (Helper.doubleDown)
			{
				var m = Helper.touchDY * 0.01 * zoomSpeed;
				if (distance+m >= maxDist) {
					m = maxDist - distance;
					distance = maxDist;
				} else if (distance+m <= minDist) {
					m = minDist - distance;
					distance = minDist;
				} else
					distance += m;

				transform.Translate(unityengine.Vector3.forward.mul(m)); 
			}
			
		#else
		if (!isInverted) {
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") < 0 && distance < maxDist) 
			{
				distance += zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed));
			}
		
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") > 0 && distance > minDist)
			{
				distance -= zoomSpeed;                             
				transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed) ); 
			}
		}
		else {
			
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") < 0 && distance > minDist) 
			{
				distance -= zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed));
			}
		
			if (unityengine.Input.GetAxis("Mouse ScrollWheel") > 0 && distance < maxDist)
			{
				distance += zoomSpeed;                             
				transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed) ); 
			}
		}
		
		#end
		if (unityengine.Input.GetKey(keyZoomOut) && distance < maxDist) 
		{
			var zs = zoomSpeed * dt * 10;
			distance += zs;
			transform.Translate(unityengine.Vector3.forward.mul(-zs));
		}
		
		if (unityengine.Input.GetKey(keyZoomUp) && distance > minDist) 
		{
			var zs = zoomSpeed * dt * 10;
			distance -= zs;
			transform.Translate(unityengine.Vector3.forward.mul(zs));
		}
		
	}

	
}