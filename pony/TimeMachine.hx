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
package pony;

import pony.Tools;

/**
 * TimeMachine
 * @author AxGord <axgord@gmail.com>
 */
class TimeMachine<T> {

	public var state(default, null):T;
	public var canUndo(get, never):Bool;
	private var states:Array<T> = [];
	private var defaultState:T;
	
	public function new(def:T) {
		defaultState = def;
		reset();
	}
	
	dynamic public function copy(o:T):T return Tools.clone(o);
	
	public function reset():Void {
		state = copy(defaultState);
		onState();
	}
	
	public function fullReset():Void {
		var l = states.length > 0;
		states = [];
		reset();
		if (l) onNotCanUndo();
	}
	
	public dynamic function onCanUndo():Void {}
	public dynamic function onNotCanUndo():Void {}
	public dynamic function onState():Void {}
	
	@:extern inline private function get_canUndo():Bool return states.length > 0;
	
	public function push():Void {
		states.push(copy(state));
		if (states.length == 1) onCanUndo();
	}
	
	public function undo():Void {
		if (states.length == 0) return;
		state = states.pop();
		onState();
		if (states.length == 0) onNotCanUndo();
	}
	
	public function clear():Void {
		push();
		reset();
	}
	
}