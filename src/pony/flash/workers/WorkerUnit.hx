package pony.flash.workers;

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

	private var _log: WorkerOutput<String, Void>;

	public function new() {
		_log = new WorkerOutput('log', this);
		Log.trace = log;

		// Lib.current.stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleGlobalErrors);
	}

	/*
		private function handleGlobalErrors( evt : UncaughtErrorEvent ):Void
		{
			evt.preventDefault();
			_log.request('error!');
		}
	 */
	private function log(s: String, ?p: PosInfos): Void
		_log.request((p != null ? p.fileName + ':' + p.lineNumber + ': ' : '') + s);

	public function _registerOutput<T1, T2>(name: String, response: T2 -> Void, unlock: Void -> Void): T1 -> Void {
		var commandChannel: MessageChannel = Worker.current.getSharedProperty('response2_' + name);
		commandChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event: Event): Void {
			while (commandChannel.messageAvailable) {
				var message: T2 = commandChannel.receive();
				if (message != null)
					response(message);
			}
		});
		var resultChannel: MessageChannel = Worker.current.getSharedProperty('request2_' + name);
		function cb(a: T1): Void {
			if (MessageChannelState.OPEN == cast resultChannel.state)
				resultChannel.send(a);
			else
				DeltaTime.fixedUpdate < cb.bind(a);
		}

		DeltaTime.fixedUpdate < unlock;

		return cb;
	}

	public function _registerInput<T1, T2>(name: String, request: T1 -> Void): T2 -> Void {
		var commandChannel: MessageChannel = Worker.current.getSharedProperty('response_' + name);
		commandChannel.addEventListener(Event.CHANNEL_MESSAGE, function(event: Event): Void {
			while (commandChannel.messageAvailable) {
				var message: T1 = commandChannel.receive();
				if (message != null)
					request(message);
			}
		});
		var resultChannel: MessageChannel = Worker.current.getSharedProperty('request_' + name);
		function cb(a: T2): Void {
			if (MessageChannelState.OPEN == cast resultChannel.state)
				resultChannel.send(a);
			else
				DeltaTime.fixedUpdate < cb.bind(a);
		}
		return cb;
	}

}