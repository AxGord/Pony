package pony.flash.ui;

import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.ui.Multitouch;
import flash.events.TouchEvent;


import pony.events.Signal;
import pony.flash.ExtendedMovieClip;
import pony.ui.ButtonCore;

using pony.flash.FLExtends;
using pony.flash.CPP_FL_TouchFix;

/**
 * ...
 * @author AxGord
 */
class Button extends ExtendedMovieClip {

	public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	public var core:ButtonCore;
	
	private var zone:Button;
	private var visual:Button;
	
	public function new() {
		super();
		FLTools.setTrace();
		stop();
		removeChildren();
		var cl:Class<Button> = Type.getClass(this);
		
		visual = Type.createEmptyInstance(cl);
		visual.gotoAndStop(config.def);
		visual.mouseEnabled = false;
		addChild(visual);
		
		zone = Type.createEmptyInstance(cl);
		zone.gotoAndStop(config.zone);
		zone.buttonMode = true;
		zone.alpha = 0;
		addChild(zone);
		
		core = new ButtonCore();
		core.changeVisual.add(change);
		
		mouseEnabled = false;
		
		addEventListener(ExtendedMovieClip.INIT, init);
	}
	
	private function init(Void):Void {
		if (CPP_FL_TouchFix.useFix) {
			zone.downSignal().sub([], [false]).add(core.mouseOver);
			CPP_FL_TouchFix.move.add(touchMove);
			CPP_FL_TouchFix.down.add(touchMove);
			zone.upSignal().add(touchUp);
			
		} else {
		
			zone.addEventListener(MouseEvent.MOUSE_OVER, over);
			zone.addEventListener(MouseEvent.MOUSE_OUT, core.mouseOut.v());
			zone.addEventListener(MouseEvent.MOUSE_DOWN, core.mouseDown.v());
			stage.addEventListener(MouseEvent.MOUSE_UP, core.mouseUp.v());
		}
	}
	
	private function over(event:MouseEvent):Void core.mouseOver(event.buttonDown);
	
	private function change(state:ButtonStates, mode:Int, focus:Bool):Void {
		if (mode == 1) {
			zone.buttonMode = false;
			visual.gotoAndStop(config.disabled);
			return;
		}
		zone.buttonMode = true;
		
		visual.gotoAndStop((switch [state, focus] {
			case [Default, false]: config.def;
			case [Focus|Leave, _] | [_, true]: config.focus;
			case [Press, _]: config.press;
		}) + mode * 3 - (mode>1?1:0));
	}
	
	
	//Touch screen in cpp
	
	private function touchMove(obj:InteractiveObject) {
		if (zone == obj) return;
		core.mouseOut();
		core.mouseUp();
	}
	
	private function touchUp() {
		core.mouseDown();
		core.mouseUp();
		core.mouseOut();
	}
}