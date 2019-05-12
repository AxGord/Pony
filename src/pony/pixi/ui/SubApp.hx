package pony.pixi.ui;

import pixi.core.sprites.Sprite;
import pony.geom.Rect;
import pony.time.DeltaTime;

/**
 * SubApp
 * @author AxGord <axgord@gmail.com>
 */
class SubApp extends HtmlContainer {

	public var content:Sprite = new Sprite();
	public var subApp(default, null):App;

	public function new(targetRect:Rect<Int>, ?app:pony.pixi.App, ceil:Bool = false, fixed:Bool = false) {
		super(targetRect, app, ceil, fixed);
	}

	public function init():Void {
		element.style.pointerEvents = 'none';
		subApp = new App(
			content,
			Std.int(targetRect.width),
			Std.int(targetRect.height),
			element,
			true,
			{
				transparent: true,
				forceCanvas: true
			}
		);
	}

}