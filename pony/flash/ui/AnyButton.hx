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
import pony.events.Signal;
import flash.events.MouseEvent;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;

/**
 * AnyButton
 * One interface for all buttons
 * @author AxGord
 */

enum ButtonType { flcontrol; qlex; simple; }

class AnyButton {
	
	public var enabled(get, set):Bool;
	public var click:Signal;
	
	private var button:Dynamic;
	private var type:ButtonType;
	
	public var shift(get,set):Bool;
	//@bind public var shift:Bool = untyped button.shift;
	
	public function new(button:Dynamic) {
		this.button = button;
		if (Reflect.hasField(button, 'disabled'))
			type = ButtonType.qlex;
		else if (Reflect.hasField(button, 'label'))
			type = ButtonType.flcontrol;
		else
			type = ButtonType.simple;
			
		click = new Signal();
		
		switch (type) {
			case ButtonType.qlex: button.addEventListener('butclick', onClick);
		default: 
			button.addEventListener(MouseEvent.CLICK, onClick);
		}
	}
	
	private function onClick(?_):Void _onClick();
	
	private function _onClick():Void if (enabled) click.dispatch();
	
	private function get_enabled():Bool {
		return switch (type) {
			case ButtonType.flcontrol, ButtonType.simple: button.enabled;
			case ButtonType.qlex: !button.disabled;
		}
	}
	
	private function set_enabled(b:Bool):Bool {
		switch (type) {
			case ButtonType.qlex: button.disabled = !b;
			default: button.enabled = b;
		}
		return b;
	}
	
	public function bind(k:Key):Void {
		Keyboard.click.sub(k).add(_onClick);
	}
	
	private function get_shift():Bool return untyped button.shift;
	private function set_shift(state:Bool):Bool return untyped button.shift = state;
	
}