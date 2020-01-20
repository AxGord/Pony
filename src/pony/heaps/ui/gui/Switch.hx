package pony.heaps.ui.gui;

import h2d.Object;
import pony.ui.gui.SwitchCore;

/**
 * Switch
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Switch extends Object {

	public var core(default, null): SwitchCore<Object>;

	public function new(childs: Array<Object>, def: Int = -1, ?parent: Object) {
		super(parent);
		core = new SwitchCore<Object>(childs, def);
		core.onOpen << openHandler;
		core.onClose << closeHandler;
		for (child in childs) {
			addChild(child);
			child.visible = false;
		}
		core.init();
	}

	private function openHandler(obj: Object): Void obj.visible = true;
	private function closeHandler(obj: Object): Void obj.visible = false;

}