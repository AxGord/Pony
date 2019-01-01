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