package pony.ui.keyboard.unity;

import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.events.Signal1;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;
import unityengine.Input;
import unityengine.KeyCode;

/**
 * Unity Keyboard
 * @see pony.ui.Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	private static var keys: Array<KeyCode> = [
		KeyCode.A,
		KeyCode.B,
		KeyCode.C,
		KeyCode.D,
		KeyCode.E,
		KeyCode.F,
		KeyCode.G,
		KeyCode.H,
		KeyCode.I,
		KeyCode.J,
		KeyCode.K,
		KeyCode.L,
		KeyCode.M,
		KeyCode.N,
		KeyCode.O,
		KeyCode.P,
		KeyCode.Q,
		KeyCode.R,
		KeyCode.S,
		KeyCode.T,
		KeyCode.U,
		KeyCode.V,
		KeyCode.W,
		KeyCode.X,
		KeyCode.Y,
		KeyCode.Z,
		KeyCode.Backspace,
		KeyCode.Tab,
		KeyCode.Escape,
		KeyCode.Space,
		KeyCode.Keypad0,
		KeyCode.Keypad1,
		KeyCode.Keypad2,
		KeyCode.Keypad3,
		KeyCode.Keypad4,
		KeyCode.Keypad5,
		KeyCode.Keypad6,
		KeyCode.Keypad7,
		KeyCode.Keypad8,
		KeyCode.Keypad9,
		KeyCode.KeypadDivide,
		KeyCode.KeypadEquals,
		KeyCode.KeypadMultiply,
		KeyCode.KeypadMinus,
		KeyCode.KeypadPlus,
		KeyCode.KeypadEnter,
		KeyCode.KeypadPeriod,
		KeyCode.UpArrow,
		KeyCode.DownArrow,
		KeyCode.RightArrow,
		KeyCode.LeftArrow,
		KeyCode.Insert,
		KeyCode.Delete,
		KeyCode.Home,
		KeyCode.End,
		KeyCode.PageUp,
		KeyCode.PageDown,
		KeyCode.F1,
		KeyCode.F2,
		KeyCode.F3,
		KeyCode.F4,
		KeyCode.F5,
		KeyCode.F6,
		KeyCode.F7,
		KeyCode.F8,
		KeyCode.F9,
		KeyCode.F10,
		KeyCode.F11,
		KeyCode.F12,
		KeyCode.Alpha1,
		KeyCode.Alpha2,
		KeyCode.Alpha3,
		KeyCode.Alpha4,
		KeyCode.Alpha5,
		KeyCode.Alpha6,
		KeyCode.Alpha7,
		KeyCode.Alpha8,
		KeyCode.Alpha9,
		KeyCode.Alpha0,
		KeyCode.Print,
		KeyCode.Pause,
		KeyCode.ScrollLock,
		KeyCode.Numlock,
		KeyCode.Minus,
		KeyCode.BackQuote,
		KeyCode.Period,
		KeyCode.Slash,
		KeyCode.Backslash,
		KeyCode.Quote,
		KeyCode.LeftShift,
		KeyCode.LeftControl,
		KeyCode.LeftAlt,
		KeyCode.CapsLock,
		KeyCode.LeftWindows,
		KeyCode.RightWindows,
		KeyCode.Plus,
		KeyCode.Return
	];

	@:auto public var down: Signal1<Key>;
	@:auto public var up: Signal1<Key>;

	public var preventDefault: Bool = false;

	public function new() {}
	public inline function enable(): Void DeltaTime.fixedUpdate.add(update, -120);
	public inline function disable(): Void DeltaTime.fixedUpdate.remove(update);

	private function update(): Void {
		if (Input.anyKeyDown)
			for (k in keys) {
				if (Input.GetKeyDown(k)) dispatchKey(down, k);
				if (Input.GetKeyUp(k)) dispatchKey(up, k);
			}
		else
			for (k in keys)
				if (Input.GetKeyUp(k)) dispatchKey(up, k);
	}

	private function dispatchKey(s: Signal1 < Keyboard, Key > , sk: KeyCode): Void {
		var k:Key = null;
		Tools.ifsw(switch sk {
			case KeyCode.A: k = Key.A;
			case KeyCode.B: k = Key.B;
			case KeyCode.C: k = Key.C;
			case KeyCode.D: k = Key.D;
			case KeyCode.E: k = Key.E;
			case KeyCode.F: k = Key.F;
			case KeyCode.G: k = Key.G;
			case KeyCode.H: k = Key.H;
			case KeyCode.I: k = Key.I;
			case KeyCode.J: k = Key.J;
			case KeyCode.K: k = Key.K;
			case KeyCode.L: k = Key.L;
			case KeyCode.M: k = Key.M;
			case KeyCode.N: k = Key.N;
			case KeyCode.O: k = Key.O;
			case KeyCode.P: k = Key.P;
			case KeyCode.Q: k = Key.Q;
			case KeyCode.R: k = Key.R;
			case KeyCode.S: k = Key.S;
			case KeyCode.T: k = Key.T;
			case KeyCode.U: k = Key.U;
			case KeyCode.V: k = Key.V;
			case KeyCode.W: k = Key.W;
			case KeyCode.X: k = Key.X;
			case KeyCode.Y: k = Key.Y;
			case KeyCode.Z: k = Key.Z;
			case KeyCode.Backspace: k = Key.Backspace;
			case KeyCode.Tab: k = Key.Tab;
			case KeyCode.Escape: k = Key.Escape;
			case KeyCode.Space: k = Key.Space;
			case KeyCode.Keypad0: k = Key.Keypad0;
			case KeyCode.Keypad1: k = Key.Keypad1;
			case KeyCode.Keypad2: k = Key.Keypad2;
			case KeyCode.Keypad3: k = Key.Keypad3;
			case KeyCode.Keypad4: k = Key.Keypad4;
			case KeyCode.Keypad5: k = Key.Keypad5;
			case KeyCode.Keypad6: k = Key.Keypad6;
			case KeyCode.Keypad7: k = Key.Keypad7;
			case KeyCode.Keypad8: k = Key.Keypad8;
			case KeyCode.Keypad9: k = Key.Keypad9;
			case KeyCode.KeypadDivide: k = Key.KeypadDivide;
			case KeyCode.KeypadEquals: k = Key.Equals;
			case KeyCode.KeypadMultiply: k = Key.KeypadMultiply;
			case KeyCode.KeypadMinus: k = Key.KeypadMinus;
			case KeyCode.KeypadPlus: k = Key.KeypadPlus;
			case KeyCode.KeypadEnter: k = Key.KeypadEnter;
			case KeyCode.KeypadPeriod: k = Key.KeypadDot;
			case KeyCode.UpArrow: k = Key.Up;
			case KeyCode.DownArrow: k = Key.Down;
			case KeyCode.RightArrow: k = Key.Right;
			case KeyCode.LeftArrow: k = Key.Left;
			case KeyCode.Insert: k = Key.Insert;
			case KeyCode.Delete: k = Key.Delete;
			case KeyCode.Home: k = Key.Home;
			case KeyCode.End: k = Key.End;
			case KeyCode.PageUp: k = Key.PageUp;
			case KeyCode.PageDown: k = Key.PageDown;
			case KeyCode.F1: k = Key.F1;
			case KeyCode.F2: k = Key.F2;
			case KeyCode.F3: k = Key.F3;
			case KeyCode.F4: k = Key.F4;
			case KeyCode.F5: k = Key.F5;
			case KeyCode.F6: k = Key.F6;
			case KeyCode.F7: k = Key.F7;
			case KeyCode.F8: k = Key.F8;
			case KeyCode.F9: k = Key.F9;
			case KeyCode.F10: k = Key.F10;
			case KeyCode.F11: k = Key.F11;
			case KeyCode.F12: k = Key.F12;
			case KeyCode.Alpha1: k = Key.Number1;
			case KeyCode.Alpha2: k = Key.Number2;
			case KeyCode.Alpha3: k = Key.Number3;
			case KeyCode.Alpha4: k = Key.Number4;
			case KeyCode.Alpha5: k = Key.Number5;
			case KeyCode.Alpha6: k = Key.Number6;
			case KeyCode.Alpha7: k = Key.Number7;
			case KeyCode.Alpha8: k = Key.Number8;
			case KeyCode.Alpha9: k = Key.Number9;
			case KeyCode.Alpha0: k = Key.Number0;
			case KeyCode.Print: k = Key.PrintScreen;
			case KeyCode.Pause: k = Key.Pause;
			case KeyCode.ScrollLock: k = Key.ScrollLock;
			case KeyCode.Numlock: k = Key.NumLock;
			//case KeyCode.KeypadEquals: Key.Equals;
			case KeyCode.Minus: k = Key.Minus;
			case KeyCode.BackQuote: k = Key.Tilde;
			case KeyCode.Period: k = Key.Dot;
			case KeyCode.Slash: k = Key.RightSlash;
			case KeyCode.Backslash: k = Key.LeftSlash;
			case KeyCode.Quote: k = Key.Quote;
			case KeyCode.LeftShift: k = Key.Shift;
			case KeyCode.LeftControl: k = Key.Ctrl;
			case KeyCode.LeftAlt: k = Key.Alt;
			case KeyCode.CapsLock: k = Key.CapsLock;
			case KeyCode.LeftWindows: k = Key.LeftWin;
			case KeyCode.RightWindows: k = Key.RightWin;
			case KeyCode.Plus: k = Key.Plus;
			case KeyCode.Return: k = Key.Enter;
			//
			//case _: null;
		});
		if (k != null) s.dispatch(k);
	}

}