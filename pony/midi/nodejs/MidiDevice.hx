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
package pony.midi.nodejs;
import js.Node;
import pony.midi.IMidiDevice;
import pony.events.*;
import pony.midi.MidiCode;
import pony.midi.MidiMessage;
import pony.time.DT;

/**
 * Midi
 * @author AxGord <axgord@gmail.com>
 */
class MidiDevice implements IMidiDevice {
	
	private static var midiInputClass:Class<Dynamic> = Node.require('midi').input;
	private static var midiOutputClass:Class<Dynamic> = Node.require('midi').output;
	
	private static var preCore:Dynamic = Type.createInstance(midiInputClass, []);
	
	private static var firstCreated:Bool = false;
	
	public static function list():Array<String> return [for (i in 0...preCore.getPortCount()) preCore.getPortName(i)];
	
	public static function listWithName(name:String):Map<Int,String> {
		var m = new Map<Int, String>();
		for (i in 0...preCore.getPortCount()) {
			var n:String = preCore.getPortName(i);
			if (n.indexOf(name) != -1) m[i] = n;
		}
		return m;
	}
	
	private var input:Dynamic;
	private var output:Dynamic;
	
	public var on:Signal2<IMidiDevice, MidiMessage, DT>;

	public function new(id:Int) {
		on = Signal.create(cast this);
		input = firstCreated ? Type.createInstance(midiInputClass, []) : preCore;
		output = Type.createInstance(midiOutputClass, []);
		var name = input.getPortName(id);
		trace('Open midi: '+name+'($id)');
		input.openPort(id);
		for (i in 0...output.getPortCount()) {
			if (name.indexOf(output.getPortName(i)) == 0) {
			output.openPort(i);
			break;
		}
		}
		input.on('message', function(deltaTime, message) {
			on.dispatch({chanel:message[0], key:message[1], value: message[2]}, deltaTime);
		});
	}
	
	inline public function send(m:MidiMessage):Void output.sendMessage([m.chanel,m.key,m.value]);
	
	public function destroy():Void {
		input.closePort();
		on.destroy();
		on = null;
		input = null;
	}
	
}