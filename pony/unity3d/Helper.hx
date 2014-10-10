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