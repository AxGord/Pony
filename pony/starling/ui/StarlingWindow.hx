package pony.starling.ui;

import pony.flash.ui.IWindow;
import starling.display.Sprite;
/**
 * StarlingWindow
 * @author Maletin
 */
class StarlingWindow extends Sprite implements IWindow
{
	private var st:StarlingWindows;

	public function new(source:Sprite) 
	{
		super();
		
		transformationMatrix = source.transformationMatrix;
		
		while (source.numChildren > 0)
		{
			addChild(source.getChildAt(0));
		}
		
		visible = false;
	}
	
	
	inline public function initm(st:StarlingWindows):Void {
		this.st = st;
		init();
	}
	
	private function init():Void {}
	
	public function show():Void {
		st.blurOn();
		visible = true;
	}
	
	private function hide():Void {
		st.blurOff();
		visible = false;
	}
	
}