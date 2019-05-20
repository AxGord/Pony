package pony.nodejs;

import haxe.io.BytesOutput;
import pony.Tumbler;
import pony.time.DeltaTime;
import pony.events.Signal0;

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

	public inline function new(serial:SerialPort, count:Int) {
		this = new RotorsObj(serial, count);
	}

	@:arrayAccess
	public inline function get(key:Int):Rotor {
		return this.rotors[key];
	}

}

class RotorsObj {

	public var rotors(default, null):ImmutableArray<Rotor>;

	private var serial:SerialPort;

	public function new(serial:SerialPort, count:Int) {
		this.serial = serial;
		rotors = [for (_ in 0...count) {
			var r:Rotor = new Rotor();
			r.onUpdate << updateHandler;
			r;
		}];
	}

	private function updateHandler():Void {
		DeltaTime.fixedUpdate < push;
	}

	public function push():Void {
		var bo = new BytesOutput();
		for (r in rotors) r.writeState(bo);
		serial.write(bo);
	}

}

class Rotor extends Tumbler {

	public static inline var HALF:Int = 130;
	public static inline var MAX:Int = 255;

	@:auto public var onUpdate:Signal0;

	@:bindable public var back:Bool = false;
	@:bindable public var max:Bool = false;

	public function new() {
		super(false);
		(changeEnabled || changeBack || changeMax) << eUpdate;
	}

	public function writeState(bo:BytesOutput):Void {
		bo.writeByte(switch [enabled, back] {
			case [true, true]: Back;
			case [true, false]: Normal;
			case [false, _]: Off;
		});
		bo.writeByte(max ? MAX : HALF);
	}

	public function goBack():Void back = true;
	public function goNormal():Void back = false;
	public function goMax():Void max = true;
	public function goHalf():Void max = false;

}