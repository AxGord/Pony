package pony.pixi.ui;

import pony.HtmlVideo;

/**
 * HtmlVideoUI
 * @author AxGord <axgord@gmail.com>
 */
class HtmlVideoUI extends HtmlContainer {

	public var video(default, null):HtmlVideo;
	public var muted(get, set):Bool;

	public function new(
		targetRect:pony.geom.Rect<Float>,
		?css:String,
		?app:pony.pixi.App,
		?options:HtmlVideoOptions,
		ceil:Bool = false,
		fixed:Bool = false
	) {
		super(targetRect, app, ceil, fixed);
		video = new HtmlVideo(options);
		video.appendTo(app.element);
		htmlContainer.targetStyle = video.style;
		if (css != null) video.style.cssText += css;
	}

	public inline function hide():Void video.visible.disable();
	public inline function show():Void video.visible.enable();

	@:extern private inline function get_muted():Bool return video.muted.enabled;
	@:extern private inline function set_muted(v:Bool):Bool return video.muted.enabled = v;

}