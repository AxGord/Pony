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

import pony.magic.Declarator;
import pony.time.DeltaTime;
import pony.events.*;
import pony.time.DT;
#if (!neko && !nodejs)
import pony.ui.ButtonCore;
#end
/**
 * Tumbler
 * @author AxGord <axgord@gmail.com>
 */
class Tumbler<T> {

	public var onEnable:Signal0<T>;
	public var onDisable:Signal0<T>;
	public var enabled(default, set):Bool = false;
	
	public function new() {
		onEnable = Signal.create(cast this);
		onDisable = Signal.create(cast this);
		#if (!neko && !nodejs)
		buttons = new Map();
		buttonsPress = new Map();
		#end
	}
	
	public function set_enabled(v:Bool):Bool {
		if (v == enabled) return v;
		enabled = v;
		if (v) onEnable.dispatch();
		else onDisable.dispatch();
		return v;
	}
	
	
	public function regDT(l:Listener1 < Void, DT > , priority:Int = 0):Void {
		onEnable.add(DeltaTime.update.add.bind(l, priority));
		onDisable.add(DeltaTime.update.remove.bind(l));
	}
	#if (!neko && !nodejs)
	private var buttons:Map<pony.ui.ButtonCore, TumblerButtonGlue>;
	private var buttonsPress:Map<pony.ui.ButtonCore, TumblerButtonPressGlue>;
	public function regButton(b:pony.ui.ButtonCore):T {
		b.sw = [2, 1, 0];
		buttons[b] = new TumblerButtonGlue(b, cast this);
		return cast this;
	}
	public function unregButton(b:pony.ui.ButtonCore):Bool {
		if (buttons.exists(b)) {
			buttons[b].destroy();
			buttons.remove(b);
			return true;
		} else return false;
	}
	inline public function syncButton(b:pony.ui.ButtonCore):Void b.mode = enabled ? 2 : 0;
	inline public function syncButtonInvert(b:pony.ui.ButtonCore):Void b.mode = enabled ? 0 : 2;
	
	public function regButtonPress(b:pony.ui.ButtonCore):T {
		buttonsPress[b] = new TumblerButtonPressGlue(b, cast this);
		return cast this;
	}
	
	public function unregButtonPress(b:pony.ui.ButtonCore):Bool {
		if (buttonsPress.exists(b)) {
			buttonsPress[b].destroy();
			buttonsPress.remove(b);
			return true;
		} else return false;
	}
	
	#end
	inline public function silentSetEnabled(v:Bool):Void Reflect.setField(this, 'enabled', v);
	
}
#if (!neko && !nodejs)
class TumblerButtonGlue implements Declarator {
	
	@:arg private var b:ButtonCore;
	@:arg private var t:Tumbler<Tumbler<Dynamic>>;
	
	public function new() {
		if ((t.enabled && b.mode == 0) || (!t.enabled && b.mode == 2)) {
			b.onMode.add(onMode);
			t.onEnable.add(but0);
			t.onDisable.add(but2);
		} else {
			b.onMode.add(onModeInvert);
			t.onEnable.add(but2);
			t.onDisable.add(but0);
		}
	}
	
	public function destroy():Void {
		b.onMode.remove(onMode);
		b.onMode.remove(onModeInvert);
		t.onEnable.remove(but0);
		t.onDisable.remove(but2);
		t.onEnable.remove(but2);
		t.onDisable.remove(but0);
		b = null;
		t = null;
	}
	
	private function onMode(mode:Int):Void t.enabled = b.mode == 0;
	private function onModeInvert(mode:Int):Void t.enabled = b.mode == 2;
	private function but0():Void b.mode = 0;
	private function but2():Void b.mode = 2;
	
	
	
}

class TumblerButtonPressGlue implements Declarator {
	
	@:arg private var b:ButtonCore;
	@:arg private var t:Tumbler<Tumbler<Dynamic>>;
	
	public function new() {
		b.change.add(change);
	}
	
	private function change(m:ButtonStates):Void {
		switch m {
			case ButtonStates.Press: t.enabled = true;
			case _: t.enabled = false;
		}
	}
	
	inline public function destroy():Void {
		trace('destroy');
		b.change.remove(change);
		b = null;
		t = null;
	}
	
	
}

#end