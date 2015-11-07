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
package pony.flash.ui;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import pony.events.*;
import pony.flash.FLSt;
import pony.flash.FLTools;
import pony.IPercent;
import pony.magic.ExtendedProperties;
import pony.math.MathTools;
import pony.time.DeltaTime;
import pony.time.DT;
import pony.time.DTimer;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.ButtonCore.ButtonStates;
import pony.ui.gui.SlideCore;

/**
 * Fader
 * @author AxGord <axgord@gmail.com>
 */
class Fader extends Sprite implements FLSt implements ExtendedProperties {

	@st private var value:TextField;
	@st private var button:Button;
	@st private var bar:MovieClip;
	
	public var percent(_, set):Null<Float>;
	public var percentRT(default, null):Float;
	
	public var change:Signal1<Fader, Float>;
	public var changeRT:Signal1<Fader, Float>;
	
	public var animationSpeed:Float = 5;
	
	public var enabled(get, set):Bool;
	
	private var barSize:Float;
	private var vald:Float;
	private var startPos:Float;
	private var asy:Float;
	private var alph:SlideCore;
	private var yBeforePress:Float;
	private var lt:DTimer;
	
	public function new() {
		super();
		change = Signal.create(this);
		changeRT = Signal.create(this);
		alph = new SlideCore(1,5);
		FLTools.init < init;
	}
	
	private function init():Void {
		barSize = bar.height;
		bar.stop();
		vald = value.y - button.y;
		startPos = y;
		value.mouseEnabled = false;
		button.core.change.sub(ButtonStates.Press).add(mOn);
		stage.addEventListener(MouseEvent.MOUSE_UP, mOff);
		stage.addEventListener(Event.MOUSE_LEAVE, mOff);
		change << startAnimation;
		if (percent == null) set_percent(0);
		alph.update.add(function(v:Float) bar.alpha = 1 - v);
		bar.alpha = 0;
		alph.open();
		button.addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
	}
	
	private function get_enabled():Bool return visible;
	private function set_enabled(v:Bool):Bool {
		visible = v;
		return v;
	}
	
	
	private function wheel(event:MouseEvent):Void {
		if (event.delta > 0) {
			set_percent(percent + 0.05);
		} else {
			set_percent(percent - 0.05);
		}
	}
	
	private var mActive:Bool = false;
	
	private function mOn():Void {
		if (mActive) return;
		mActive = true;
		if (!enabled) return;
		destroyTimer();
		parent.setChildIndex(this, parent.numChildren-1);
		button.removeEventListener(MouseEvent.MOUSE_WHEEL, wheel);
		DeltaTime.fixedUpdate << update;
		alph.close();
		yBeforePress = button.y;
	}
	
	private function mOff(_):Void {
		if (!mActive) return;
		mActive = false;
		if (!enabled) return;
		button.addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
		DeltaTime.fixedUpdate >> update;
		if (percent != percentRT) change.dispatch(percent = percentRT);
		if (yBeforePress == button.y) {
			startHideBar();
		}
	}
	
	private function destroyTimer():Void {
		if (lt != null) {
			lt.destroy();
			lt = null;
		}
	}
	
	private function startHideBar():Void {
		destroyTimer();
		lt = DTimer.fixedDelay(500, alph.open.bind(null));
	}
	
	private function update():Void {
		var pos:Float = MathTools.limit(bar.mouseY, 0, barSize);
		percentRT = (barSize-pos) / barSize;
		bar.gotoAndStop(bar.totalFrames - Math.ceil(percentRT * bar.totalFrames));
		value.text = Std.string(Math.ceil(percentRT * 100)) + '%';
		button.y = pos - button.height / 2;
		value.y = button.y + vald;
		changeRT.dispatch(percentRT);
	}
	
	inline private function set_percent(v:Float):Float {
		if (v < 0) v = 0;
		else if (v > 1) v = 1;
		percentRT = v;
		var pos:Float = barSize - barSize * percentRT;
		bar.gotoAndStop(bar.totalFrames - Math.ceil(percentRT * bar.totalFrames));
		value.text = Std.string(Math.ceil(percentRT * 100)) + '%';
		button.y = pos - button.height / 2;
		value.y = button.y + vald;
		changeRT.dispatch(percentRT);
		trace(v);
		change.dispatch(percent = v);
		return v;
	}
	
	private function moveButton(pos:Float):Void {
		button.y = pos;
	}
	
	private function startAnimation():Void {
		trace('startAnimation');
		asy = y;
		DeltaTime.fixedUpdate.add(y < startPos - button.y ? animationDown : animationUp);
		startHideBar();
	}
	
	private function animationDown(dt:DT):Void {
		var total = startPos - button.y;
		y += animationD() * dt;
		if (y >= total) {
			y = total;
			DeltaTime.fixedUpdate >> animationDown;
		}
	}
	
	private function animationUp(dt:DT):Void {
		var total = startPos - button.y;
		y -= animationD() * dt;
		if (y <= total) {
			y = total;
			DeltaTime.fixedUpdate >> animationUp;
		}
	}
	
	private function animationD():Float return (bar.height / 10 + Math.abs(Math.abs(startPos - button.y) - Math.abs(y))) * animationSpeed;
	
}