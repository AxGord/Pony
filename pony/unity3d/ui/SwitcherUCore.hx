package pony.unity3d.ui;

import pony.events.Signal;
import pony.ui.SwitchableList;
import pony.ui.ButtonCore;
import unityengine.MonoBehaviour;
using hugs.HUGSWrapper;

/**
 * Switcher
 * @author AxGord
 */

class SwitcherUCore extends MonoBehaviour {
	
	public var select:Signal;
	public var core:SwitchableList;
	public var names:Array<String>;
	
	public function new() {
		super();
		select = new Signal();
	}
	
	private function Start():Void {
		var a:NativeArrayIterator<TintButton> = getComponentsInChildrenOfType(TintButton);
		names = [for (e in a) e.name];
		a.i = 0;
		core = new SwitchableList([for (e in a) e.core], 0, 1);
		core.select.add(sw);
	}
	
	private function sw(n:Int):Void select.dispatch(names[n]);
	
	public function set(name:String):Void {
		core.setState(Lambda.indexOf(names, name));
	}
	
}