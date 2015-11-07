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
package pony.ui.keyboard.flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard<Keyboard> {

	public var down(default, null):Signal1<Keyboard, Key>;
	public var up(default, null):Signal1<Keyboard, Key>;
	
	public function new() {
		down = Signal.create(this);
		up = Signal.create(this);	
	}
	
	public function enable():Void {
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	public function disable():Void {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	private function kd(event:KeyboardEvent):Void down.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	private function ku(event:KeyboardEvent):Void up.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	
}