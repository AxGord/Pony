package pony.pixi.ui;

import pony.HtmlVideo;
import pony.geom.Rect;

/**
 * HtmlVideoUI
 * @author AxGord <axgord@gmail.com>
 */
class HtmlVideoUI extends HtmlContainer {

	public var video(default, null): HtmlVideo;
	public var muted(get, set): Bool;

	public function new(
		targetRect: Rect<Float>, ?css: String, ?app: App, ?options: HtmlVideoOptions, ceil: Bool = false, fixed: Bool = false
	) {
		super(targetRect, app, ceil, fixed);
		video = new HtmlVideo(options);
		video.appendTo(app.element);
		htmlContainer.targetStyle = video.style;
		if (css != null) video.style.cssText += css;
		video.changeResultVisible << htmlContainer.posUpdater.set_enabled;
		htmlContainer.posUpdater.enabled = video.resultVisible;
	}

	public inline function hide(): Void video.visible.disable();
	public inline function show(): Void video.visible.enable();

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_muted(): Bool return video.muted.enabled;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_muted(v: Bool): Bool return video.muted.enabled = v;

}