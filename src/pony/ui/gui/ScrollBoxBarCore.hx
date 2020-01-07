package pony.ui.gui;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.magic.HasLink;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxBarCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class ScrollBoxBarCore implements HasSignal implements HasLink {

	@:auto public var onHide: Signal0;
	@:auto public var onPos: Signal2<Float, Float>;
	@:auto public var onSize: Signal2<Float, Float>;
	@:auto public var onContentPos: Signal1<Float>;
	@:auto public var onMaskSize: Signal1<Float>;

	public var pos(link, set): Float = slider.pos;

	public var c(default, null): Null<Float>;
	private var slider: SliderCore;
	private var scrollPanelSize: Float;
	public var totalA(default, set): Float = 0;
	public var totalB(default, set): Float = 0;
	private var scrollerSize: Float = 0;
	private var startPoint: Float = 0;

	public function new(t: ButtonCore, scrollPanelSize: Float, totalA: Float, totalB: Float, vert: Bool, wheelSpeed: Float) {
		slider = new SliderCore(t, 0, vert);
		slider.wheelSpeed = wheelSpeed;
		this.scrollPanelSize = scrollPanelSize;
		this.totalA = totalA;
		this.totalB = totalB;
		if (vert) {
			slider.changeY = posHandler;
		} else {
			slider.changeX = posHandler;
		}
		slider.changeValue << valueHandler;
	}

	public inline function set_pos(v: Float): Float {
		@:nullSafety(Off) if (c != null && c > totalA) {
			slider.pos = v;
			slider.update();
		}
		return v;
	}

	private function set_totalA(v: Float): Float {
		if (v != totalA) {
			totalA = v;
			if (c != null) @:nullSafety(Off) content(c);
		}
		return v;
	}

	private function set_totalB(v: Float): Float {
		if (v != totalB) {
			totalB = v;
			if (c != null) @:nullSafety(Off) content(c);
		}
		return v;
	}

	public function content(c: Float): Void {
		this.c = c;
		if (c <= totalA) {
			slider.setSize(0.1);
			eHide.dispatch();
			eContentPos.dispatch(0);
			eMaskSize.dispatch(totalB);
		} else {
			scrollerSize = totalA * totalA / c;
			slider.setSize(totalA - scrollerSize);
			eSize.dispatch(scrollerSize, scrollPanelSize);
			eMaskSize.dispatch(totalB - scrollPanelSize);
			slider.initValue(0, c - totalA);
			slider.update();
			posHandler(slider.pos);
		}
	}

	private function posHandler(pos: Float): Void ePos.dispatch(pos, totalB - scrollPanelSize);
	private function valueHandler(v: Float): Void eContentPos.dispatch(-v);
	public function wheelHandler(delta: Float): Void slider.wheelValue(delta);
	public function start(p: Float): Void startPoint = slider.value + p;
	public function move(p: Float): Void slider.setPosValue(startPoint - p);

}