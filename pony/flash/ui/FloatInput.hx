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
import flash.events.Event;
using pony.Tools;
/**
 * FloatInput
 * @author AxGord <axgord@gmail.com>
 */
class FloatInput extends InputBase<Null<Float>> {

	public var cafterdot:Int = 1;
	public var min:Float = 0;
	public var max:Float = 100;
	
	public var d:String = '.';
	
	public function new() {
		super();
		inp.removeEventListener(Event.CHANGE, chHandler);
		inp.addEventListener(Event.CHANGE, changeHandler);
		inp.restrict = '0-9.';
	}
	
	private function changeHandler(_):Void {
		var v:Float = value;
		if (v < min) value = min;
		else if (v > max) value = max;
		change.dispatch(value);
	}
	
	override private function get_value():Null<Float> {
		if (inp.text == '') return null;
		return Std.parseFloat(inp.text);
	}
	
	override private function set_value(v:Null<Float>):Null<Float> {
		inp.text = v == null ? '' : v._toFixed(cafterdot, 0, d);
		return v;
	}
	
}