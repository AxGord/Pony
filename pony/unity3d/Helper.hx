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
	
	static public var main:MonoBehaviour;
	#if touchscript
	static public var touchDown:Bool;
	static public var doubleDown:Bool;
	static public var touchDX:Float = 0;
	static public var touchDY:Float = 0;
	
	static private var prevX:Float = 0;
	static private var prevY:Float = 0;
	#end
	
	public function new() {
		super();
		main = this;
		//Log.trace = log;
	}
	
	private function Start():Void {
		#if touchscript
		
		getTypedComponent(PressGesture).add_Pressed(down);
		getTypedComponent(ReleaseGesture).add_Released(up);
		
		#end
	}
	
	#if touchscript
	static private function down(_, _):Void {
		//trace('down');
		prevX = Input.mousePosition.x;
		prevY = Input.mousePosition.y;
		if (touchDown) doubleDown = true;
		touchDown = true;
	}
	
	static private function up(_, _):Void {
		//trace('up');
		doubleDown = false;
		touchDown = false;
	}
	#end
	/*
	private function log(v:Dynamic, ?pos:PosInfos):Void {
		
		var s = '<color=#FFF>$v</color> <color=#999>(at ' + pos.fileName + ':' + pos.lineNumber + ')</color>';
		untyped __cs__("UnityEngine.Debug.Log(s)");
	}
	*/
	#if touchscript
	private function Update():Void {
		touchDX = Input.mousePosition.x - prevX;
		touchDY = Input.mousePosition.y - prevY;
		prevX = Input.mousePosition.x;
		prevY = Input.mousePosition.y;
		DeltaTime.fixedDispatch();
	}
	#else
	private function Update():Void DeltaTime.fixedDispatch();
	#end
}