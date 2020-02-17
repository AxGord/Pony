package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ds.ROArray;
import pony.pixi.ui.slices.SliceSprite;
import pony.pixi.ui.slices.SliceTools;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;
import pony.events.WaitReady;

using pony.pixi.PixiExtends;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
class Button extends Sprite implements IWH {

	public var core(default, null): ButtonImgN;
	public var size(get, never): Point<Float>;

	private var hideDisabled: Bool;

	public var touchActive(get, set): Bool;
	public var cursor(get, set): Bool;

	private var list: Array<SliceSprite>;
	private var zone: SliceSprite;
	private var prev: Int = 0;
	private var wr: WaitReady;

	public function new(imgs: ROArray<String>, ?offset: Point<Float>, ?useSpriteSheet: String) {
		var imgs = imgs.copy();
		wr = new WaitReady();
		if (imgs[0] == null)
			throw 'Need first img';
		if (imgs[1] == null)
			imgs[1] = imgs[2] != null ? imgs[2] : imgs[0];
		if (imgs[2] == null)
			imgs[2] = imgs[1];

		var z = imgs.length > 3 ? imgs.splice(3, 1)[0] : null;
		if (z == null)
			z = imgs[0];
		hideDisabled = imgs[3] == null;
		var i = 4;
		while (i < imgs.length) {
			if (imgs[i + 1] == null)
				imgs[i + 1] = imgs[i + 2] != null ? imgs[i + 2] : imgs[i];
			if (imgs[i + 2] == null)
				imgs[i + 2] = imgs[i + 1];
			i += 3;
		}
		list = [for (img in imgs) img == null ? null : getImg(img, useSpriteSheet)];
		if (offset != null) {
			for (e in list)
				if (e != null) {
					e.x = -offset.x;
					e.y = -offset.y;
				}
		}
		super();
		zone = getInteractiveImg(z, useSpriteSheet);
		if (useSpriteSheet != null)
			wr.ready();
		else
			zone.texture.loaded(wr.ready);
		addChild(zone);
		zone.buttonMode = true;
		zone.alpha = 0;
		core = new ButtonImgN(new Touchable(zone));
		core.onImg << imgHandler;
		core.onDisable << disableHandler;
		core.onEnable << enableHandler;
		addChild(list[0]);
	}

	public function setWidth(v: Float): Void {
		zone.sliceWidth = v;
		for (img in list)
			img.sliceWidth = v;
	}

	public function setHeight(v: Float): Void {
		zone.sliceHeight = v;
		for (img in list)
			img.sliceHeight = v;
	}

	@:extern inline private static function getInteractiveImg(img: String, useSpriteSheet: String): SliceSprite {
		return SliceTools.getSliceSprite(img, useSpriteSheet);
	}

	private static function getImg(img: String, useSpriteSheet: String): SliceSprite {
		var s = getInteractiveImg(img, useSpriteSheet);
		s.interactive = false;
		s.interactiveChildren = false;
		return s;
	}

	private function disableHandler(): Void cursor = false;

	private function enableHandler(): Void cursor = true;

	public inline function wait(cb: Void -> Void): Void wr.wait(cb);

	private inline function get_size(): Point<Float> return new Point(zone.sliceWidth, zone.sliceHeight);

	private function imgHandler(n: Int): Void {
		if (n == 4 && hideDisabled) {
			visible = false;
			return;
		} else {
			visible = true;
		}
		if (prev != -1)
			removeChild(list[prev]);
		addChild(list[prev = n - 1]);
	}

	override public function destroy(?options: haxe.extern.EitherType<Bool, DestroyOptions>): Void {
		core.destroy();
		core = null;
		for (e in list) {
			removeChild(e);
			e.destroy();
		}
		list = null;
		removeChild(zone);
		zone.destroy();
		zone = null;
		wr = null;
		super.destroy(options);
	}

	private inline function get_cursor(): Bool return zone.buttonMode;
	private inline function set_cursor(v: Bool): Bool return zone.buttonMode = v;

	private inline function get_touchActive(): Bool return zone.interactive;
	private inline function set_touchActive(v: Bool): Bool return zone.interactive = v;

	public function destroyIWH(): Void destroy();

}