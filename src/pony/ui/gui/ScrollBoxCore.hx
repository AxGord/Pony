package pony.ui.gui;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.magic.HasLink;
import pony.ui.touch.Touchable;
import pony.ui.touch.Touch;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class ScrollBoxCore implements HasSignal implements HasLink {

	public static inline var DEFAULT_BAR_SIZE: UInt = 8;
	public static inline var DEFAULT_WHEEL_SPEED: Float = 100;

	@:auto public var onScrollVertPos: Signal2<Float, Float>;
	@:auto public var onScrollVertSize: Signal2<Float, Float>;
	@:auto public var onHideScrollVert: Signal0;
	@:auto public var onScrollHorPos: Signal2<Float, Float>;
	@:auto public var onScrollHorSize: Signal2<Float, Float>;
	@:auto public var onHideScrollHor: Signal0;
	@:auto public var onContentPos: Signal2<Float, Float>;
	@:auto public var onMaskSize: Signal2<Float, Float>;

	public var w(default, set): Float = 0;
	public var h(default, set): Float = 0;

	public var vertPos(link, link): Float = barVert.pos;
	public var horPos(link, link): Float = barVert.pos;

	private var tArea: Null<Touchable>;
	@:nullSafety(Off) private var barVert: ScrollBoxBarCore;
	@:nullSafety(Off) private var barHor: ScrollBoxBarCore;

	private var cx: Float = 0;
	private var cy: Float = 0;
	private var mw: Float;
	private var mh: Float;

	public function new(
		w: Float, h: Float,
		?tArea: Touchable, ?tScrollerVert: ButtonCore, ?tScrollerHor: ButtonCore,
		scrollSize: Float = DEFAULT_BAR_SIZE, wheelSpeed: Float = DEFAULT_WHEEL_SPEED
	) {
		this.tArea = tArea;
		mw = w;
		mh = h;
		this.w = w;
		this.h = h;
		if (tScrollerVert != null) {
			barVert = new ScrollBoxBarCore(tScrollerVert, scrollSize, h, w, true, wheelSpeed);
			barVert.onHide << eHideScrollVert;
			barVert.onPos << function(a: Float, b: Float): Void eScrollVertPos.dispatch(b, a);
			barVert.onSize << function(a: Float, b: Float): Void eScrollVertSize.dispatch(b, a);
			barVert.onContentPos << vertContentHandler;
			barVert.onMaskSize << vertMaskSizeHandler;
			if (tArea != null)
				tArea.onWheel << barVert.wheelHandler;
			tScrollerVert.touch.onOver << disableContentDrag;
			tScrollerVert.touch.onOut << enableContentDrag;
			tScrollerVert.touch.onOutUp << enableContentDrag;
		}
		if (tScrollerHor != null) {
			barHor = new ScrollBoxBarCore(tScrollerHor, scrollSize, w, h, false, wheelSpeed);
			barHor.onHide << eHideScrollHor;
			barHor.onPos << eScrollHorPos;
			barHor.onSize << eScrollHorSize;
			barHor.onContentPos << horContentHandler;
			barHor.onMaskSize << horMaskSizeHandler;

			tScrollerHor.touch.onOver << disableContentDrag;
			tScrollerHor.touch.onOut << enableContentDrag;
			tScrollerHor.touch.onOutUp << enableContentDrag;
		}

		enableContentDrag();
	}

	public function set_w(v: Float): Float {
		if (v != w) {
			w = v;
			if (barVert != null) barVert.totalB = v;
			if (barHor != null) barHor.totalA = v;
		}
		return v;
	}

	public function set_h(v: Float): Float {
		if (v != h) {
			h = v;
			if (barVert != null) barVert.totalA = v;
			if (barHor != null) barHor.totalB = v;
		}
		return v;
	}

	public function disableContentDrag(): Void
		if (tArea != null) @:nullSafety(Off) tArea.onDown >> areaDownHandler;

	public function enableContentDrag(): Void
		if (tArea != null) @:nullSafety(Off) tArea.onDown << areaDownHandler;

	private function areaDownHandler(t: Touch): Void {
		t.onMove << areaMoveHandler;
		t.onUp < areaUpHandler;
		t.onOutUp < areaUpHandler;
		if (barVert != null)
			barVert.start(t.y);
		if (barHor != null)
			barHor.start(t.x);
	}

	private function areaMoveHandler(t: Touch): Void {
		if (barVert != null)
			barVert.move(t.y);
		if (barHor != null)
			barHor.move(t.x);
	}

	private function areaUpHandler(t: Touch): Void {
		t.onMove >> areaMoveHandler;
		t.onUp >> areaUpHandler;
		t.onOutUp >> areaUpHandler;
	}

	private function vertMaskSizeHandler(v: Float): Void {
		mw = v;
		updateMaskSize();
	}

	private function horMaskSizeHandler(v: Float): Void {
		mh = v;
		updateMaskSize();
	}

	@:extern private inline function updateMaskSize(): Void {
		eMaskSize.dispatch(mw, mh);
	}

	public function content(cw: Float, ch: Float): Void {
		if (barVert != null)
			barVert.content(ch);
		if (barHor != null)
			barHor.content(cw);
	}

	private function vertContentHandler(p: Float): Void {
		cy = p;
		updateContentPos();
	}

	private function horContentHandler(p: Float): Void {
		cx = p;
		updateContentPos();
	}

	@:extern private inline function updateContentPos(): Void {
		eContentPos.dispatch(cx, cy);
	}

}