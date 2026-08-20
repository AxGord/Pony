package pony.flash.starling.ui;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;
import pony.flash.starling.converter.AtlasCreator;
import pony.flash.ui.Button;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.starling.touchManager.TouchManagerHandCursor;
import pony.ui.touch.Touchable;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;

using pony.flash.FLExtends;

/**
 * StarlingButton
 * @author Maletin
 * @author AxGord <axgord@gmail.com>
 */
class StarlingButton extends Sprite {

	public static var config = { def: 1, focus: 2, press: 3, zone: 4, disabled: 5 };

	public var core: ButtonImgN;

	private final mc: Array<MovieClip>;
	private final _hitArea: Rectangle;
	private final _framerate: Int;

	private var prev: Int = -1;
	private var _handCursor: TouchManagerHandCursor;

	public function new(textures: Array<MovieClip>, framerate: Int) {
		super();
		mc = textures;
		_framerate = framerate;
		final hitAreaFrame: Int = mc.length > config.zone - 1 ? config.zone : config.def;
		_hitArea = new Rectangle(mc[hitAreaFrame - 1].x, mc[hitAreaFrame - 1].y, mc[hitAreaFrame - 1].width, mc[hitAreaFrame - 1].height);
		gotoAndStop(config.def);
		core = new ButtonImgN(new Touchable(this));
		core.onImg << imgHandler;
		useHandCursor = true;
	}

	public inline function clone(): StarlingButton {
		final b: StarlingButton = new StarlingButton(mc, _framerate);
		b.x = x;
		b.y = y;
		return b;
	}

	override public function hitTest(localPoint: Point, forTouch: Bool = false): DisplayObject {
		// on a touch test, invisible or untouchable objects cause the test to fail
		// otherwise, check bounding box
		return if (forTouch && (!visible || !touchable))
			null
		else if (_hitArea.containsPoint(localPoint))
			this
		else
			null;
	}

	private function imgHandler(img: Int): Void {
		if (img == 4) {
			useHandCursor = false;
			gotoAndStop(5);
			return;
		}
		useHandCursor = true;

		gotoAndStop(img > 4 ? img + 1 : img);
	}

	private function gotoAndStop(frame: Int): Void {
		frame--;
		if (prev != -1) removeChild(mc[prev]);
		addChild(mc[frame]);
		mc[frame].currentFrame = 0;
		prev = frame;
	}

	public static function builder(
		atlasCreator: AtlasCreator, source: Button, coordinateSpace: flash.display.DisplayObject, disposeable: Bool = false
	): starling.display.DisplayObject {

		var mc: flash.display.MovieClip = cast source;
		final movies: Array<starling.display.MovieClip> = [];
		var j: Int = 0;
		for (i in 1...mc.totalFrames + 1) {
			mc.gotoAndStop(i);
			var clip: starling.display.MovieClip = null;
			final v: Vector<Texture> = new Vector<Texture>();
			for (o in mc.childrens()) if (Std.is(o, flash.display.MovieClip)) {

				var m: flash.display.MovieClip = cast o;

				var str = null;
				for (i in 1...m.totalFrames + 1) {
					m.gotoAndStop(i);
					final im = atlasCreator.addImage(source, coordinateSpace, disposeable, j++);
					v.push(im.texture);
					if (str == null) str = im.transformationMatrix;
				}
				clip = new starling.display.MovieClip(v, 60);
				clip.transformationMatrix = str;
				Starling.juggler.add(clip);
				clip.play();

				break;
			}
			if (clip == null) {
				final im = atlasCreator.addImage(source, coordinateSpace, disposeable, j++);
				v.push(im.texture);
				clip = new starling.display.MovieClip(v, 60);
				clip.transformationMatrix = im.transformationMatrix;
			}
			movies.push(clip);
		}
		final starlingChild: StarlingButton = new StarlingButton(movies, 60);

		final a = @:privateAccess source._sw;
		if (a != null) starlingChild.core.switchMap(a);
		if (@:privateAccess source._bsw) starlingChild.core.bswitch();

		return starlingChild;
	}

}
