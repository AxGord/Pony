/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.keyboard.flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;
	
	public function new() {}
	
	public function enable():Void {
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	public function disable():Void {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	private function kd(event:KeyboardEvent):Void eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	private function ku(event:KeyboardEvent):Void eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	
}