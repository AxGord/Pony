/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.ui.touch.lime;

import openfl.Lib;
import pony.ui.touch.Mouse;

/**
 * TouchSimulator
 * @author AxGord <axgord@gmail.com>
 */
class TouchSimulator {

	private static var id:Int = 1;
	
	public static function run() {
		Mouse.onLeftDown << down;
		Mouse.onLeftUp << up;
	}
	
	private static function down(x:Float, y:Float):Void {
		Mouse.onMove << move;
		@:privateAccess Touch.eStart.dispatch(new lime.ui.Touch(x/w(), y/h(), id, 0, 0, 1, 0));
	}
	
	private static function up(x:Float, y:Float):Void {
		Mouse.onMove >> move;
		@:privateAccess Touch.eEnd.dispatch(new lime.ui.Touch(x/w(), y/h(), id, 0, 0, 1, 0));
	}
	
	private static function move(x:Float, y:Float):Void {
		@:privateAccess Touch.eMove.dispatch(new lime.ui.Touch(x/w(), y/h(), id, 0, 0, 1, 0));
	}
	
	@:extern inline private static function w():Float return Lib.current.stage.stageWidth;
	@:extern inline private static function h():Float return Lib.current.stage.stageHeight;

	
}