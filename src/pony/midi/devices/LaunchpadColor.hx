package pony.midi.devices;

/**
 * Launchpad colors
 * From Launchpad Programmer’s Reference
 * @author AxGord
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract LaunchpadColor(MidiCode) to MidiCode from MidiCode {

	var Off = 12;
	var RedLow = 13;
	var RedFull = 15;
	var AmberLow = 29;
	var AmberFull = 63;
	var YellowFull = 62;
	var GreenLow = 28;
	var GreenFull = 60;

	public static function fromIndex(index:Int):LaunchpadColor {
		return switch index {
			case 0: Off;
			case 1: RedLow;
			case 2: RedFull;
			case 3: AmberLow;
			case 4: AmberFull;
			case 5: YellowFull;
			case 6: GreenLow;
			case 7: GreenFull;
			case _: throw 'Unknown color index';
		}
	}

}
