/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net;

/**
 * IRPC - Remove Procedure Call Build System
 * -lib hxbit
 * use with IRPC
 * @author AxGord <axgord@gmail.com>
 */
class RPC<T:pony.net.IRPC> {

	public var socket:pony.net.INet;

	private var serializer:hxbit.Serializer;

	private var object(get, never):T;

	public function new(s:pony.net.INet) {
		socket = s;
		serializer = new hxbit.Serializer();
		s.onData << dataHandler;
	}

	private function dataHandler(b:haxe.io.BytesInput):Void {
		serializer.refs = new Map();
		untyped serializer.knownStructs = [];
		serializer.setInput(b.readAll(), 0);
		object.__uid = untyped serializer.getObjRef();
		object.unserializeInit();
		object.unserialize(serializer);
		object.checkRemoteCalls();
	}

	@:extern inline private function get_object():T return cast this;

	@:extern inline private function needSend():Void pony.time.DeltaTime.fixedUpdate < send;

	private function send():Void {
		var bo = new haxe.io.BytesOutput();
		bo.write(serializer.serialize(object));
		socket.send(bo);
	}

}