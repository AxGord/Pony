package pony.pixi.ui;

import pixi.core.sprites.Sprite;
import pony.geom.Rect;
import pony.time.DeltaTime;

/**
 * SubApp
 * @author AxGord <axgord@gmail.com>
 */
class SubApp extends HtmlContainer {

	public var content: Sprite = new Sprite();
	public var subApp(default, null): App;

	public function new(targetRect: Rect<Int>, ?app: App, ceil: Bool = false, fixed: Bool = false) {
		super(targetRect, app, ceil, fixed);
	}

	public function init(): Void {
		element.style.pointerEvents = 'none';
		subApp = new App(content, Std.int(targetRect.width), Std.int(targetRect.height), element, false, {
			transparent: true,
			forceCanvas: true
		});
		htmlContainer.onResize << resizeHandler;
	}

	private function resizeHandler(r: Rect<Float>): Void {
		subApp.setSize(Std.int(r.width), Std.int(r.height));
		subApp.stageResizeHandler(subApp.ratio, subApp.rect);
	}

}