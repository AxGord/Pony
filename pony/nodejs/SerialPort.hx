/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.nodejs;

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import pony.events.*;
import pony.magic.Declarator;
import pony.time.Timer;

/**
 * SerialPort
 * @author AxGord <axgord@gmail.com>
 */
class SerialPort implements Declarator {

	public static var SerialPortClass:Class<Dynamic> = untyped require("serialport").SerialPort;
	
	public var open(default, null):Signal0<SerialPort> = Signal.create(this);
	public var close(default, null):Signal0<SerialPort> = Signal.create(this);
	public var data(default, null):Signal1<SerialPort, BytesInput> = Signal.create(this);
	public var error(default, null):Signal1<SerialPort, String> = Signal.create(this);
	
	private var sp:Dynamic;
	private var queue:List<BytesOutput> = new List();
	
	@:arg public var id:String;
	@:arg private var cfg:Dynamic;
	
	public function new() {
		error << reconnect;
		connect();
	}
	
	private function connect():Void {
		sp = Type.createInstance(SerialPortClass, [id, cfg, true, error.dispatch]);
		sp.on('error', function() trace(1));
		sp.on('open', open.dispatch);
		sp.on('error', error.dispatch);
		sp.on('close', sp.open.bind(close.dispatch));
		sp.on('data', readData);
	}
	
	private function reconnect():Void {
		try {
			sp.close(_reconnect);
		} catch (err:Dynamic) {
			_reconnect();
		}
	}
	
	private function _reconnect():Void {
		Log.trace('SerialPort $id have problem, reconnect after 5sec...');
		Timer.delay('5s', connect);
	}
	
	private function readData(b:BytesData):Void {
		data.dispatch(new BytesInput(Bytes.ofData(b)));
	}
	
	public function writeAsync(b:BytesOutput, ok:Void->Void, ?error:String->Void):Void {
		sp.write(b.getBytes().getData(), function(err:String, result:String) {
			if (err != null)
				sp.drain(function(err:Dynamic) {
					if (err != null) ok();
					else if (error != null) error(err);
				});
			else if (error != null) error(err);
		});
	}
	
	public function write(b:BytesOutput):Void {
		queue.add(b);
		sendNext();
	}
	
	public function sendNext():Void {
		if (queue.length > 0) writeAsync(queue.pop(), sendNext, error.dispatch);
	}
	
	
}