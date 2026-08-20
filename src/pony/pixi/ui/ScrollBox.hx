package pony.pixi.ui;

import pixi.core.Pixi;
import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.ScrollBoxCore;
import pony.ui.touch.Touchable;

/**
 * ScrollBox
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBox extends Sprite implements HasSignal implements IWH {

	public var size(get, never): Point<Float>;

	private final core: ScrollBoxCore;

	private var content: Sprite = new Sprite();
	private var touchArea: Sprite = new Sprite();
	private var vbar: Sprite;
	private var hbar: Sprite;

	public function new(
		w: Float, h: Float, vert: Bool = true, hor: Bool = false, color: UInt = 0, barsize: Float = 8, wheelSpeed: Float = 1
	) {
		super();
		final tag = new Graphics();
		tag.beginFill(0, 0);
		tag.drawRect(0, 0, 1, 1);
		touchArea.addChild(tag);
		content.addChild(touchArea);

		final g = new Graphics();
		g.beginFill(0x606060);
		g.drawRect(0, 0, 1, 1);
		addChild(g);

		addChild(content);
		content.mask = g;

		var vbutton: ButtonCore = null;
		if (vert) {
			final gvbar = new Graphics();
			gvbar.beginFill(color);
			gvbar.drawRect(0, 0, 1, 1);
			vbar = new Sprite();
			vbar.alpha = 0.7;
			vbar.addChild(gvbar);
			addChild(vbar);
			vbutton = new ButtonCore(new Touchable(vbar));
			vbutton.onVisual << vvisualHandler;
		}

		var hbutton: ButtonCore = null;
		if (hor) {
			final ghbar = new Graphics();
			ghbar.beginFill(color);
			ghbar.drawRect(0, 0, 1, 1);
			hbar = new Sprite();
			hbar.alpha = 0.7;
			hbar.addChild(ghbar);
			addChild(hbar);
			hbutton = new ButtonCore(new Touchable(hbar));
			hbutton.onVisual << hvisualHandler;
		}

		core = new ScrollBoxCore(w, h, new Touchable(content), vbutton, hbutton, barsize, wheelSpeed);
		if (vert) {
			core.onHideScrollVert << hideVBar;
			core.onScrollVertSize << showVBar;
			core.onScrollVertSize << vbar.scale.set;
			core.onScrollVertPos << vbar.position.set;
		}
		if (hor) {
			core.onHideScrollVert << hideHBar;
			core.onScrollVertSize << showHBar;
			core.onScrollVertSize << hbar.scale.set;
			core.onScrollVertPos << hbar.position.set;
		}
		core.onContentPos << content.position.set;
		core.onMaskSize << g.scale.set;
		core.onMaskSize << maximizeTouchArea;
	}

	private function get_size(): Point<Float> return new Point<Float>(core.w, core.h);

	public inline function needUpdate(): Void {
		DeltaTime.fixedUpdate < update;
	}

	public function add(c: DisplayObject): Void {
		content.addChild(c);
		needUpdate();
	}

	public function update(): Void {
		touchArea.visible = false;
		final b = content.getBounds();
		core.content(b.x + b.width, b.y + b.height);
		touchArea.visible = true;
	}

	public function wait(fn: Void -> Void): Void fn();

	public function destroyIWH(): Void destroy();

	private function maximizeTouchArea(mw: Float, mh: Float): Void {
		final b = content.getLocalBounds();
		touchArea.scale.set(b.x + b.width, b.y + b.height);
		if (touchArea.scale.x < mw) touchArea.scale.x = mw;
		if (touchArea.scale.y < mh) touchArea.scale.y = mh;
	}

	private function vvisualHandler(_, state: ButtonState): Void {
		vbar.alpha = state == ButtonState.Default ? 0.7 : 1;
	}

	private function hvisualHandler(_, state: ButtonState): Void {
		hbar.alpha = state == ButtonState.Default ? 0.7 : 1;
	}

	private function showVBar(): Void vbar.visible = true;

	private function hideVBar(): Void vbar.visible = false;

	private function showHBar(): Void hbar.visible = true;

	private function hideHBar(): Void hbar.visible = false;

}
