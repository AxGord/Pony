package pony.midi.nodejs;

import js.Node;
import pony.midi.IMidiDevice;
import pony.events.*;
import pony.magic.HasSignal;
import pony.midi.MidiMessage;
import pony.time.DT;

/**
 * Midi
 * @author AxGord <axgord@gmail.com>
 */
class MidiDevice implements IMidiDevice implements HasSignal {

	private static final midiInputClass: Class<Dynamic> = Node.require('midi').input;
	private static final midiOutputClass: Class<Dynamic> = Node.require('midi').output;
	private static final preCore: Dynamic = Type.createInstance(midiInputClass, []);

	private static var firstCreated: Bool = false;

	@:auto public var on: Signal2<MidiMessage, DT>;

	private final output: Dynamic;

	private var input: Dynamic;

	public function new(id: Int) {
		input = firstCreated ? Type.createInstance(midiInputClass, []) : preCore;
		firstCreated = true;
		output = Type.createInstance(midiOutputClass, []);
		final name = input.getPortName(id);
		trace('Open midi: $name($id)');
		input.openPort(id);
		for (i in 0...output.getPortCount()) {
			if (name.indexOf(output.getPortName(i)) == 0) {
				trace(output.getPortName(i));
				trace(name);
				output.openPort(i);
				break;
			}
		}
		input.on('message', function(deltaTime, message) {
			e.dispatch({ chanel: message[0], key: message[1], value: message[2] }, deltaTime);
		});
	}

	public inline function send(m: MidiMessage): Void output.sendMessage([m.chanel, m.key, m.value]);

	public function destroy(): Void {
		input.closePort();
		destroySignals();
		input = null;
	}

	public static inline function count(): Int return preCore.getPortCount();

	public static function list(): Array<String> return [for (i in 0...preCore.getPortCount()) preCore.getPortName(i)];

	public static function listWithName(name: String): Map<Int, String> {
		final m: Map<Int, String> = [];
		for (i in 0...preCore.getPortCount()) {
			final n: String = preCore.getPortName(i);
			if (n.indexOf(name) != -1) m[i] = n;
		}
		return m;
	}

	public static function countWithName(name: String): Int {
		var c: Int = 0;
		for (i in 0...preCore.getPortCount()) {
			final n: String = preCore.getPortName(i);
			if (n.indexOf(name) != -1) c++;
		}
		return c;
	}

}
