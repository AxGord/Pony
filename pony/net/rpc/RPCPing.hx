/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.rpc;

import pony.events.Signal0;
import pony.time.Timer;

/**
 * RPCLog
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCPing extends pony.net.rpc.RPCUnit<RPCPing> implements pony.net.rpc.IRPC {

	private static inline var REPEAR:Int = 10000;

	@:auto public var onWarning:Signal0;
	@:auto public var onRestore:Signal0;
	@:auto public var onLostConnection:Signal0;

	@:rpc public var onPing:Signal0;
	@:rpc public var onPong:Signal0;

	public function new() {
		super();
		onPing << pongRemote;
	}

	public function watch(repeatTime:Int = REPEAR):Void -> Void return new Watch(this, repeatTime).activity; 

}

private class Watch {

	private var rpc:RPCPing;
	private var silent:Bool = false;
	private var ping:Bool = true;
	private var timer:Timer;

	public function new(rpc:RPCPing, repeatTime:Int) {
		this.rpc = rpc;
		rpc.onPing << activity;
		rpc.onPong << activity;
		timer = Timer.repeat(repeatTime, repeatHandler);
	}

	private function repeatHandler():Void {
		if (silent) {
			if (ping) {
				ping = false;
				@:privateAccess rpc.eWarning.dispatch();
				rpc.pingRemote();
			} else {
				@:privateAccess rpc.eLostConnection.dispatch();
			}
		} else {
			silent = true;
		}
	}

	public function activity():Void {
		timer.reset();
		if (silent && !ping) @:privateAccess rpc.eRestore.dispatch();
		silent = false;
	}

}