package pony.ui.gui;

import pony.geom.Point;
import pony.magic.Declarator;

enum TreeElement {
	Group(name: String, tree: TreeCore);
	Unit(name: String, fun: Void -> Void);
}

/**
 * Tree
 * @author AxGord <axgord@gmail.com>
 */
class TreeCore implements Declarator {

	@:arg public var lvl: Int = 0;
	@:arg private var parent: TreeCore = null;

	public var opened: Bool = lvl == 0;
	public var nodes(default, null): Array<TreeElement> = [];

	public function addGroup(text: String): TreeCore {
		var t = new TreeCore(lvl + 1, this);
		nodes.push(Group(text, t));
		return t;
	}

	public function addUnit(text: String, f: Void -> Void): Void {
		nodes.push(Unit(text, f));
	}

}