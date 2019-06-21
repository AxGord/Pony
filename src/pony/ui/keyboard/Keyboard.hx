package pony.ui.keyboard;

import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;

/**
 * Keyboard
 * Need declarator for __init__
 * @see pony.ui.Key
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements Declarator implements HasSignal {
	
	@:auto public static var down:Signal1<Key>;
	@:auto public static var up:Signal1<Key>;
	@:auto public static var press:Signal1<Key>;
	@:auto public static var click:Signal1<Key>;
	
	public static var pressedKeys:Array<Key> = [];
	
	private static var km:IKeyboard;
	private static var _enabled:Bool = false;
	
	public static var enabled(default, set):Bool = false;
	public static var disabled(default, set):Bool = false;
	
	private static var presser:Presser;
	
	private static function __init__():Void {
		#if heaps
		km = new pony.ui.keyboard.heaps.Keyboard();
		#elseif (HUGS && !WITHOUTUNITY)
		km = new pony.ui.keyboard.unity.Keyboard();
		#elseif flash
		km = new pony.ui.keyboard.flash.Keyboard();
		#end
		
		autoEnableMode();
	}
	
	private static function takeListeners():Void if (haveListeners()) enable();
	private static function lostListeners():Void if (!haveListeners()) disable();
	private static inline function haveListeners():Bool
		return !down.empty || !up.empty  || !press.empty || !click.empty;
	
	private static function downPress(k:Key):Void {
		if (presser == null) presser = new Presser(_press);
		if (pressedKeys.indexOf(k) != -1) return;
		pressedKeys.push(k);
		eDown.dispatch(k);
		ePress.dispatch(k);
	}
	
	private static function _press():Void for (k in pressedKeys) ePress.dispatch(k);
	
	private static function upPress(k:Key):Void {
		eUp.dispatch(k);
		if (pressedKeys.indexOf(k) == -1) return;
		eClick.dispatch(k);
		pressedKeys.remove(k);
		if (pressedKeys.length == 0) {
			presser.destroy();
			presser = null;
		}
	}
	
	private static function enable():Void {
		if (_enabled) return;
		_enabled = true;
		km.enable();
		km.down << downPress;
		km.up << upPress;
	}
	
	private static function disable():Void {
		if (!_enabled) return;
		_enabled = false;
		if (presser != null) presser.destroy();
		pressedKeys = [];
		km.up.clear();
		km.down.clear();
		km.disable();
	}
	
	private static function set_enabled(b:Bool):Bool {
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
		eDown.onTake.remove(takeListeners);
		eUp.onTake.remove(takeListeners);
		ePress.onTake.remove(takeListeners);
		eClick.onTake.remove(takeListeners);
		
		eDown.onLost.remove(lostListeners);
		eUp.onLost.remove(lostListeners);
		ePress.onLost.remove(lostListeners);
		eClick.onLost.remove(lostListeners);
	}
	
	static private function autoEnableMode():Void {
		eDown.onTake.add(takeListeners);
		eUp.onTake.add(takeListeners);
		ePress.onTake.add(takeListeners);
		eClick.onTake.add(takeListeners);
		
		eDown.onLost.add(lostListeners);
		eUp.onLost.add(lostListeners);
		ePress.onLost.add(lostListeners);
		eClick.onLost.add(lostListeners);
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