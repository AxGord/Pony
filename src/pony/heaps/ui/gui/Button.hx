package pony.heaps.ui.gui;

import pony.time.TimeInterval;
import pony.time.Tween;
import h2d.Interactive;
import h2d.Object;

import h3d.Vector;

import hxd.Cursor;

import pony.geom.Point;
import pony.geom.IWH;
import pony.magic.HasLink;
import pony.ui.gui.ButtonCore;
import pony.ui.touch.Touchable;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Button extends Interactive implements HasLink implements IWH {

	private static inline var OVERTINT: Float = 1.2;
	private static inline var DOWNTINT: Float = 0.5;
	private static var DEFTINTV: Vector = new Vector(1, 1, 1);
	private static var OVERTINTV: Vector = new Vector(OVERTINT, OVERTINT, OVERTINT);
	private static var DOWNTINTV: Vector = new Vector(DOWNTINT, DOWNTINT, DOWNTINT);

	public var core(default, null): ButtonCore;
	public var touchable(default, null): Touchable;
	public var nodes(default, null): Array<Node>;
	public var size(link, never): Point<Float> = nodes[0].size;

	private var tween: Tween = new Tween(300, false, false, false, true);
	private var anim: Null<TimeInterval>;
	private var prevState: ButtonState = ButtonState.Default;

	public function new(nodes: Array<Node>, ?anim: TimeInterval, ?parent: Object) {
		var first: Node = nodes[0];
		super(first.size.x * first.scaleX, first.size.y * first.scaleY, parent);
		this.nodes = nodes;
		this.anim = anim;
		touchable = new Touchable(@:nullSafety(Off) this);
		touchable.propagateWheel = true;
		core = new ButtonCore(touchable);
		for (node in nodes) {
			node.visible = false;
			addChild(node);
		}
		first.visible = true;
		if (anim != null) {
			switch nodes.length {
				case 1:
					tween.onUpdate << tweenUpdateHandler;
					core.onVisual << animVisual1Handler;
				case _: throw 'Not supported';
			}
		} else {
			switch nodes.length {
				case 0: throw 'Not supported';
				case 1: core.onVisual << visual1Handler;
				case 2: core.onVisual << visual2Handler;
				case 3: core.onVisual << visual3Handler;
				case _: core.onVisual << visualNHandler;
			}
		}
	}

	private function visual1Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			nodes[0].tint = DOWNTINTV;
		} else {
			cursor = Cursor.Button;
			switch state {
				case Default:
					nodes[0].tint = DEFTINTV;
				case Focus, Leave:
					nodes[0].tint = OVERTINTV;
				case Press:
					nodes[0].tint = DOWNTINTV;
			}
		}
	}

	private function visual2Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			nodes[0].visible = false;
			nodes[1].visible = true;
			nodes[1].tint = DOWNTINTV;
		} else {
			cursor = Cursor.Button;
			switch state {
				case Default:
					nodes[0].visible = true;
				case Focus, Leave:
					nodes[0].visible = false;
					nodes[1].visible = true;
					nodes[1].tint = DEFTINTV;
				case Press:
					nodes[0].visible = false;
					nodes[1].visible = true;
					nodes[1].tint = DOWNTINTV;
			}
		}
	}

	private function visual3Handler(mode: Int, state: ButtonState): Void {
		for (node in nodes) node.visible = false;
		if (mode == 1) {
			cursor = Cursor.Default;
			nodes[2].visible = true;
		} else {
			cursor = Cursor.Button;
			var index: UInt = switch state {
				case Default: 0;
				case Focus, Leave: 1;
				case Press: 2;
			}
			nodes[index].visible = true;
		}
	}

	private function visualNHandler(mode: Int, state: ButtonState): Void {
		for (node in nodes) node.visible = false;
		if (mode == 1) {
			cursor = Cursor.Default;
			nodes[3].visible = true;
		} else {
			cursor = Cursor.Button;
			if (mode > 1) {
				mode--;
				mode *= 3;
				mode++;
			}
			var index: UInt = switch state {
				case Default: mode;
				case Focus, Leave: mode + 1;
				case Press: mode + 2;
			}
			if (index >= nodes.length) index = nodes.length - 1;
			nodes[index].visible = true;
		}
	}

	private function animVisual1Handler(mode: Int, state: ButtonState): Void {
		if (mode == 1) {
			cursor = Cursor.Default;
			tween.range = new Pair<Float, Float>(nodes[0].tint.x, DOWNTINT);
			@:nullSafety(Off) tween.time = anim.min;
			tween.stopOnBegin();
			tween.playForward();
		} else if (prevState != state || cursor == Cursor.Default) {
			cursor = Cursor.Button;
			tween.range = new Pair<Float, Float>(nodes[0].tint.x, switch state {
				case Default: 1;
				case Focus, Leave: OVERTINT;
				case Press: DOWNTINT;
			});
			@:nullSafety(Off) tween.time = prevState == Press ? anim.max : switch state {
				case Focus, Press: anim.min;
				case Default, Leave: anim.max;
			}
			prevState = state;
			tween.stopOnBegin();
			tween.playForward();
		}
	}

	private function tweenUpdateHandler(v: Float): Void {
		nodes[0].tint = new Vector(v, v, v);
	}

	public function destroy():Void {
		core.destroy();
		touchable.destroy();
		@:nullSafety(Off) {
			core = null;
			touchable = null;
			nodes = null;
		}
		removeChildren();
		remove();
	}

	public function wait(cb: Void -> Void): Void cb();
	public function destroyIWH(): Void destroy();

}