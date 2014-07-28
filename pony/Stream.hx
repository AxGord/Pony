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
package pony;

/**
 * Stream
 * Use listeners for events
 * @author AxGord <axgord@gmail.com>
 */
class Stream<T> {
	
	private var result(default, null):List<T>;
	private var complite(default, null):Bool = false;
	private var fail(default, null):Dynamic = null;

	inline public function new() result = new List<T>();
	
	dynamic private function data(v:T):Void result.push(v);
	dynamic private function end():Void {
		complite = true;
		destroy();
	}
	dynamic private function error(v:Dynamic):Void fail = v;
	
	inline public function dataListener(v:T):Void data(v);
	inline public function endListener():Void end();
	inline public function errorListener(v:Dynamic):Void error(v);
	
	public function map<R>(f:T->R):Stream<R> {
		var s = new Stream<R>();
		take(function(v:T)s.dataListener(f(v)), s.endListener, s.errorListener);
		return s;
	}
	
	dynamic public function take(d:T->Void, ?compl:Void->Void, ?err:Dynamic->Void):Void {
		if (err == null) err = Tools.errorFunction;
		if (compl == null) compl = Tools.nullFunction0;
		if (fail != null) {
			err(fail);
		}
		for (e in result) d(e);
		if (complite) {
			compl();
			result = null;
			destroy();
		} else {
			result = null;
			data = d;
			end = function() {
				compl();
				result = null;
				end = Tools.nullFunction0;
				destroy();
			}
			error = function(e) {
				err(e);
				result = null;
				destroy();
			}
		}
		take = locked;
	}
	
	public function atake(d:T->Void, ?compl:Dynamic->Void):Void take(d, function() { compl(null); compl = Tools.nullFunction1; }, function(e:Dynamic) { compl(e); compl = Tools.nullFunction1; } );
	
	private function locked(d:T->Void, ?compl:Void->Void, ?err:Dynamic->Void):Void throw 'Stream locked';
	
	inline private function destroy():Void {
		fail = null;
		data = Tools.nullFunction1;
		error = Tools.errorFunction;
	}
}