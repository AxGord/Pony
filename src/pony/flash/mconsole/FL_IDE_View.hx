package pony.flash.mconsole;

import haxe.PosInfos;
import mconsole.Printer;

/**
 * FL_IDE_View
 * @author AxGord
 */
class FL_IDE_View extends PrinterBase implements Printer {

	override function printLine(color: ConsoleColor, line: String, pos: PosInfos): Void {
		untyped __global__['trace'](line);
	}

}