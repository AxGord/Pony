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
package pony.flash.workers ;

import flash.events.Event;
import flash.events.UncaughtErrorEvent;
import flash.Lib;
import flash.system.MessageChannel;
import flash.system.MessageChannelState;
import flash.system.Worker;
import haxe.Log;
import haxe.PosInfos;
import pony.magic.HasAbstract;
import pony.time.DeltaTime;

/**
 * WorkerUnit
 * @author AxGord <axgord@gmail.com>
 */
class WorkerUnit implements HasAbstract implements IWorkerGatePool {
	
	private var _log:WorkerOutput<String, Void>;
	
	public function new() {
		_log = new WorkerOutput('log', this);
		Log.trace = log;
		
		//Lib.current.stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleGlobalErrors);
	}
	/*
	private function handleGlobalErrors( evt : UncaughtErrorEvent ):Void
	{
		evt.preventDefault();
		_log.request('error!');
	}
*/
	
	private function log(s:String, ?p:PosInfos):Void _log.request((p != null ? p.fileName + ':' + p.lineNumber + ': ' : '') + s);
	
	public function _registerOutput<T1, T2>(name:String, response:T2->Void, unlock:Void->Void):T1->Void {
		var commandChannel:MessageChannel = Worker.current.getSharedProperty("response2_"+name);
		commandChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event:Event):Void {
			while (commandChannel.messageAvailable) {
				var message:T2 = commandChannel.receive();
				if (message != null) response(message);
			}
		});
		
		var resultChannel:MessageChannel = Worker.current.getSharedProperty("request2_" + name);
		
		function cb(a:T1):Void {
			if (MessageChannelState.OPEN == cast resultChannel.state) {
				resultChannel.send(a);
			} else {
				DeltaTime.fixedUpdate < cb.bind(a);
			}
		}
		
		DeltaTime.fixedUpdate < unlock;
		
		return cb;
	}
	
	public function _registerInput<T1, T2>(name:String, request:T1->Void):T2->Void {
		var commandChannel:MessageChannel = Worker.current.getSharedProperty("response_"+name);
		commandChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event:Event):Void {
			while (commandChannel.messageAvailable) {
				var message:T1 = commandChannel.receive();
				if (message != null) request(message);
			}
		});
		var resultChannel:MessageChannel = Worker.current.getSharedProperty("request_" + name);
		
		function cb(a:T2):Void {
			if (MessageChannelState.OPEN == cast resultChannel.state) {
				resultChannel.send(a);
			} else {
				DeltaTime.fixedUpdate < cb.bind(a);
			}
		}
		return cb;
	}
	
}