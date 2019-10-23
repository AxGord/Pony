package pony.flash.ui;

import flash.display.MovieClip;
import pony.flash.FLTools;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;

using pony.flash.FLExtends;

/**
 * Button
 * @see pony.ui.ButtonCore
 * @author AxGord
 */
class Button extends MovieClip {

	#if !starling
	//public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	public var core(default, null): ButtonImgN;
	public var bMode(get, set): Bool;
	
	private var zone: Button;
	private var visual: Button;
	
	public function new() {
		super();
		FLTools.setTrace();
		stop();
		removeChildren();
		var cl: Class<Button> = Type.getClass(this);
		
		visual = Type.createEmptyInstance(cl);
		visual.gotoAndStop(1);
		visual.mouseEnabled = false;
		visual.mouseChildren = false;
		visual.scaleX = scaleX;
		visual.scaleY = scaleY;
		addChild(visual);
		
		zone = Type.createEmptyInstance(cl);
		zone.gotoAndStop(4);
		zone.buttonMode = true;
		zone.alpha = 0;
		zone.scaleX = scaleX;
		zone.scaleY = scaleY;
		addChild(zone);
		
		mouseEnabled = false;
		
		scaleX = 1;
		scaleY = 1;
		
		core = new ButtonImgN(new Touchable(zone));
		core.onImg << change;
	}

	public function addClickListener(fn: Void -> Void, priority:Int = 0): Void core.onClick.add(fn, priority);
	public function addOnceClickListener(fn: Void -> Void, priority:Int = 0): Void core.onClick.once(fn, priority);
	public function removeClickListener(fn: Void -> Void): Void core.onClick.remove(fn);

	@:getter(bMode) public inline function get_bMode(): Bool return core.bMode;
	@:extern private inline function set_bMode(value: Bool): Bool return core.bMode = value;
	@:setter(bMode) public function setBMode(value: Bool): Void core.bMode = value;
	
	private function change(img: Int): Void {
		if (img == 4) {
			zone.buttonMode = false;
			visual.gotoAndStop(5);
			return;
		}
		zone.buttonMode = true;
	
		visual.gotoAndStop(img > 4 ? img + 1 : img);
	}
	
	public function switchMap(a: Array<Int>): Void core.switchMap(a);
	public function bswitch(): Void core.bswitch();
	
	#else

	private var _sw: Array<Int>;
	private var _bsw: Bool = false;
	
	public function switchMap(v: Array<Int>): Void _sw = v;
	public function bswitch(): Void _bsw = true;
	
	#end

}