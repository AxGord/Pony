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
package pony.unity3d;
import pony.time.DeltaTime;
import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.IKeyboard;
import pony.ui.Key;
import unityengine.Input;
import unityengine.KeyCode;

/**
 * Keyboard
 * @see pony.ui.Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard<Keyboard> {
	
	public var down:Signal1<Keyboard, Key>;
	public var up:Signal1<Keyboard, Key>;
	
	private var keys:Array<KeyCode>;
	
	public function new():Void {
		down = Signal.create(this);
		up = Signal.create(this);
		
		keys = KeyCode.createAll();
	}
	
	public inline function enable():Void DeltaTime.update.add(update, -120);
	
	public inline function disable():Void DeltaTime.update.remove(update);
	
	private function update():Void {
		if (Input.anyKeyDown)
			for (k in keys) {
				if (Input.GetKeyDown(k)) dispatchKey(down, k);
				if (Input.GetKeyUp(k)) dispatchKey(up, k);
			}
		else
			for (k in keys)
				if (Input.GetKeyUp(k)) dispatchKey(up, k);
	}
	
	private function dispatchKey(s:Signal1<Keyboard, Key>, k:KeyCode):Void {
		var k:Key = switch (k) {
			case KeyCode.A: Key.A;
			case KeyCode.B: Key.B;
			case KeyCode.C: Key.C;
			case KeyCode.D: Key.D;
			case KeyCode.E: Key.E;
			case KeyCode.F: Key.F;
			case KeyCode.G: Key.G;
			case KeyCode.H: Key.H;
			case KeyCode.I: Key.I;
			case KeyCode.J: Key.J;
			case KeyCode.K: Key.K;
			case KeyCode.L: Key.L;
			case KeyCode.M: Key.M;
			case KeyCode.N: Key.N;
			case KeyCode.O: Key.O;
			case KeyCode.P: Key.P;
			case KeyCode.Q: Key.Q;
			case KeyCode.R: Key.R;
			case KeyCode.S: Key.S;
			case KeyCode.T: Key.T;
			case KeyCode.U: Key.U;
			case KeyCode.V: Key.V;
			case KeyCode.W: Key.W;
			case KeyCode.X: Key.X;
			case KeyCode.Y: Key.Y;
			case KeyCode.Z: Key.Z;
			case KeyCode.Backspace: Key.Backspace; 
			case KeyCode.Tab: Key.Tab;
			case KeyCode.Escape: Key.Escape;
			case KeyCode.Space: Key.Space;
			case KeyCode.Keypad0: Key.Keypad0;
			case KeyCode.Keypad1: Key.Keypad1;
			case KeyCode.Keypad2: Key.Keypad2;
			case KeyCode.Keypad3: Key.Keypad3;
			case KeyCode.Keypad4: Key.Keypad4;
			case KeyCode.Keypad5: Key.Keypad5;
			case KeyCode.Keypad6: Key.Keypad6;
			case KeyCode.Keypad7: Key.Keypad7;
			case KeyCode.Keypad8: Key.Keypad8;
			case KeyCode.Keypad9: Key.Keypad9;
			case KeyCode.KeypadDivide: Key.KeypadDivide;
			case KeyCode.KeypadEquals: Key.Equals;
			case KeyCode.KeypadMultiply: Key.KeypadMultiply;
			case KeyCode.KeypadMinus: Key.KeypadMinus;
			case KeyCode.KeypadPlus: Key.KeypadPlus;
			case KeyCode.KeypadEnter: Key.KeypadEnter;
			case KeyCode.KeypadPeriod: Key.KeypadDot;
			case KeyCode.UpArrow: Key.Up;
			case KeyCode.DownArrow: Key.Down;
			case KeyCode.RightArrow: Key.Right;
			case KeyCode.LeftArrow: Key.Left;
			case KeyCode.Insert: Key.Insert;
			case KeyCode.Delete: Key.Delete;
			case KeyCode.Home: Key.Home;
			case KeyCode.End: Key.End;
			case KeyCode.PageUp: Key.PageUp;
			case KeyCode.PageDown: Key.PageDown;
			case KeyCode.F1: Key.F1;
			case KeyCode.F2: Key.F2;
			case KeyCode.F3: Key.F3;
			case KeyCode.F4: Key.F4;
			case KeyCode.F5: Key.F5;
			case KeyCode.F6: Key.F6;
			case KeyCode.F7: Key.F7;
			case KeyCode.F8: Key.F8;
			case KeyCode.F9: Key.F9;
			case KeyCode.F10: Key.F10;
			case KeyCode.F11: Key.F11;
			case KeyCode.F12: Key.F12;
			case KeyCode.Alpha1: Key.Number1;
			case KeyCode.Alpha2: Key.Number2;
			case KeyCode.Alpha3: Key.Number3;
			case KeyCode.Alpha4: Key.Number4;
			case KeyCode.Alpha5: Key.Number5;
			case KeyCode.Alpha6: Key.Number6;
			case KeyCode.Alpha7: Key.Number7;
			case KeyCode.Alpha8: Key.Number8;
			case KeyCode.Alpha9: Key.Number9;
			case KeyCode.Alpha0: Key.Number0;
			case KeyCode.Print: Key.PrintScreen;
			case KeyCode.Pause: Key.Pause;
			case KeyCode.ScrollLock: Key.ScrollLock;
			case KeyCode.Numlock: Key.NumLock;
			case KeyCode.KeypadEquals: Key.Equals;
			case KeyCode.Minus: Key.Minus;
			case KeyCode.BackQuote: Key.Tilde;
			case KeyCode.Period: Key.Dot;
			case KeyCode.Slash: Key.RightSlash;
			case KeyCode.Backslash: Key.LeftSlash;
			case KeyCode.Quote: Key.Quote;
			case KeyCode.LeftShift: Key.Shift;
			case KeyCode.LeftControl: Key.Ctrl;
			case KeyCode.LeftAlt: Key.Alt;
			case KeyCode.CapsLock: Key.CapsLock;
			case KeyCode.LeftWindows: Key.LeftWin;
			case KeyCode.RightWindows: Key.RightWin;
			case KeyCode.Plus: Key.Plus;
			case KeyCode.Return: Key.Enter;
		};
		if (k != null) s.dispatch(k);
	}
	
}