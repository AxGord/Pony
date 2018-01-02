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
package pony.ds;

import pony.magic.HasSignal;
import pony.events.Signal0;
import pony.events.Signal1;

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