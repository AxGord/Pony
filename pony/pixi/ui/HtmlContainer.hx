package pony.pixi.ui;

import js.html.CSSStyleDeclaration;
import pixi.core.display.DisplayObject;
import pony.pixi.HtmlContainerBase;
import pony.geom.Rect;
import pony.geom.Point;

using pony.pixi.PixiExtends;

/**
 * HtmlContainer
 * @author AxGord <axgord@gmail.com>
 */
class HtmlContainer extends pixi.core.sprites.Sprite implements pony.geom.IWH {

	public var element:js.html.Element;
	public var size(get, never):Point<Float>;
	public var targetStyle(get, set):CSSStyleDeclaration;

	public var htmlContainer(default, null):HtmlContainerBase;
	private var targetRect(get, set):Rect<Float>;
	private var _size:Point<Float>;

	public function new(targetRect:Rect<Float>, ?app:pony.pixi.App, ceil:Bool = false, fixed:Bool = false) {
		super();
		//var g = new pixi.core.graphics.Graphics();
		//g.beginFill(0x0);
		//g.drawRect(0, 0, targetRect.width, targetRect.height);
		//addChild(g);
		_size = new Point(targetRect.width, targetRect.height);
		htmlContainer = new HtmlContainerBase(targetRect, app, ceil, fixed);
		pony.time.DeltaTime.fixedUpdate < posUpdate;
		pony.time.DeltaTime.skipUpdate(posUpdate);
	}

	public function wait(f:Void -> Void):Void f();

	public function posUpdate():Void {
		var gx:Float = 0;
		var gy:Float = 0;
		var p:DisplayObject = parent;
		while (p.parent.parent != null) {
			gx += p.x;
			gy += p.y;
			p = p.parent;
		}
		htmlContainer.targetPos = new Point(gx, gy);
	}
	
	@:extern private inline function get_targetStyle():CSSStyleDeclaration return htmlContainer.targetStyle;
	@:extern private inline function set_targetStyle(v:CSSStyleDeclaration):CSSStyleDeclaration return htmlContainer.targetStyle = v;
	@:extern private inline function get_targetRect():Rect<Float> return htmlContainer.targetRect;
	@:extern private inline function set_targetRect(r:Rect<Float>):Rect<Float> return htmlContainer.targetRect = r;
	@:extern private inline function get_size():Point<Float> return _size;

	public function destroyIWH():Void destroy();

}