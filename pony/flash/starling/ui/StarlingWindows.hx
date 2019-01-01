package pony.flash.starling.ui;

import starling.display.Sprite;
import starling.display.DisplayObject;

/**
 * StarlingWindows
 * @author Maletin
 */
class StarlingWindows implements Dynamic<StarlingWindow>
{
	private var map:Map<String, StarlingWindow>;
	private var st:Sprite;

	public function new(st:Sprite) 
	{
		map = new Map<String, StarlingWindow>();
		this.st = st;
		var windows:Array<StarlingWindow> = new Array<StarlingWindow>();
		for (i in 0...st.numChildren)
		{
			var child = st.getChildAt(i);
			if (Std.is(child, StarlingWindow)) windows.push(cast child);
		}
		
		for (i in 0...windows.length)
		{
			map.set(windows[i].name, windows[i]);
			windows[i].initm(this);
			//TODO With this code buttons don't work. Either fix it or always place windows on top of everything else
			//st.removeChild(windows[i]);
			//st.stage.addChild(windows[i]);
		}
	}
	
	inline public function resolve(field:String):StarlingWindow return map.get(field);
	
	public function blurOn():Void {
		//var filter = new BlurFilter();
		//filter.quality = 3;
		//switch (st.stage.quality) {
			//case StageQuality.LOW:
			//case StageQuality.MEDIUM:
				//Lib.current.alpha = 0.05;
			//default:
				//Lib.current.filters = [filter];
				//Lib.current.alpha = 0.05;		
		//}
		//Lib.current.mouseEnabled = false;
		//Lib.current.mouseChildren = false;
	}
	
	public function blurOff():Void {
		//Lib.current.filters = [];
		//Lib.current.alpha = 1;
		//Lib.current.mouseEnabled = true;
		//Lib.current.mouseChildren = true;
	}
	
}