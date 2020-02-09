package pony.flash.mconsole;

import flash.events.KeyboardEvent;
import flash.Lib;
import flash.events.MouseEvent;
import flash.system.Capabilities;

using pony.flash.FLExtends;

/**
 * Initialization
 * @author AxGord
 */
class Initialization {

	public static var mprnt: ConsoleView;

	public static function init(): Void {
		Console.start();
		try {
			Console.defaultPrinter.remove();
		} catch (_:Dynamic) {}
		Console.addPrinter(new FL_IDE_View());
		mprnt = new ConsoleView();
		Console.addPrinter(mprnt);
		mprnt.attach();
	}

	public static inline function rightClick(): Void {
		if (MouseEvent.RIGHT_MOUSE_DOWN != null)
			Lib.current.stage.buildSignal(MouseEvent.RIGHT_MOUSE_DOWN).sw(Initialization.mprnt.show, Initialization.mprnt.hide);
		else
			Console.warn('Rigth click not support in ' + Capabilities.version);
	}

	public static inline function anyKey(): Void {
		Lib.current.stage.buildSignal(KeyboardEvent.KEY_DOWN).sw(Initialization.mprnt.show, Initialization.mprnt.hide);
	}

}