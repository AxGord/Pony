/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pony.geom.Border;
import pony.geom.Point;
import pony.pixi.ETextStyle;
import pony.time.DTimer;
import pony.time.Time;
import pony.time.TimeInterval;

/**
 * TimeBar
 * @author AxGord <axgord@gmail.com>
 */
class TimeBar extends LabelBar {
	
	public var timer:DTimer;
	private var ignoreBeginAnimation:Bool = false;
	
	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?border:Border<Int>,
		?style:ETextStyle,
		shadow:Bool = false,
		invert:Bool = false,
		useSpriteSheet:Bool = false,
		creep:Float = 0
	) {
		labelInitVisible = false;
		super(bg, fillBegin, fill, animation, animationSpeed, border, style, shadow, invert, useSpriteSheet, creep);
		timer = DTimer.createFixedTimer(null);
		onReady < timerInit;
	}
	
	private function timerInit(p:Point<Int>):Void {
		timer.progress << progressHandler;
		timer.update << updateHandler;
		timer.complete.add(startAnimation, -10);
		text = '00:00';
		if (!ignoreBeginAnimation) startAnimation();
	}
	
	private function progressHandler(p:Float):Void core.percent = p;
	private function updateHandler(t:Time):Void text = t.showMinSec();
	
	public function start(t:TimeInterval, ?cur:Time):Void {
		ignoreBeginAnimation = true;
		stopAnimation();
		timer.time = t;
		timer.reset();
		if (cur != null) timer.currentTime = cur;
		timer.start();
	}
	
	@:extern inline public function pause():Void timer.stop();
	@:extern inline public function play():Void timer.start();
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		timer.destroy();
		timer = null;
		super.destroy(options);
	}
	
}