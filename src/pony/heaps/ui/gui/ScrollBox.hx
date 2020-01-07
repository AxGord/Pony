package pony.heaps.ui.gui;

import hxd.Cursor;
import h2d.Interactive;
import h2d.Graphics;
import h2d.Mask;
import h2d.Object;
import pony.time.DeltaTime;
import pony.color.UColor;
import pony.geom.Orientation;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.ui.gui.ScrollBoxCore;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;

/**
 * ScrollBox
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class ScrollBox extends Mask implements HasSignal implements IWH {

	public static inline var DEFAULT_BAR_COLOR: UColor = 0;

	public var size(get, never): Point<Float>;
	public var core(default, null): ScrollBoxCore;
	public var content(default, null): Object;

	public function new(
		size: Point<UInt>, orientation: Orientation = Orientation.Any, ?barColor: Array<UColor>,
		barSize: UInt = ScrollBoxCore.DEFAULT_BAR_SIZE, wheelSpeed: Float = ScrollBoxCore.DEFAULT_WHEEL_SPEED
	) {
		super(size.x, size.y);
		if (barColor == null) barColor = [ DEFAULT_BAR_COLOR ];
		var tai: Interactive = new Interactive(size.x, size.y, @:nullSafety(Off) this);
		tai.cursor = Cursor.Default;
		content = new Object(@:nullSafety(Off) this);
		var vbutton: Null<LightButton> = orientation.isVertical ? new LightButton(barSize, barColor, @:nullSafety(Off) this) : null;
		var hbutton: Null<LightButton> = orientation.isHorizontal ? new LightButton(barSize, barColor, @:nullSafety(Off) this) : null;
		core = new ScrollBoxCore(
			size.x, size.y, new Touchable(tai),
			vbutton != null ? vbutton.core : null,
			hbutton != null ? hbutton.core : null,
			barSize, wheelSpeed
		);
		if (vbutton != null) {
			core.onHideScrollVert << vbutton.hide;
			core.onScrollVertSize << vbutton.show;
			core.onScrollVertSize << vbutton.setSize;
			core.onScrollVertPos << vbutton.setPosition;
		}
		if (hbutton != null) {
			core.onHideScrollVert << hbutton.hide;
			core.onScrollVertSize << hbutton.show;
			core.onScrollVertSize << hbutton.setSize;
			core.onScrollVertPos << hbutton.setPosition;
		}
		core.onContentPos << content.setPosition;
	}

	public inline function add(object: Object): Void {
		content.addChild(object);
		needUpdate();
	}

	public function update(): Void {
		var b: h2d.col.Bounds = content.getBounds();
		core.content(b.x + b.width, b.y + b.height);
	}

	public inline function needUpdate(): Void DeltaTime.fixedUpdate < update;
	private function get_size(): Point<Float> return new Point<Float>(core.w, core.h);
	public function wait(fn: Void -> Void):Void fn();
	public function destroyIWH(): Void {}

}