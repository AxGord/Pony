package pony.unity3d.ui;

import pony.events.Signal;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SwitchableList;
import unityengine.MonoBehaviour;

using hugs.HUGSWrapper;

/**
 * Switcher
 * @author AxGord
 */
@:nativeGen class Switcher extends MonoBehaviour {

	public var select: Signal;
	public var core: SwitchableList;
	public var names: Array<String>;

	public function new() {
		super();
		select = new Signal();
	}

	private function Start(): Void {
		final a: NativeArrayIterator<TintButton> = getComponentsInChildrenOfType(TintButton);
		names = [for (e in a) e.name];
		a.i = 0;
		core = new SwitchableList([for (e in a) e.core], 0, 1);
		core.change.add(sw);
	}

	private function sw(n: Int): Void select.dispatch(names[n]);

	public function set(name: String): Void {
		sw(Lambda.indexOf(names, name));
	}

}
