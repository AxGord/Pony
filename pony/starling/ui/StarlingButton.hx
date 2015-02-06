package pony.starling.ui;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;
import haxe.CallStack;
import pony.ui.ButtonCore;
import starling.display.MovieClip;
import starling.display.Image;
import starling.display.DisplayObject;
import starling.textures.Texture;
import pony.touchManager.ButtonCoreTM;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
import pony.touchManager.TouchManagerHandCursor;
import starling.core.Starling;

/**
 * ...
 * @author Maletin
 */
class StarlingButton extends MovieClip
{
	public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	public var core:ButtonCore;
	private var _handCursor:TouchManagerHandCursor;
	private var _hitArea:Rectangle;

	private var _textures:Vector<Texture>;
	private var _framerate:Int;
	
	public function new(textures:Vector<Texture>, framerate:Int, core:ButtonCore) 
	{
		super(textures, framerate);
		_textures = textures;
		_framerate = framerate;
		
		
		var hitAreaFrame:Int = numFrames > config.zone - 1 ? config.zone : config.def;
		gotoAndStop(hitAreaFrame);
		
		var texture = getFrameTexture(hitAreaFrame - 1);//Zero-based frame id here
		_hitArea = new Rectangle(-texture.frame.x, -texture.frame.y, texture.width, texture.height);
		
		gotoAndStop(config.def);

		this.core = core;
		TouchManager.addListener(this, touchManagerListener);
		
		core.changeVisual.add(change);
		
		_handCursor = new TouchManagerHandCursor(this);
	}
	
	inline public function clone():StarlingButton {
		var b = new StarlingButton(_textures, _framerate, new ButtonCore());
		b.x = x;
		b.y = y;
		return b;
	}
	
	public function touchManagerListener(e:TouchManagerEvent):Void
	{
		ButtonCoreTM.eventsTransition(e, core);
	}
		
	override public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
    {		
		// on a touch test, invisible or untouchable objects cause the test to fail
		if (forTouch && (!visible || !touchable)) return null;
			
		// otherwise, check bounding box
		if (_hitArea.containsPoint(localPoint)) return this;
		return null;
    }
	
	private function change(state:ButtonStates, mode:Int, focus:Bool):Void {
		if (mode == 1) {
			_handCursor.enabled = false;
			gotoAndStop(config.disabled);
			return;
		}
		_handCursor.enabled = true;
	
		gotoAndStop((switch [state, focus] {
			case [Default, false]: config.def;
			case [Focus|Leave, _] | [_, true]: config.focus;
			case [Press, _]: config.press;
		}) + mode * 3 - (mode > 1?1:0));
	}
	
	private function gotoAndStop(frame:Int):Void
	{
		currentFrame = frame - 1;
		pause();
	}
	
	public function sw(v:Array<Int>):Void if (core != null) core.sw = v;
}