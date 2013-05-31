package pony.flash.mconsole;

import flash.Lib;
import flash.events.MouseEvent;

using pony.flash.FLExtends;
/**
 * ...
 * @author AxGord
 */
class Initialization {

	public static var mprnt:ConsoleView;
	
	public static function init():Void {
		Console.start();
		Console.defaultPrinter.remove();
		Console.addPrinter(new FL_IDE_View());
		mprnt = new ConsoleView();
		Console.addPrinter(mprnt);
		mprnt.attach();
	}
	
	public static inline function rightClick():Void {
		Lib.current.stage.buildSignal(MouseEvent.RIGHT_MOUSE_DOWN).sw(Initialization.mprnt.show, Initialization.mprnt.hide);
	}
	
}