package pony.heaps.ui.gui;

import hxd.Cursor;
import h2d.Object;
import h2d.Interactive;
import pony.color.UColor;
import pony.geom.Point;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;

/**
 * LightButton
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class LightButton extends Interactive {

	private static inline var ONECOLOR_PRESS_ALPHA: Float = 0.5;
	private static inline var ONECOLOR_DEFAULT_ALPHA: Float = 0.7;

	public var core(default, null): ButtonCore;
	public var touchable(default, null): Touchable;
	public var colors(default, null): Array<UInt>;

	public function new(size: Point<UInt>, colors: Array<UColor>, ?parent: Object) {
		super(size.x, size.y, parent);
		this.colors = [ for (color in colors) color.invertAlpha ];
		if (colors.length > 0) backgroundColor = this.colors[0];
		touchable = new Touchable(@:nullSafety(Off) this);
		touchable.propagateWheel = true;
		core = new ButtonCore(touchable);
		switch colors.length {
			case 0:
			case 1:
				alpha = ONECOLOR_DEFAULT_ALPHA;
				core.onVisual << visual1Handler;
			case 2:
				core.onVisual << visual2Handler;
			case 3:
				core.onVisual << visual3Handler;
			case _:
				core.onVisual << visualNHandler;
		}
	}

	public inline function setSize(w: Float, h: Float): Void {
		width = w;
		height = h;
	}

	public inline function show(): Void visible = true;
	public inline function hide(): Void visible = false;

	private function visual1Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			alpha = ONECOLOR_PRESS_ALPHA;
		} else {
			cursor = Cursor.Button;
			alpha = switch state {
				case Default: ONECOLOR_DEFAULT_ALPHA;
				case Focus, Leave: 1;
				case Press: ONECOLOR_PRESS_ALPHA;
			}
		}
	}

	private function visual2Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			alpha = ONECOLOR_PRESS_ALPHA;
			backgroundColor = colors[0];
		} else {
			cursor = Cursor.Button;
			alpha = switch state {
				case Default, Focus, Leave: 1;
				case Press: ONECOLOR_PRESS_ALPHA;
			}
			backgroundColor = switch state {
				case Default: colors[0];
				case Focus, Press, Leave: colors[1];
			}
		}
	}

	private function visual3Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			backgroundColor = colors[2];
			alpha = ONECOLOR_PRESS_ALPHA;
		} else {
			cursor = Cursor.Button;
			alpha = 1;
			backgroundColor = switch state {
				case Default: colors[0];
				case Focus, Leave: colors[1];
				case Press: colors[2];
			}
		}
	}

	private function visualNHandler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			backgroundColor = colors[3];
		} else {
			if (mode > 1) {
				mode--;
				mode *= 3;
				mode++;
			}
			cursor = Cursor.Button;
			backgroundColor = switch state {
				case Default: colors[mode];
				case Focus, Leave: colors[mode + 1];
				case Press: colors[mode + 2];
			}
		}
	}

}