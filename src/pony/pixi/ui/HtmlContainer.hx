package pony.pixi.ui;

import js.html.CSSStyleDeclaration;
import js.html.Element;
import pixi.core.display.DisplayObject;
import pixi.core.sprites.Sprite;
import pony.pixi.HtmlContainerBase;
import pony.geom.Rect;
import pony.geom.Point;
import pony.geom.IWH;
import pony.time.DeltaTime;

using pony.pixi.PixiExtends;

/**
 * HtmlContainer
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class HtmlContainer extends Sprite implements IWH {

	public var element: Element;
	public var size(get, never): Point<Float>;
	public var targetStyle(get, set): CSSStyleDeclaration;

	public var htmlContainer(default, null): HtmlContainerBase;
	public var hidden(default, set): Bool = false;

	private var targetRect(get, set): Rect<Float>;
	private var _size: Point<Float>;

	public function new(targetRect: Rect<Float>, ?app: App, ceil: Bool = false, fixed: Bool = false) {
		super();
		// var g = new pixi.core.graphics.Graphics();
		// g.beginFill(0x0);
		// g.drawRect(0, 0, targetRect.width, targetRect.height);
		// addChild(g);
		_size = new Point(targetRect.width, targetRect.height);
		htmlContainer = new HtmlContainerBase(targetRect, app, ceil, fixed);
		DeltaTime.fixedUpdate < posUpdate;
		DeltaTime.skipUpdate(posUpdate);
	}

	public function set_hidden(value: Bool): Bool {
		if (value != hidden) {
			hidden = value;
			htmlContainer.posUpdater.enabled = !value;
			element.style.display = value ? 'none' : 'block';
		}
		return value;
	}

	public function wait(f: Void -> Void): Void f();

	public function posUpdate(): Void {
		var gx: Float = 0;
		var gy: Float = 0;
		var p: DisplayObject = parent;
		while (p.parent.parent != null) {
			gx += p.x;
			gy += p.y;
			p = p.parent;
		}
		htmlContainer.targetPos = new Point(gx, gy);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_targetStyle(): CSSStyleDeclaration return htmlContainer.targetStyle;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_targetStyle(v: CSSStyleDeclaration): CSSStyleDeclaration return htmlContainer.targetStyle = v;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_targetRect(): Rect<Float> return htmlContainer.targetRect;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_targetRect(r: Rect<Float>): Rect<Float> return htmlContainer.targetRect = r;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_size(): Point<Float> return _size;

	public function destroyIWH(): Void destroy();

}