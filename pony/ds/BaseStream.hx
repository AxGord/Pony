package pony.ds;

import pony.magic.HasSignal;
import pony.events.Signal0;
import pony.events.Signal1;

/**
 * BaseStream
 * @author AxGord <axgord@gmail.com>
 */
class BaseStream<T> implements HasSignal {

	@:auto public var onData:Signal1<T>;
	@:auto public var onEnd:Signal1<T>;
	@:auto public var onError:Signal0;

	@:auto public var onGetData:Signal0;
	@:auto public var onCancel:Signal0;
	@:auto public var onComplete:Signal0;

	private var buffer:T;
	private var sendNext:Bool = false;
	private var dataRequested:Bool = false;
	private var nextRequest:Bool = false;
	private var ended:Bool = false;

	public function new() {}

	public function next():Void {
		if (ended) return;
		if (buffer != null) {
			eData.dispatch(buffer);
			buffer = null;
			getData();
		} else if (!sendNext) {
			sendNext = true;
			getData();
		} else {
			throw 'So fast';
		}
	}

	public function cancel():Void {
		ended = true;
		buffer = null;
		eCancel.dispatch();
		destroy();
	}

	public function data(d:T):Void {
		if (ended) return;
		dataRequested = false;
		if (sendNext) {
			sendNext = false;
			eData.dispatch(d);
		} else if (buffer == null) {
			buffer = d;
		} else {
			throw 'So fast';
		}

		if (nextRequest) {
			nextRequest = false;
			getData();
		}
	}

	public function end(b:T):Void {
		ended = true;
		eEnd.dispatch(b);
	}

	public function error():Void {
		ended = true;
		buffer = null;
		eError.dispatch();
		destroy();
	}

	private function getData():Void {
		if (!dataRequested) {
			dataRequested = true;
			eGetData.dispatch();
		} else if (!nextRequest) {
			nextRequest = true;
		} else {
			throw 'So fast';
		}
	}

	public function complete():Void {
		eComplete.dispatch();
		destroy();
	}

	private function destroy():Void {
		destroySignals();
	}

}