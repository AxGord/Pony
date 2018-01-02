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
package pony.flash.workers ;

import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.MessageChannelState;
import flash.system.Worker;
import flash.system.WorkerDomain;
import flash.system.WorkerState;
import haxe.io.Bytes;
import pony.events.Signal;
import pony.events.Signal1;
import pony.Queue;
import pony.time.DeltaTime;
import pony.time.DTimer;

/**
 * Worker
 * @author AxGord <axgord@gmail.com>
 */
class Worker implements IWorkerGatePool {
	
	public static function fromFile(f:String, cb:Worker->Void):Void FLTools.loadBytes(f, fromBytes.bind(_,cb));
	public static function fromBytes(b:Bytes, cb:Worker->Void):Void cb(new Worker(b));
	
	private var bgWorker:flash.system.Worker;
	private var lock:Bool = true;
	private var unlockers:List < Void->Void > = new List < Void->Void >();
	
	public var log:Signal1<Worker, String>;
	
	private var lw:WorkerInput<String,Int>;
	
	public function new(b:Bytes):Void {
		bgWorker = WorkerDomain.current.createWorker(b.getData(), true);
		bgWorker.addEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
		DeltaTime.fixedUpdate < bgWorker.start;
		
		log = Signal.create(this);
		lw = new WorkerInput('log', this);
		lw.request = function(s:String) {
			if (log == null) return;
			log.dispatch(s);
			lw.result(1);
		}
	}
	
	public function _registerOutput<T1, T2>(name:String, response:T2->Void, unlock:Void->Void):T1->Void {
		var resultChannel:MessageChannel = bgWorker.createMessageChannel(flash.system.Worker.current);
		resultChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event:Event):Void {
			while (resultChannel.messageAvailable) {
				var message:T2 = resultChannel.receive();
				if (message != null) response(message);
			}
		});
		bgWorker.setSharedProperty("request_"+name, resultChannel);
		
		var bgWorkerCommandChannel:MessageChannel = flash.system.Worker.current.createMessageChannel(bgWorker);
        bgWorker.setSharedProperty("response_" + name, bgWorkerCommandChannel);
		
		if (!lock) unlock();
		else unlockers.add(unlock);
		
		function cb(a:T1):Void {
			if (MessageChannelState.OPEN == cast bgWorkerCommandChannel.state) {
				bgWorkerCommandChannel.send(a);
			} else {
				DeltaTime.fixedUpdate < cb.bind(a);
			}
		}
		return cb;
	}
	
	public function _registerInput<T1, T2>(name:String, request:T1->Void):T2->Void {
		var resultChannel:MessageChannel = bgWorker.createMessageChannel(flash.system.Worker.current);
		resultChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event:Event):Void {
			while (resultChannel.messageAvailable) {
				var message:T1 = resultChannel.receive();
				if (message != null) request(message);
			}
		});
		bgWorker.setSharedProperty("request2_"+name, resultChannel);
		
		var bgWorkerCommandChannel:MessageChannel = flash.system.Worker.current.createMessageChannel(bgWorker);
        bgWorker.setSharedProperty("response2_" + name, bgWorkerCommandChannel);
		
		function cb(a:T2):Void {
			if (MessageChannelState.OPEN == cast bgWorkerCommandChannel.state) {
				bgWorkerCommandChannel.send(a);
			} else {
				DeltaTime.fixedUpdate < cb.bind(a);
			}
		}
		return cb;
	}
	
	public function destroy():Void {
		lw.destroy();
		log.dispatch('destroy worker');
		log.destroy();
		log = null;
		bgWorker.removeEventListener(Event.WORKER_STATE, handleBGWorkerStateChange);
		bgWorker.terminate();
		bgWorker = null;
	}
	
	private function handleBGWorkerStateChange(event:Event):Void
	{
		//if (bgWorker.state == WorkerState.NEW) trace('new');
		//if (bgWorker.state == WorkerState.RUNNING) trace('running');
		//if (bgWorker.state == WorkerState.TERMINATED) trace('term');
		if (bgWorker.state == WorkerState.RUNNING) DTimer.fixedDelay(100, unlock);
	}
	
	private function unlock():Void {
		lock = false;
		for (u in unlockers) u();
	}
	
}