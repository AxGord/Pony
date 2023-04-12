package pony.pixi;

import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pony.Or;
import pony.time.DT;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.time.Time;
import pony.ui.gui.AnimTextureCore;
import pony.math.MathTools;
import pony.magic.HasAbstract;

using pony.pixi.PixiExtends;

/**
 * FastMovieClip
 * @author AxGord <axgord@gmail.com>
 */
class FastMovieClip extends AnimTextureCore {

	private static var storage:Map<String, FastMovieClip> = new Map();

	private var pool:Array<Sprite> = [];
	private var data:Array<Pair<Rectangle, Rectangle>>;
	public var texture(default, null):Array<Texture>;
	private var crop:Int;

	public function new(
		data:Or<Array<Texture>, Array<String>>,
		frameTime:Time,
		fixedTime:Bool = false,
		smooth:AnimSmoothMode = AnimSmoothMode.None,
		additionalSrc:UInt = 0,
		crop:Int = 0
	) {
		super(frameTime, fixedTime, smooth, additionalSrc);
		var data = converOr(data);
		texture = data.splice(0, (smooth:Int) + additionalSrc + (additionalSrc == 1 && smooth == AnimSmoothMode.Simple && data.length % 2 == 1 ? 1 : 0));
		this.crop = crop;
		this.data = [for (t in texture) new Pair(t.trim, t.frame)];
		for (t in data) {
			this.data.push(new Pair(t.trim, t.frame));
			t.destroy();
		}
	}

	public static function fromStorage(
		data:Or<Array<Texture>, Array<String>>,
		frameTime:Time,
		fixedTime:Bool = false,
		smooth:AnimSmoothMode = AnimSmoothMode.None,
		crop:Int = 0):FastMovieClip
	{
		var n = idFromTexture(converOrFirst(data));
		if (!storage.exists(n)) {
			return storage[n] = new FastMovieClip(data, frameTime, fixedTime, smooth, crop);
		} else {
			return storage[n];
		}
	}

	@:extern public static inline function fromSprite(s:Sprite):FastMovieClip return fromTexture(s.texture);
	@:extern public static inline function fromTexture(t:Texture):FastMovieClip return storage[idFromTexture(t)];
	@:extern private static inline function idFromTexture(t:Texture):String return t.baseTexture.imageUrl + '_' + t.frame.x + '_' + t.frame.y;

	@:extern private static inline function converOr(data:Or<Array<Texture>, Array<String>>):Array<Texture> {
		return switch data {
			case OrState.A(t): t;
			case OrState.B(s): [for (e in s) Texture.fromFrame(e)];
		};
	}

	@:extern private static inline function converOrFirst(data:Or<Array<Texture>, Array<String>>):Texture {
		return switch data {
			case OrState.A(t): t[0];
			case OrState.B(s): Texture.fromFrame(s[0]);
		};
	}

	public function get():Sprite {
		return if (pool.length > 0) {
			pool.pop();
		} else {
			if (additionalSrc == 0) switch smooth {
				case AnimSmoothMode.None:
					new Sprite(texture[0]);
				case AnimSmoothMode.Simple:
					var r = new FastMoviePlaySpriteSimple(texture, totalFrames);
					timer.progress << r.progress;
					onFrame.add(r.frame, -1);
					r;
				case AnimSmoothMode.Super:
					var r = new FastMoviePlaySpriteSuper(texture, totalFrames);
					timer.progress << r.progress;
					onFrame.add(r.frame, -1);
					r;
			} else switch smooth {
				case AnimSmoothMode.None:
					var r = new FastMoviePlaySpriteNone(texture, totalFrames);
					onFrame.add(r.frame, -1);
					r;
				case AnimSmoothMode.Simple:
					var r = new FastMoviePlaySpriteOddSimple(texture, totalFrames);
					timer.progress << r.progress;
					onFrame.add(r.frame, -1);
					r;
				case AnimSmoothMode.Super:
					var r = new FastMoviePlaySpriteOddSuper(texture, totalFrames);
					timer.progress << r.progress;
					onFrame.add(r.frame, -1);
					r;
			}
		}
	}

	@:extern public inline function ret(s:Sprite):Void pool.push(s);

	override private function setTexture(n:Int, f:Int):Void setTextureFrame(texture[n], f);

	private function setTextureFrame(t:Texture, n:Int):Void {
		t.trim = data[n].a;
		var r = data[n].b;
		t.frame = r;
		if (crop > 0) {
			if (t.trim == null)
				t.trim = new Rectangle(-crop, -crop, r.width + crop * 2, r.height + crop * 2);
			else
				t.trim = new Rectangle(t.trim.x - crop, t.trim.y - crop, t.trim.width + crop * 2, t.trim.height + crop * 2);
		}
	}

	override public function destroy():Void {
		super.destroy();

		for (s in pool) s.destroy();
		pool = null;

		var n = texture[0].baseTexture.imageUrl;
		storage.remove(n);
		for (t in texture) t.destroy(true);
		texture = null;
		data = null;
	}

	override private function get_totalFrames():Int return data.length;

}

#if (haxe_ver >= 4.2) abstract #end
class FastMoviePlaySprite extends Sprite implements HasAbstract {

	private var count:Int;
	private var sprites:Array<Sprite>;

	public function new(texture:Array<Texture>, count:Int) {
		this.count = count;
		sprites = [for (t in texture) new Sprite(t)];
		super();
		frame(0);
	}

	public function pcenter():Void for (s in sprites) s.pivotCenter();

	@:abstract public function frame(n:Int):Void;
	@:abstract public function progress(v:Int):Void;

	@:extern private inline function remAll():Void {
		while (children.length > 0) removeChildAt(0);
	}

}

class FastMoviePlaySpriteNone extends FastMoviePlaySprite {

	public function new(texture:Array<Texture>, count:Int) {
		super(texture, count);
		addChild(sprites[0]);
		addChild(sprites[1]);
	}

	#if (haxe_ver < 4.2) override #end
	public function frame(n:Int):Void {
		sprites[n % 2].visible = true;
		sprites[1 - n % 2].visible = false;
	}

	#if (haxe_ver < 4.2) override #end
	public function progress(v:Float):Void {}

}

class FastMoviePlaySpriteSimple extends FastMoviePlaySprite {

	#if (haxe_ver < 4.2) override #end
	public function frame(n:Int):Void {
		remAll();
		addChild(sprites[n % 2]);
		addChild(sprites[1 - n % 2]);
		children[0].alpha = 1;
		children[1].alpha = 0;
	}

	#if (haxe_ver < 4.2) override #end
	public function progress(v:Float):Void children[1].alpha = v;

}

class FastMoviePlaySpriteOddSimple extends FastMoviePlaySprite {

	#if (haxe_ver < 4.2) override #end
	public function frame(n:Int):Void {
		remAll();
		for (e in MathTools.clipSmoothOddPlanSimple(n, count))
			addChild(sprites[e]);
		children[0].alpha = 1;
		children[1].alpha = 0;
	}

	#if (haxe_ver < 4.2) override #end
	public function progress(v:Float):Void children[1].alpha = v;

}

class FastMoviePlaySpriteSuper extends FastMoviePlaySprite {

	#if (haxe_ver < 4.2) override #end
	public function frame(n:Int):Void {
		remAll();
		for (i in 0...3) addChild(sprites[i]);
		children[0].alpha = 0.5;
		children[1].alpha = 1;
		children[2].alpha = 0;
	}

	#if (haxe_ver < 4.2) override #end
	public function progress(v:Float):Void {
		children[0].alpha = (1 - v) / 2;
		children[2].alpha = v / 2;
	}

}

class FastMoviePlaySpriteOddSuper extends FastMoviePlaySprite {

	#if (haxe_ver < 4.2) override #end
	public function frame(n:Int):Void {
		remAll();
		for (e in MathTools.clipSmoothOddPlan(n, count))
			addChild(sprites[e]);
		children[0].alpha = 0.5;
		children[1].alpha = 1;
		children[2].alpha = 0;
	}

	#if (haxe_ver < 4.2) override #end
	public function progress(v:Float):Void {
		children[0].alpha = (1 - v) / 2;
		children[2].alpha = v / 2;
	}

}