package pony.pixi;

import pony.pixi.App;
import pony.HtmlVideo;

/**
 * PixiHtmlVideoBase
 * @author AxGord <axgord@gmail.com>
 */
class PixiHtmlVideoBase extends HtmlContainerBase {

	public var video:HtmlVideo;

	public function new(targetRect:pony.geom.Rect<Float>, ?app:App, ?options:HtmlVideoOptions) {
		super(targetRect, app);
		video = new HtmlVideo(options);
		video.appendTo(this.app.parentDom);
		targetStyle = video.style;
	}

}