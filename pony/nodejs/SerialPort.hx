/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.nodejs;

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import js.Node.NodeBuffer;
import pony.events.*;
import pony.magic.Declarator;
import pony.nodejs.SerialPort.SerialPortConfig;
import pony.Queue;
import pony.time.Timer;

using Lambda;

typedef SerialPortConfig = {
	?baudRate:Int,
	?dataBits:Int,
	?stopBits:Int,
	?parity:String,
	?xon:Bool,
	?xoff:Bool,
	?xany:Bool,
	?flowControl:Bool,
	?bufferSize:Int,
};

private typedef SerialPortFullConfig = {
	?baudRate:Int,
	?dataBits:Int,
	?stopBits:Int,
	?parity:String,
	?xon:Bool,
	?xoff:Bool,
	?xany:Bool,
	?flowControl:Bool,
	?disconnectedCallback:Void->Void,
};

/**
 * SerialPort
 * @author AxGord <axgord@gmail.com>
 */
class SerialPort implements Declarator {

	public var serialpack:Dynamic = untyped require("serialport");
	
	public var connected(default, null):Bool;
	
	public var open(default, null):Signal0<SerialPort> = Signal.create(this);
	public var close(default, null):Signal0<SerialPort> = Signal.create(this);
	public var data(default, null):Signal1<SerialPort, BytesInput> = Signal.create(this);
	public var error(default, null):Signal1<SerialPort, String> = Signal.create(this);
	
	private var sp:Dynamic;
	
	private var q:Queue<BytesOutput->Void>;
	
	@:arg public var id:String;
	@:arg private var cfg:SerialPortConfig;
	
	public function new() {
		q = new Queue < BytesOutput->Void > (_write);
		error << reconnect;
		open << function() connected = true;
		connect();
	}
	
	private function connect():Void {
		try {
			serialpack.list(_connect);
		} catch (_:Dynamic) reconnect();
	}
	
	private function _connect(err:Dynamic,ports:Array<Dynamic>):Void {
		if (err != null) throw "Can't take com ports list";
		else {
			try {
				Log.trace(ports);
				if (ports.exists(function(e:Dynamic):Bool return e.comName == id)) {
					var fcfg:SerialPortFullConfig = cast cfg;
					fcfg.disconnectedCallback = reconnect;
					sp = Type.createInstance(serialpack.SerialPort, [id, fcfg, true]);// , reconnect]);
					sp.on('open', open.dispatch);
					sp.on('error', error.dispatch);
					sp.on('close', sp.open.bind(close.dispatch));
					sp.on('data', readData);
				} else {
					reconnect();
				}
			} catch (_:Dynamic) reconnect();
		}
	}
	
	private function reconnect():Void {
		connected = false;
		try {
			error.silent = true;
			sp.close(_reconnect);
		} catch (err:Dynamic) {
			_reconnect();
		}
		error.silent = false;
	}
	
	private function _reconnect():Void {
		Log.trace('SerialPort $id have problem, reconnect after 5sec...');
		Timer.delay('5s', connect);
	}
	
	private function readData(b:BytesData):Void {
		data.dispatch(new BytesInput(Bytes.ofData(b)));
	}
	
	private function check():Bool {
		if (connected) return false;
		else {
			error.dispatch('Serial port not ready');
			return true;
		}
	}
	
	public function writeAsync(b:BytesOutput, ok:Void->Void, ?error:String->Void):Void {
		if (check()) return;
		sp.write(b.getBytes().getData(), function(err:Dynamic, result:Int) {
			if (err == null && result > 0)
				sp.drain(function(err:Dynamic) {
					if (err == null) haxe.Timer.delay(ok, 12);//More delays! >:)
					else if (error != null) error(err);
				});
			else if (error != null) error(err);
		});
	}
	
	public function write(b:BytesOutput):Void {
		if (check()) return;
		q.call(b);
	}
	
	private function _write(b:BytesOutput):Void {
		writeAsync(b, q.next, error.dispatch);
	}
	
	
	
}