package pony.midi;

import pony.events.Signal2;
import pony.time.DT;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface IMidiDevice {
	var on(get, never):Signal2<MidiMessage, DT>;
	function destroy():Void;
}