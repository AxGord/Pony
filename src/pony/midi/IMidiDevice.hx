package pony.midi;

import pony.events.Signal2;
import pony.time.DT;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface IMidiDevice {
	var on:Signal2<IMidiDevice, MidiMessage, DT>;
	function destroy():Void;
}