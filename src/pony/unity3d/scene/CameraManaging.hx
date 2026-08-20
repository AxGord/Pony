package pony.unity3d.scene;

import unityengine.Time;

using hugs.HUGSWrapper;

/**
 * CameraManaging
 * @author DIS
 */
@:nativeGen class CameraManaging extends unityengine.MonoBehaviour {

	public var target: unityengine.Transform;

	private var distance: Float = 10.0;

	private static inline final distanceX: Float = 0;

	private var xActualSpeed: Float = 0.0;
	private var yActualSpeed: Float = 0.0;

	private static inline final xConstSpeed: Float = 250.0;
	private static inline final yConstSpeed: Float = 125.0;

	private static inline final xDempf: Float = 0.95;
	private static inline final yDempf: Float = 0.95;

	private static inline final yMinLimit: Int = -20;
	private static inline final yMaxLimit: Int = 80;

	private static inline final maxDist: Float = 200;
	private static inline final minDist: Float = 30;
	private static inline final zoomSpeed: Float = 5;

	private final keyZoomUp: unityengine.KeyCode = unityengine.KeyCode.KeypadPlus;
	private final keyZoomOut: unityengine.KeyCode = unityengine.KeyCode.KeypadMinus;

	private final keyTurnUp: unityengine.KeyCode = unityengine.KeyCode.UpArrow;
	private final keyTurnDown: unityengine.KeyCode = unityengine.KeyCode.DownArrow;
	private final keyTurnLeft: unityengine.KeyCode = unityengine.KeyCode.LeftArrow;
	private final keyTurnRight: unityengine.KeyCode = unityengine.KeyCode.RightArrow;

	private var isInverted: Bool;

	private static inline final isInerted: Bool = false;

	private static inline final liveUpdate: Bool = false;

	@:meta(UnityEngine.HideInInspector)
	private var x: Float = 0.0;
	@:meta(UnityEngine.HideInInspector)
	private var y: Float = 0.0;
	@:meta(UnityEngine.HideInInspector)
	private var vector: unityengine.Vector3;

	private function clampAngle(angle: Float, min: Float, max: Float) {
		if (angle < -360) angle -= 360;
		if (angle > 360) angle += 360;
		return unityengine.Mathf.Clamp(angle, min, max);
	}


	private function Start(): Void {
		final angles: unityengine.Vector3 = this.transform.eulerAngles;
		x = angles.y;
		y = angles.x;
		// if (target.rigidbody != null && target.rigidbody.active)
		// {
		// 	target.rigidbody.freezeRotation = true;
		// }
	}

	private function LateUpdate(): Void {

		var changed: Bool = liveUpdate;
		#if touchscript
		if (target.active && Helper.touchDown && !Helper.doubleDown) {
			x += Helper.touchDX * xSpeed * 0.001;
			y -= Helper.touchDY * ySpeed * 0.001;
			changed = true;
		}
		#else
		if (target.gameObject.active && unityengine.Input.GetMouseButton(1)) {
			xActualSpeed = unityengine.Input.GetAxis('Mouse X') * xConstSpeed;
			yActualSpeed = -unityengine.Input.GetAxis('Mouse Y') * yConstSpeed;
			x += xActualSpeed * 0.02;
			y += yActualSpeed * 0.02;
			changed = true;
		}
		#end

		final dt: Float = Time.timeScale == 0 ? 0 : Time.deltaTime / Time.timeScale;

		if (unityengine.Input.GetKey(keyTurnUp)) {
			yActualSpeed = (1 - yDempf) * yConstSpeed + yDempf * yActualSpeed;
			y += yActualSpeed * dt / 2;
			changed = true;
		} else if ((yActualSpeed > 0) && (!unityengine.Input.GetMouseButton(1))) {
			yActualSpeed *= yDempf;
			if (Math.abs(yActualSpeed) < 0.001) yActualSpeed = 0;
			y += yActualSpeed * dt / 2;
			changed = true;
		}

		if (unityengine.Input.GetKey(keyTurnDown)) {
			yActualSpeed = (yDempf - 1) * yConstSpeed + yDempf * yActualSpeed;
			y += yActualSpeed * dt / 2;
			changed = true;
		} else if ((yActualSpeed < 0) && (!unityengine.Input.GetMouseButton(1))) {
			yActualSpeed *= yDempf;
			if (Math.abs(yActualSpeed) < 0.001) yActualSpeed = 0;
			y += yActualSpeed * dt / 2;
			changed = true;
		}

		if (unityengine.Input.GetKey(keyTurnLeft)) {
			xActualSpeed = (1 - xDempf) * xConstSpeed + xDempf * xActualSpeed;
			x += xActualSpeed * dt / 2;
			changed = true;
		} else if ((xActualSpeed > 0) && (!unityengine.Input.GetMouseButton(1))) {
			xActualSpeed *= xDempf;
			if (Math.abs(xActualSpeed) < 0.001) xActualSpeed = 0;
			x += xActualSpeed * dt / 2;
			changed = true;
		}

		if (unityengine.Input.GetKey(keyTurnRight)) {
			xActualSpeed = (xDempf - 1) * xConstSpeed + xDempf * xActualSpeed;
			x += xActualSpeed * dt / 2;
			changed = true;
		} else if ((xActualSpeed < 0) && (!unityengine.Input.GetMouseButton(1))) {
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
		if (Helper.doubleDown) {
			var m = Helper.touchDY * 0.01 * zoomSpeed;
			if (distance + m >= maxDist) {
				m = maxDist - distance;
				distance = maxDist;
			} else if (distance + m <= minDist) {
				m = minDist - distance;
				distance = minDist;
			} else
				distance += m;

			transform.Translate(unityengine.Vector3.forward.mul(m));
		}
		#else
		if (isInverted) {

			if (unityengine.Input.GetAxis('Mouse ScrollWheel') < 0 && distance > minDist) {
				distance -= zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed));
			}

			if (unityengine.Input.GetAxis('Mouse ScrollWheel') > 0 && distance < maxDist) {
				distance += zoomSpeed;
				transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed));
			}
		} else {
			if (unityengine.Input.GetAxis('Mouse ScrollWheel') < 0 && distance < maxDist) {
				distance += zoomSpeed;
				this.transform.Translate(unityengine.Vector3.forward.mul(-zoomSpeed));
			}

			if (unityengine.Input.GetAxis('Mouse ScrollWheel') > 0 && distance > minDist) {
				distance -= zoomSpeed;
				transform.Translate(unityengine.Vector3.forward.mul(zoomSpeed));
			}
		}
		#end
		if (unityengine.Input.GetKey(keyZoomOut) && distance < maxDist) {
			final zs = zoomSpeed * dt * 10;
			distance += zs;
			transform.Translate(unityengine.Vector3.forward.mul(-zs));
		}

		if (unityengine.Input.GetKey(keyZoomUp) && distance > minDist) {
			final zs = zoomSpeed * dt * 10;
			distance -= zs;
			transform.Translate(unityengine.Vector3.forward.mul(zs));
		}

	}

}
