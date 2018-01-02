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
package pony.flash.workers;

import flash.events.Event;
import pony.magic.Declarator;
import pony.Tools;

/**
 * WorkerOutput
 * @author AxGord <axgord@gmail.com>
 */
class WorkerOutput<T1, T2> implements Declarator {
	
	@:arg public var name(default,null):String;
	@:arg private var gate:IWorkerGatePool;
	
	private var q:Queue < T1->(T2->Void)->Void > = new Queue < T1->(T2->Void)->Void > (_request);

	public function new() {
		q.busy = true;
		req = gate._registerOutput(name, response, q.next);
	}
	
	inline public function request(r:T1, ?cb:T2->Void):Void q.call(r, cb);
	
	private function _request(r:T1, cb:T2->Void):Void {
		_response = cb != null ? cb: Tools.nullFunction1;
		req(r);
	}
	
	dynamic private function req(r:T1):Void {}
	
	private function response(r:T2):Void {
		_response(r);
		q.next();
	}
	
	dynamic private function _response(r:T2):Void { }
	
	public function destroy():Void {
		gate = null;
		q = null;
		req = null;
		_response = null;
	}
	
}