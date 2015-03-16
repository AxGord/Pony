/**
* Copyright (c) 2013-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.events.Event;
import pony.events.Signal;

/**
 * Button Core
 * @author AxGord
 */

enum ButtonStates {
	Default; Focus; Leave; Press;
}
 
class ButtonCore {
	
	public static var MOUSE_FOCUS:Bool = true;
	
	private var presser:Presser;
	
	public var mouseState(default, null):ButtonStates;
	public var tabState(default, null):ButtonStates;
	public var keyboardState(default, null):ButtonStates;
	public var fakeState:ButtonStates;
	
	public var summaryState(get, null):ButtonStates;
	public var visualState(get, null):ButtonStates;
	
	private var prevSummary:ButtonStates;
	private var prevVisual:ButtonStates;
	private var prevTab:Bool;
	private var prevMode:Int;
	private var waitUp:Bool;
	
	public var mode(default,set):Int;
	public var change(default, null):Signal;
	public var changeVisual(default, null):Signal;
	public var click(default, null):Signal;
	public var tick(default, null):Signal;
	public var down(default, null):Signal;
	public var up(default, null):Signal;
	public var select(default, null):Signal;
	public var unselect(default, null):Signal;
	public var onMode(default, null):Signal;
	
	public var locked:Bool = false;
	
	public var sw(default, set):Array<Int>;
	
	public function new() {
		change = new Signal();
		changeVisual = new Signal();
		click = new Signal();
		tick = new Signal();
		down = new Signal();
		up = new Signal();
		onMode = new Signal();
		
		select = new Signal();
		unselect = new Signal();
		
		mouseState = Default;
		keyboardState = Default;
		tabState = Default;
		fakeState = Default;
		prevSummary = Default;
		prevVisual = Default;
		prevTab = false;
		prevMode = mode = 0;
		change.add(changeState);
		waitUp = false;
	}
	
	public function set_mode(v:Int):Int {
		mode = v;
		update();
		return mode;
	}
	
	public function mouseOver(btnDown:Bool):Void {
		//if (locked) return;
		switch (mouseState) {
			case Default:
				if (!btnDown) {
					mouseState = Focus;
					update();
				} else {
					waitUp = true;
				}
			case Leave:
				mouseState = Press;
				update();
			default:
		}
	}
	
	public function mouseOut():Void {
		//if (locked) return;
		waitUp = false;
		switch (mouseState) {
			case Focus:
				mouseState = Default;
				update();
			case Press:
				mouseState = Leave;
				update();
			default:
		}
	}
	
	public function mouseUp():Void {
		if (locked) return;
		switch (mouseState) {
			case Default if (waitUp):
				mouseState = Focus;
				update();
			case Leave:
				mouseState = Default;
				update();
			case Press:
				mouseState = Focus;
				update();
			default:
		}
		waitUp = false;
	}
	
	public function mouseDown():Void {
		if (locked) return;
		if (mouseState != Focus) return;
		mouseState = Press;
		update();
	}
	
	public function setFocus():Void {
		if (locked) return;
		if (tabState != Default) return;
		tabState = Focus;
		update();
	}
	
	public function leaveFocus():Void {
		if (locked) return;
		if (tabState != Default) return;
		tabState = Default;
		update();
	}
	
	public function enterDown():Void {
		if (locked) return;
		if (tabState != Focus) return;
		tabState = Press;
		update();
	}
	
	public function enterUp():Void {
		if (locked) return;
		if (tabState != Press) return;
		tabState = Press;
		update();
	}
	
	public function keyDown():Void {
		if (locked) return;
		if (keyboardState != Default) return;
		keyboardState = Press;
	}
	
	public function keyUp():Void {
		if (locked) return;
		if (keyboardState != Press) return;
		keyboardState = Default;
	}
	
	private function get_summaryState():ButtonStates {
		return switch [mouseState, tabState, keyboardState] {
			case [Leave, a, b] if (a != Press && b != Press): Leave;
			case [_, _, Press] | [_, Press, _] | [Press, _, _]: Press;
			case [Focus, _, _]: Focus;
			default: Default;
		}
	}
	
	private function get_visualState():ButtonStates {
		return switch [summaryState, fakeState] {
			case [Press, _] | [_, Press]: Press;
			case _ if (mouseState == Focus && !MOUSE_FOCUS): Default;
			case [_, Focus] | [Focus, _]: Focus;
			case [Leave, _]: Leave;
			default: Default;
		}
	}
	
	private function update():Void {
		var f:Bool = false;
		var nt:Bool = tabState == Focus;
		if (prevTab != nt) {
			prevTab = nt;
			if (nt)
				select.dispatch();
			else
				unselect.dispatch();
			f = true;
		}
		var pmm:Bool = prevMode != mode;
		prevMode = mode;
		if (prevSummary != summaryState) {
			prevSummary = summaryState;
			change.dispatch(summaryState, mode);
		}
		if (prevVisual != visualState || f || pmm) {
			prevVisual = visualState;
			changeVisual.dispatch(visualState, mode, f);
		}
		if (pmm) {
			onMode.dispatch(mode);
		}
	}
	
	public inline function sendVisual():Void {
		changeVisual.dispatch(visualState, mode, false);//arg3???
	}
	
	private function changeState(event:Event):Void {
		switch [event.prev == null ? Default : event.prev.args[0], cast(event.args[0], ButtonStates)] {
			case [Press, s]:
				if (s != Leave) click.dispatch(mode);
				if (presser != null) presser.destroy();
				up.dispatch(mode);
			case [_, Press]:
				down.dispatch(mode);
				if (tick.haveListeners) {
					tick.dispatch(mode);
					presser = new Presser(tickListener);
					tickListener();
				}
			default:
		}
	}
	
	private function tickListener():Void tick.dispatch(mode);
	
	private function set_sw(a:Array<Int>):Array<Int> {
		if (sw != null) return sw;// throw 'sw setted';
		for (i in 0...a.length)
			click.sub(i).add(set_mode.bind(a[i]));
		return sw = a;
	}
	
	inline public function joinVisual(bc:ButtonCore):ButtonCore {
		changeVisual.join(bc.changeVisual);
		return this;
	}
	
	inline public function join(bc:ButtonCore):ButtonCore {
		change.join(bc.change);
		return joinVisual(bc);
	}
	
}