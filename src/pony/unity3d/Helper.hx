package pony.unity3d;

import haxe.Log;
import haxe.PosInfos;
import pony.time.DeltaTime;
import unityengine.MonoBehaviour;
#if touchscript
import touchscript.gestures.PressGesture;
import touchscript.gestures.ReleaseGesture;
import unityengine.Input;
#end

using hugs.HUGSWrapper;

/**
 * DeltaTimeHelper
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class Helper extends MonoBehaviour {

	public static var main: MonoBehaviour;

	#if touchscript
	public static var touchDown: Bool;
	public static var doubleDown: Bool;
	public static var touchDX: Float = 0;
	public static var touchDY: Float = 0;

	private static var prevX: Float = 0;
	private static var prevY: Float = 0;
	#end

	public function new() {
		super();
		main = this;
		// Log.trace = log;
	}

	private function Start(): Void {
		#if touchscript
		getTypedComponent(PressGesture).add_Pressed(down);
		getTypedComponent(ReleaseGesture).add_Released(up);
		#end
	}

	/*
	private function log(v:Dynamic, ?pos:PosInfos):Void {

		var s = '<color=#FFF>$v</color> <color=#999>(at ' + pos.fileName + ':' + pos.lineNumber + ')</color>';
		untyped __cs__("UnityEngine.Debug.Log(s)");
	}
	 */
	#if touchscript
	private function Update(): Void {
		touchDX = Input.mousePosition.x - prevX;
		touchDY = Input.mousePosition.y - prevY;
		prevX = Input.mousePosition.x;
		prevY = Input.mousePosition.y;
		DeltaTime.fixedDispatch();
	}
	#else
	private function Update(): Void DeltaTime.fixedDispatch();
	#end

	#if touchscript
	private static function down(_, _): Void {
		// trace('down');
		prevX = Input.mousePosition.x;
		prevY = Input.mousePosition.y;
		if (touchDown) doubleDown = true;
		touchDown = true;
	}

	private static function up(_, _): Void {
		// trace('up');
		doubleDown = false;
		touchDown = false;
	}
	#end

}
