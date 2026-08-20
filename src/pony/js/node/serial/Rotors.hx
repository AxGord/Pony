package pony.js.node.serial;

import haxe.io.BytesOutput;
import pony.Tumbler;
import pony.ds.ROArray;
import pony.events.Signal0;
import pony.time.DeltaTime;

enum abstract RotorMode(Int) to Int {
	var Off = 1;
	var Normal = 2;
	var Back = 3;
}

/**
 * Rotors
 * L298
 * @author AxGord <axgord@gmail.com>
 */
@:forward(push)
abstract Rotors(RotorsObj) {

	public inline function new(serial: SerialPort, count: Int) {
		this = new RotorsObj(serial, count);
	}

	@:arrayAccess
	public inline function get(key: Int): Rotor {
		return this.rotors[key];
	}

}

class RotorsObj {

	public var rotors(default, null): ROArray<Rotor>;

	private final serial: SerialPort;

	public function new(serial: SerialPort, count: Int) {
		this.serial = serial;
		rotors = [
			for (_ in 0...count) {
				final r: Rotor = new Rotor();
				r.onUpdate << updateHandler;
				r;
			}
		];
	}

	public function push(): Void {
		final bo: BytesOutput = new BytesOutput();
		for (r in rotors) r.writeState(bo);
		serial.write(bo);
	}

	private function updateHandler(): Void {
		DeltaTime.fixedUpdate < push;
	}

}

class Rotor extends Tumbler {

	public static inline final HALF: Int = 130;
	public static inline final MAX: Int = 255;

	@:bindable public var back: Bool = false;
	@:bindable public var max: Bool = false;
	@:auto public var onUpdate: Signal0;

	public function new() {
		super(false);
		(changeEnabled || changeBack || changeMax) << eUpdate;
	}

	public function writeState(bo: BytesOutput): Void {
		bo.writeByte( switch [enabled, back] {
			case [true, true]: Back;
			case [true, false]: Normal;
			case [false, _]: Off;
		});
		bo.writeByte(max ? MAX : HALF);
	}

	public function goBack(): Void back = true;

	public function goNormal(): Void back = false;

	public function reverse(): Void back = !back;

	public function goMax(): Void max = true;

	public function goHalf(): Void max = false;

}
