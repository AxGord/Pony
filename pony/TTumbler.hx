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
package pony;
import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Listener;
import pony.events.Listener1;
import pony.ui.ButtonCore;
/**
 * TTumbler
 * @author AxGord <axgord@gmail.com>
 */
interface TTumbler extends traits.ITrait {
	public var onEnable:Signal0<TTumbler>;
	public var onDisable:Signal0<TTumbler>;
	public var enabled(default, set):Bool = false;
	
	private function tumblerInit(defaultState:Bool=false):Void {
		onEnable = new Signal(this);
		onDisable = new Signal(this);
		enabled = defaultState;
	}
	
	public function set_enabled(v:Bool):Bool {
		if (v == enabled) return v;
		enabled = v;
		if (v) onEnable.dispatch();
		else onDisable.dispatch();
		return v;
	}
	
	public function regDT(l:Listener1<Void,Float>, priority:Int = 0):Void {
		onEnable.add(DeltaTime.update.add.bind(l, priority));
		onDisable.add(DeltaTime.update.remove.bind(l));
	}
	
	public function regButton(b:ButtonCore):Void {
		b.sw = [2, 1, 0];
		if ((enabled && b.mode == 0) || (!enabled && b.mode == 2)) {
			b.onMode.add(function(mode:Int) enabled = mode == 0);
			onEnable.add(function() b.mode = 0);
			onDisable.add(function() b.mode = 2);
		} else {
			b.onMode.add(function(mode:Int) enabled = mode == 2);
			onEnable.add(function() b.mode = 2);
			onDisable.add(function() b.mode = 0);
		}
	}
	
}