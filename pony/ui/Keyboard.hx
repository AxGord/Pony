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
package pony.ui;
import pony.DeltaTime;
import pony.DTimer;
import pony.events.Event;
import pony.events.Signal;
import pony.events.Signal1;

/**
 * Keyboard
 * @see pony.ui.Key
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard {
	
	static public var pressFirstDelay:Float = 0.5;
	static public var pressDelay:Float = 0.2;
	
	static public var down:Signal1<Void, Key>;
	static public var up:Signal1<Void, Key>;
	static public var press:Signal1<Void, Key>;
	static public var click:Signal1<Void, Key>;
	
	static public var pressedKeys:List<Key> = new List<Key>();
	
	static private var km:IKeyboard<Dynamic>;
	static private var time:Float = 0;
	static private var delay:Float;
	static private var _enabled:Bool = false;
	
	static public var enabled(default, set):Bool = false;
	static public var disabled(default, set):Bool = false;
	
	static private function __init__():Void {
		#if HUGS
		km = new pony.unity3d.Keyboard();
		#elseif flash
		km = new pony.flash.Keyboard();
		#end
		down = Signal.createEmpty();
		up = Signal.createEmpty();
		press = Signal.createEmpty();
		click = Signal.createEmpty();
		
		autoEnableMode();
	}
	
	static private function takeListeners():Void {
		if (haveListeners()) enable();
	}
	
	static private function lostListeners():Void {
		if (!haveListeners()) disable();
	}
	
	static private inline function haveListeners():Bool
		return down.haveListeners || up.haveListeners  || press.haveListeners || click.haveListeners;
	
	static private function downPress(e:Event):Void {
		var k:Key = e.args[0];
		if (pressedKeys.length == 0)
			DeltaTime.update.add(update, -100);
		delay = pressFirstDelay;
		time = 0;
		pressedKeys.push(k);
		km.up.sub(k).once(upPress);
		press.dispatch(k);
	}
	
	static private function update(dt:Float):Void {
		time += dt;
		if (time >= delay) {
			time -= delay;
			delay = pressDelay;
			for (k in pressedKeys) press.dispatch(k);
		}
	}
	
	static inline private function upPress(e:Event):Void {
		var k:Key = e.parent.args[0];
		click.dispatch(k);
		pressedKeys.remove(k);
		if (pressedKeys.length == 0)
			DeltaTime.update.remove(update);
	}
	
	static private function enable():Void {
		if (_enabled == true) return;
		_enabled = true;
		km.enable();
		km.down.add(downPress);
		km.down.add(down.dispatchEvent);
		km.up.add(up.dispatchEvent);
	}
	
	static private function disable():Void {
		if (_enabled == false) return;
		_enabled = false;
		DeltaTime.update.remove(update);
		pressedKeys.clear();
		km.up.removeAllListeners();
		km.down.removeAllListeners();
		km.disable();
	}
	
	static private function set_enabled(b:Bool):Bool {
		if (b == enabled) return b;
		if (b) {
			disabled = false;
			manualEnableMode();
			enable();
		} else {
			autoEnableMode();
			lostListeners();
		}
		return enabled = b;
	}
	
	static private function set_disabled(b:Bool):Bool {
		if (b == disabled) return b;
		if (b) {
			enabled = false;
			manualEnableMode();
			disable();
		} else {
			autoEnableMode();
			lostListeners();
		}
		return disabled = b;
	}
	
	static private function manualEnableMode():Void {
		down.takeListeners.remove(takeListeners);
		up.takeListeners.remove(takeListeners);
		press.takeListeners.remove(takeListeners);
		click.takeListeners.remove(takeListeners);
		
		down.lostListeners.remove(lostListeners);
		up.lostListeners.remove(lostListeners);
		press.lostListeners.remove(lostListeners);
		click.lostListeners.remove(lostListeners);
	}
	
	static private function autoEnableMode():Void {
		down.takeListeners.add(takeListeners);
		up.takeListeners.add(takeListeners);
		press.takeListeners.add(takeListeners);
		click.takeListeners.add(takeListeners);
		
		down.lostListeners.add(lostListeners);
		up.lostListeners.add(lostListeners);
		press.lostListeners.add(lostListeners);
		click.lostListeners.add(lostListeners);
	}
	
	static public var map:Map<Int, Key> = [
		8 => Backspace,
		9 => Tab,
		13 => Enter,
		16 => Shift,
		17 => Ctrl,
		18 => Alt,
		19 => Pause,
		20 => CapsLock,
		27 => Escape,
		32 => Space,
		33 => PageUp,
		34 => PageDown,
		35 => End,
		36 => Home,
		37 => Left,
		38 => Up,
		39 => Right,
		40 => Down,
		45 => Insert,
		46 => Delete,
		48 => Number0,
		49 => Number1,
		50 => Number2,
		51 => Number3,
		52 => Number4,
		53 => Number5,
		54 => Number6,
		55 => Number7,
		56 => Number8,
		57 => Number9,
		65 => A,
		66 => B,
		67 => C,
		68 => D,
		69 => E,
		70 => F,
		71 => G,
		72 => H,
		73 => I,
		74 => J,
		75 => K,
		76 => L,
		77 => M,
		78 => N,
		79 => O,
		80 => P,
		81 => Q, 
		82 => R,
		83 => S,
		84 => T,
		85 => U,
		86 => V,
		87 => W,
		88 => X,
		89 => Y,
		90 => Z,
		91 => LeftWin,
		92 => RightWin,
		93 => Applications,
		96 => Keypad0,
		97 => Keypad1,
		98 => Keypad2,
		99 => Keypad3,
		100 => Keypad4,
		101 => Keypad5,
		102 => Keypad6,
		103 => Keypad7,
		104 => Keypad8,
		105 => Keypad9,
		106 => KeypadMultiply,
		107 => KeypadPlus,
		109 => KeypadMinus,
		110 => KeypadDot,
		111 => KeypadDivide,
		112 => F1,
		113 => F2,
		114 => F3,
		115 => F4,
		116 => F5,
		117 => F6,
		118 => F7,
		119 => F8,
		120 => F9,
		121 => F10,
		122 => F11,
		123 => F12,
		144 => NumLock,
		145 => ScrollLock,
		154 => PrintScreen,
		157 => Meta,
		187 => Plus,
		189 => Minus,
		192 => Tilde,
		188 => Quote,
		190 => Dot,
		191 => RightSlash,
		220 => LeftSlash
	];
}