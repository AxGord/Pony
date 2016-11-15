/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.pixi.ui;

import pixi.core.Pixi;
import pixi.core.sprites.Sprite;
import pony.Or;
import pony.events.Signal1;
import pony.events.WaitReady;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.ui.gui.SmoothBarCore;

using pony.pixi.PixiExtends;

/**
 * Bar
 * @author AxGord <axgord@gmail.com>
 */
class Bar extends Sprite implements HasSignal implements IWH {
	
	public var core:SmoothBarCore;
	@:auto public var onReady:Signal1<Point<Int>>;
	
	private var _wait:WaitReady = new WaitReady();
	public var size(get, never):Point<Float>;
	
	private var bg:Or<Sprite, Point<Int>>;
	private var begin:Sprite;
	private var end:Sprite;
	private var fill:Sprite;
	private var invert:Bool = false;
	private var creep:Float;
	private var smooth:Bool;

	public function new(
		bg:Or<String, Point<Int>>,
		fillBegin:String,
		fill:String,
		?offset:Point<Int>,
		invert:Bool = false,
		useSpriteSheet:Bool = false,
		creep:Float = 0,
		smooth:Bool = false
	) {
		super();
		this.invert = invert;
		this.creep = creep;
		this.smooth = smooth;
		var loadList = switch bg {
			case OrState.A(v):
				var s = PixiAssets.cImage(v, useSpriteSheet);
				addChild(s);
				this.bg = s;
				[s];
			case OrState.B(v):
				this.bg = v;
				[];
		}
		begin = PixiAssets.cImage(fillBegin, useSpriteSheet);
		addChild(begin);
		this.fill = PixiAssets.cImage(fill, useSpriteSheet);
		this.fill.texture.baseTexture.scaleMode = Pixi.SCALE_MODES.NEAREST;
		addChild(this.fill);
		if (useSpriteSheet)
			DeltaTime.fixedUpdate < init;
		else
			loadList.concat([begin, this.fill]).loadedList(DeltaTime.notInstant(init));
		if (offset != null) {
			this.fill.x = begin.x = offset.x;
			this.fill.y = begin.y = offset.y;
		}
		
		onReady.add(_wait.ready, 10);
	}
	
	inline public function wait(cb:Void->Void):Void _wait.wait(cb);
	
	private function get_size():Point<Float> {
		return switch bg {
			case OrState.A(v): new Point(v.width, v.height);
			case OrState.B(v): cast v;
		}
	}
	
	private function init():Void {
		end = new Sprite(begin.texture);
		end.x = begin.x;
		end.y = begin.y;

		addChild(end);
		var size = switch bg {
			case OrState.A(v): new Point<Int>(Std.int(v.width), Std.int(v.height));
			case OrState.B(v): v;
		}
		core = SmoothBarCore.create(size.x - (begin.x + begin.width) * 2, size.y - (begin.y + begin.height) * 2, invert);
		core.smooth = smooth;
		if (core.isVertical) {
			end.height = -end.height;
			fill.y = begin.y + begin.height - creep;
		} else {
			end.width = -end.width;
			fill.x = begin.x + begin.width - creep;
		}
		if (smooth) {
			core.smoothChangeX= changeXHandler;
			core.smoothChangeY = changeYHandler;
		} else {
			core.changeX = changeXHandler;
			core.changeY = changeYHandler;
		}
		
		core.endInit();
		eReady.dispatch(size);
		eReady.destroy();
	}
	
	private function changeXHandler(p:Float) {
		fill.width = p + creep * 2;
		end.x = fill.x + fill.width + begin.width - creep;
	}
	
	private function changeYHandler(p:Float) {
		fill.height = p + creep * 2;
		end.y = fill.y + fill.height + begin.height - creep;
	}

	override public function destroy():Void {
		core.destroy();
		core = null;
		destroySignals();
		switch bg {
			case OrState.A(v):
				removeChild(v);
				v.destroy();
			case _:
		}
		bg = null;
		removeChild(begin);
		begin.destroy();
		begin = null;
		removeChild(fill);
		fill.destroy();
		fill = null;
		if (end != null) {
			removeChild(end);
			end.destroy();
			end = null;
		}
		super.destroy();
	}
	
}