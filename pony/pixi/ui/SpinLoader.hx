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

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pony.geom.IWH;
import pony.geom.Point;
import pony.color.UColor;
import pony.time.Tween;
import pony.ui.gui.SmoothBarCore;

class SpinLoader extends Sprite implements IWH {

	public var core(default, null):SmoothBarCore;
	public var size(get, never):Point<Float>;

	private var _size:Point<Float>;
	private var app:App;
	private var renderTexture:RenderTexture;
	private var graphics:Graphics = new Graphics();
	private var trackRadius:Int;
	private var circleRadius:Int;
	private var steps:Int;
	private var prevStep:Int = 0;
	private var pulse:Tween = new Tween(1...0, TweenType.Square, 1000, false, true, true, true);

	public function new(trackRadius:Int, circleRadius:Int, color:UColor, ?app:App) {
		steps = Std.int(trackRadius / Math.sqrt(circleRadius) * 3);
		core = new SmoothBarCore(steps);
		var w:Int = (trackRadius + circleRadius) * 2;
		_size = new Point<Float>(w, w);
		this.app = app == null ? App.main : app;
		this.trackRadius = trackRadius;
		this.circleRadius = circleRadius;
		renderTexture = RenderTexture.create(w, w);
		super(renderTexture);
		core.smoothChangeX = changeHandler;

		graphics.beginFill(color);
		graphics.drawCircle(0, 0, circleRadius);

		core.smooth = true;
		core.endInit();

		pulse.onUpdate << pulseHandler;
	}

	private function get_size():Point<Float> return _size;
	public function wait(cb:Void -> Void):Void cb();
	public function destroyIWH():Void destroy();
	private function pulseHandler(v:Float):Void alpha = v;
	public inline function startPulse():Void pulse.play();
	public inline function stopPulse():Void pulse.stopOnBegin();

	public function changeHandler(v:Float):Void {
		var current:Int = Std.int(v);
		for (i in prevStep...current) draw(i / steps);
		if (current != v) draw(v / steps);
		prevStep = current;
	}

	private inline function draw(n:Float):Void {
		var angle:Float = n * Math.PI * 2;
		graphics.x = trackRadius * Math.cos(angle) + trackRadius + circleRadius;
		graphics.y = trackRadius * Math.sin(angle) + trackRadius + circleRadius;
		app.app.renderer.render(graphics, renderTexture, false);
	}

}