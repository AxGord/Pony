package pony.midi.devices;

import pony.events.Signal1;
import pony.events.Signal2;
import pony.geom.Point.IntPoint;
import pony.Logable;
import pony.math.Matrix;
import pony.midi.MidiCode;
import pony.midi.MidiDevice;
import pony.midi.devices.LaunchpadColor;
import pony.midi.MidiMessage;

/**
 * Launchpad
 * @author AxGord
 */
class Launchpad extends Logable implements ILaunchpad {

	private static var area(default, never):Matrix<MidiCode> = [
		[for (i in 0...8) i],
		[for (i in 16...24) i],
		[for (i in 32...40) i],
		[for (i in 48...56) i],
		[for (i in 64...72) i],
		[for (i in 80...88) i],
		[for (i in 96...104) i],
		[for (i in 112...120) i]
	];

	private static var rightBlock(default, never):Array<MidiCode> = [8, 24, 40, 56, 72, 88, 104, 120];

	private static var topBlock(default, never):Array<MidiCode> = [for (i in 104...112) i];

	inline public static function list():Map<Int, String> return MidiDevice.listWithName('Launchpad');

	inline public static function count():Int return MidiDevice.countWithName('Launchpad');

	private var midi:MidiDevice;
	public var areaState(default, null):Matrix<LaunchpadColor>;
	public var topState(default, null):Array<LaunchpadColor>;
	public var rightState(default, null):Array<LaunchpadColor>;

	@:auto public var onArea:Signal2<IntPoint, Bool>;
	@:auto public var onTop:Signal2<Int, Bool>;
	@:auto public var onRight:Signal2<Int, Bool>;

	public function new(id:Int = 0) {
		super();
		var i:Int = 0;
		for (k in list().keys()) {
			if (id == i) {
				midi = new MidiDevice(k);
				break;
			}
			i++;
		}
		if (id != i) throw 'Wrong id';
		if (midi == null) throw 'Launchpad not found';
		reset();
		midi.on << midiHandler;
	}

	private function midiHandler(m:MidiMessage):Void {
		switch m.chanel {
			case 144:
				var i = rightBlock.indexOf(m.key);
				if (i != -1)
					eRight.dispatch(i, m.value == 127);
				else {
					var p = area.indexOf(m.key);
					if (p == null) return error('Unknown button');
					eArea.dispatch(p, m.value == 127);
				}
			case 176:
				var i = topBlock.indexOf(m.key);
				if (i == -1) return error('Unknown button');
				eTop.dispatch(i, m.value == 127);
			case _: return error('Unknown button');
		}
	}

	inline public function setAreaPoint(p:IntPoint, color:LaunchpadColor = AmberFull):Void {
		if (areaState.get(p) != color) {
			midi.send( { chanel: 144, key: area.get(p), value: color } );
			areaState.set(p, color);
		}
	}

	inline public function setMatrixCI(m:Matrix<Int>):Void setMatrix(m.map(LaunchpadColor.fromIndex));

	public function setMatrix(m:Matrix<LaunchpadColor>):Void {
		m = m.cut(8, 8);
		for (y in 0...m.length) for (x in 0...m[y].length) setAreaPoint(new IntPoint(x, y), m[y][x]);
	}

	public function setTop(p:Int, color:LaunchpadColor = AmberFull):Void {
		if (topState[p] != color) {
			midi.send( { chanel: 176, key: topBlock[p], value: color } );
			topState[p] = color;
		}
	}

	public function setRight(p:Int, color:LaunchpadColor = AmberFull):Void {
		if (rightState[p] != color) {
			midi.send( { chanel: 144, key: rightBlock[p], value: color } );
			rightState[p] = color;
		}
	}

	public function reset():Void {
		midi.send( { chanel: 176, key: 0, value: 0 } );
		areaState = [for (_ in 0...8) [for (_ in 0...8) Off] ];
		topState = [for (_ in 0...8) Off];
		rightState = [for (_ in 0...8) Off];
	}

	public static function createAll():Array<Launchpad> return [for (i in 0...count()) new Launchpad(i)];

}