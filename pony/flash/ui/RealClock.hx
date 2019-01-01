package pony.flash.ui;

import flash.display.Sprite;
import flash.text.TextField;
import pony.flash.FLStage;
import pony.time.DeltaTime;
import pony.time.RealClock in RC;

/**
 * Clock
 * @author AxGord <axgord@gmail.com>
 */
class RealClock extends Sprite implements FLStage {

	@:stage private var time:TextField;
	@:stage private var date:TextField;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		if (time != null)
			RC.updateTime << function(s:String) time.text = s;
		if (date != null)
			RC.updateDate << function(s:String) date.text = s;
	}
	
}