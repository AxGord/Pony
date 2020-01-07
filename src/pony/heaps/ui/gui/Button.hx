package pony.heaps.ui.gui;

import hxd.Cursor;
import h2d.Interactive;
import h2d.Object;
import h3d.Vector;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Button extends Interactive {

	private static inline var OVERTINT: Float = 1.2;
	private static inline var DOWNTINT: Float = 0.5;
	private static var DEFTINTV: Vector = new Vector(1, 1, 1);
	private static var OVERTINTV: Vector = new Vector(OVERTINT, OVERTINT, OVERTINT);
	private static var DOWNTINTV: Vector = new Vector(DOWNTINT, DOWNTINT, DOWNTINT);

	public var core(default, null): ButtonCore;
	public var touchable(default, null): Touchable;
	public var nodes(default, null): Array<Node>;

	public function new(nodes: Array<Node>, ?parent: Object) {
		var first: Node = nodes[0];
		super(first.w * first.scaleX, first.h * first.scaleY, parent);
		this.nodes = nodes;
		touchable = new Touchable(@:nullSafety(Off) this);
		touchable.propagateWheel = true;
		core = new ButtonCore(touchable);
		for (node in nodes) {
			node.visible = false;
			addChild(node);
		}
		first.visible = true;
		switch nodes.length {
			case 0:
				throw 'Not supported';
			case 1:
				core.onVisual << visual1Handler;
			case 2:
				core.onVisual << visual2Handler;
			case 3:
				core.onVisual << visual3Handler;
			case _:
				core.onVisual << visualNHandler;
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

}