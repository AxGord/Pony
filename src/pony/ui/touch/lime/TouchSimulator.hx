package pony.ui.touch.lime;

import openfl.Lib;
import pony.ui.touch.Mouse;

/**
 * Lime TouchSimulator
 * @author AxGord <axgord@gmail.com>
 */
class TouchSimulator {

	private static var id: Int = 1;

	public static function run(): Void {
		Mouse.onLeftDown << down;
		Mouse.onLeftUp << up;
	}

	private static function down(x: Float, y: Float): Void {
		Mouse.onMove << move;
		@:privateAccess Touch.eStart.dispatch(new lime.ui.Touch(x / w(), y / h(), id, 0, 0, 1, 0));
	}

	private static function up(x: Float, y: Float): Void {
		Mouse.onMove >> move;
		@:privateAccess Touch.eEnd.dispatch(new lime.ui.Touch(x / w(), y / h(), id, 0, 0, 1, 0));
	}

	private static function move(x: Float, y: Float): Void {
		@:privateAccess Touch.eMove.dispatch(new lime.ui.Touch(x / w(), y / h(), id, 0, 0, 1, 0));
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function w(): Float return Lib.current.stage.stageWidth;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function h(): Float return Lib.current.stage.stageHeight;

}