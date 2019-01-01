package pony.pixi.ui;

import pixi.core.Pixi;
import pixi.core.display.DisplayObject.DestroyOptions;
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
	
	private var barContainter:Sprite;
	private var bg:Or<Sprite, Point<Int>>;
	private var begin:Sprite;
	private var end:Sprite;
	private var fill:Sprite;
	private var invert:Bool = false;
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
		barContainter = new Sprite();
		addChild(barContainter);
		begin = PixiAssets.cImage(fillBegin, useSpriteSheet);
		if (useSpriteSheet) TextureCut.apply(begin.texture, creep);
		barContainter.addChild(begin);
		this.fill = PixiAssets.cImage(fill, useSpriteSheet);
		if (useSpriteSheet) TextureCut.apply(this.fill.texture, creep);
		//this.fill.texture.baseTexture.scaleMode = 1;
		barContainter.addChild(this.fill);
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

		barContainter.addChild(end);
		var size = switch bg {
			case OrState.A(v): new Point<Int>(Std.int(v.width), Std.int(v.height));
			case OrState.B(v): v;
		}
		core = SmoothBarCore.create(size.x - (begin.x + begin.width) * 2, size.y - (begin.y + begin.height) * 2, invert);
		core.smooth = smooth;
		if (core.isVertical) {
			end.height = -end.height;
			fill.y = begin.y + begin.height;
		} else {
			end.width = -end.width;
			fill.x = begin.x + begin.width;
		}
		if (smooth) {
			core.smoothChangeX = changeXHandler;
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
		fill.width = p;
		end.x = fill.x + fill.width + begin.width;
	}
	
	private function changeYHandler(p:Float) {
		fill.height = p;
		end.y = fill.y + fill.height + begin.height;
	}

	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
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
		super.destroy(options);
	}
	
	public function destroyIWH():Void destroy();
	
}