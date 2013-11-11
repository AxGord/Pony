package pony.unity3d.ui.ucore;

import pony.events.Signal;
import pony.ui.FocusManager;
import pony.ui.IFocus;
import pony.unity3d.ui.TintButton;
import unityengine.GUIText;
import unityengine.Time;
using hugs.HUGSWrapper;
/**
 * Input
 * @author AxGord <axgord@gmail.com>
 */
class InputUCore extends TintButton implements IFocus {

	public static var caretTime:Float = 0.5;
	private static var ct:Float = 0;
	private static var cb:Bool = false;
	
	public var text:String;
	public var max:Int = 0;
	public var focusPriority(default,null):Int = 0;
	public var focusGroup(default,null):String = '';
	public var focus(default,null):Signal;
	
	public var selected(default,null):Bool;
	
	private var gt:GUIText;
	
	public function new() {
		super();
		focus = new Signal(this);
		focus.add(onFocus);
		core.click.sub([0]).add(focus.dispatchArgs.bind([true]));
	}
	
	private function onFocus(b:Bool):Void {
		selected = b;
		core.mode = b ? 2 : 0;
		if (!b) gt.text = text;
	}
	
	override private function Start():Void {
		super.Start();
		gt = this.getComponentInChildrenOfType(GUIText);
		text = gt.text;
		FocusManager.reg(this);
	}
	
	override private function Update():Void {
		super.Update();
		if (!selected) return;
		for (ch in unityengine.Input.inputString) {
			if (ch == 13) continue;
			if (ch == 8)
				text = text.substr(0, -1);
			else if (max == 0 || text.length < max)
				text += ch;
		}
		//draw
		ct += Time.deltaTime;
		if (ct >= caretTime) {
			ct -= caretTime;
			cb = !cb;
		}
		gt.text = cb ? text + '|' : text;
	}
	
}