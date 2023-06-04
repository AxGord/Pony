package pony.unity3d.ui;

import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.gui.FocusManager;
import pony.ui.gui.IFocus;
import pony.unity3d.ui.TextureButton;
import pony.unity3d.ui.TintButton;
import unityengine.GUIText;
import unityengine.Time;
import unityengine.Vector2;
import unityengine.Rect;

using hugs.HUGSWrapper;

/**
 * Input
 * @author AxGord <axgord@gmail.com>
 */
class Input extends TextureButton implements IFocus {

	public static var caretTime:Float = 0.5;
	private static var ct:Float = 0;
	private static var cb:Bool = false;

	public var text:String;
	public var vtext:String;
	public var max:Int = 0;
	public var focusPriority(default,null):Int = 0;
	public var focusGroup(default,null):String = '';
	public var focus(default,null):Signal1<Dynamic,Bool>;
	public var changed(default,null):Signal;

	public var selected(default, null):Bool;

	public var x(get, set):Int;
	public var y(get, set):Int;

	private var gt(get, never):GUIText;

	public function new() {
		super();
		changed = new Signal(this);
		focus = Signal.create(this);
		focus.add(onFocus);
		core.click.sub(0).add(focus.saveDispatch);
	}

	private function onFocus(b:Bool):Void {
		selected = b;
		core.mode = b ? 2 : 0;
		if (!b) gt.text = vtext = text;
	}

	override private function Start():Void {
		super.Start();
		if (text == null || text == '')
			vtext = text = gt.text;
		else
			gt.text = vtext = text;
		FocusManager.reg(this);
	}

	private inline function get_gt():GUIText return this.getComponentInChildrenOfType(GUIText);

	override private function Update():Void {
		super.Update();
		if (selected) {
			for (ch in unityengine.Input.inputString) {
				core.mode = 2;
				if (ch == 13) {
					core.mode = 0;
					changed.dispatch(gt.text = text = vtext);
					continue;
				}
				if (ch == 8)
					vtext = vtext.substr(0, -1);
				else if (max == 0 || vtext.length < max)
					vtext += ch;
			}
			//draw
			ct += Time.deltaTime;
			if (ct >= caretTime) {
				ct -= caretTime;
				cb = !cb;
			}
			gt.text = cb ? vtext + '|' : vtext;
		}// else gt.text = text;
	}

	inline private function get_y():Int return Math.ceil(guiTexture.pixelInset.y);

	private function set_y(v:Int):Int {
		if (y != v) {
			gt.pixelOffset = new Vector2(gt.pixelOffset.x, gt.pixelOffset.y - y + v);
			guiTexture.pixelInset = new Rect(guiTexture.pixelInset.x, v, guiTexture.pixelInset.width, guiTexture.pixelInset.height);
		}
		return v;
	}

	inline private function get_x():Int return Math.ceil(guiTexture.pixelInset.x);

	private function set_x(v:Int):Int {
		if (x != v) {
			gt.pixelOffset = new Vector2(gt.pixelOffset.x - x + v, gt.pixelOffset.y);
			guiTexture.pixelInset = new Rect(v, guiTexture.pixelInset.y, guiTexture.pixelInset.width, guiTexture.pixelInset.height);
		}
		return v;
	}

	public function setText(t:String):Void gt.text = text = vtext = t;
}