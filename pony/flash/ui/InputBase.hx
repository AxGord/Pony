/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import pony.events.Signal;

/**
 * InputBase
 * @author AxGord <axgord@gmail.com>
 */
class InputBase<T> extends MovieClip {

	public var change:Signal;
	public var inp(get,never):TextField;
	public var edit(get, set):Bool;
	public var value(get, set):T;
	
	public function new() {
		super();
		stop();
		change = new Signal(this);
		inp.addEventListener(Event.CHANGE, chHandler);
	}
	
	private function chHandler(_):Void {
		change.dispatch(value);
	}
	
	inline private function get_inp():TextField return untyped this['input'];
	
	inline private function get_edit():Bool return inp.type == TextFieldType.INPUT;
	
	private function set_edit(v:Bool):Bool {
		if (v == edit) return v;
		if (v) {
			inp.type = TextFieldType.INPUT;
			inp.selectable = true;
			gotoAndStop(1);
		} else {
			inp.type = TextFieldType.DYNAMIC;
			inp.selectable = false;
			gotoAndStop(2);
		}
		return v;
	}
	
	private function get_value():T return cast inp.text;
	private function set_value(v:T):T return cast inp.text = cast v;
	
}