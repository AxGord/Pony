package pony.pixi;

import pony.HtmlVideo;
import pony.Or;
import pony.Tumbler;
import pony.geom.Border;
import pony.geom.Rect;
import pony.pixi.App;

/**
 * PixiHtmlVideoFS
 * @author AxGord <axgord@gmail.com>
 */
class PixiHtmlVideoFS extends PixiHtmlVideoBase {

	public var fullscreen(default, null) = new Tumbler(false);
	private var normalRect: Rect<Float>;
	private var fsRect: Rect<Float>;

	public function new(
		targetRect: Rect<Float>, fsRect: Or<Border<Float>, Rect<Float>>, ?app: App, ?options: HtmlVideoOptions
	) {
		super(targetRect, app, options);
		if (fsRect != null) {
			normalRect = targetRect;
			switch fsRect {
				case A(border):
					this.fsRect = border.getRectFromSize(app.resolution);
				case B(rect):
					this.fsRect = rect;
			}
			video.onClick << fullscreen.sw;
			video.onHide || video.onEnd << fullscreen.disable;
			fullscreen.onEnable << openFullScreenHandler;
			fullscreen.onDisable << closeFullScreenHandler;
			video.style.cursor = 'pointer';
		}
	}

	public function openFullScreenHandler(): Void {
		targetRect = fsRect;
	}

	public function closeFullScreenHandler(): Void {
		targetRect = normalRect;
	}

}
