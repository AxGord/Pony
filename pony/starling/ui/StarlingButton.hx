package pony.starling.ui;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;
import haxe.CallStack;
import pony.starling.converter.AtlasCreator;
import pony.ui.ButtonCore;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.display.Image;
import starling.display.DisplayObject;
import starling.textures.Texture;
import pony.touchManager.ButtonCoreTM;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
import pony.touchManager.TouchManagerHandCursor;
import starling.core.Starling;
using pony.flash.FLExtends;
/**
 * StarlingButton
 * @author Maletin
 */
class StarlingButton extends Sprite
{
	public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	private var mc:Array<MovieClip>;
	
	public var core:ButtonCore;
	private var _handCursor:TouchManagerHandCursor;
	private var _hitArea:Rectangle;

	private var _framerate:Int;
	private var prev:Int = -1;
	
	public function new(textures:Array<MovieClip>, framerate:Int, core:ButtonCore) 
	{
		super();
		mc = textures;
		_framerate = framerate;
		
		var hitAreaFrame:Int = mc.length > config.zone - 1 ? config.zone : config.def;
		
		_hitArea = new Rectangle(mc[hitAreaFrame-1].x, mc[hitAreaFrame-1].y, mc[hitAreaFrame-1].width, mc[hitAreaFrame-1].height);
		
		gotoAndStop(config.def);

		this.core = core;
		TouchManager.addListener(this, touchManagerListener);
		
		core.changeVisual.add(change);
		
		_handCursor = new TouchManagerHandCursor(this);
	}
	
	inline public function clone():StarlingButton {
		var b = new StarlingButton(mc, _framerate, new ButtonCore());
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
		frame--;
		if (prev != -1) removeChild(mc[prev]);
		addChild(mc[frame]);
		mc[frame].currentFrame = 0;
		prev = frame;
	}
	
	public function sw(v:Array<Int>):Void if (core != null) core.sw = v;
	
	public static function builder(_atlasCreator:AtlasCreator, source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject, disposeable:Bool = false):starling.display.DisplayObject {
		
		var mc:flash.display.MovieClip = cast source;
		var movies:Array<starling.display.MovieClip> = [];
		var j = 0;
		for (i in 1...mc.totalFrames+1)
		{
			mc.gotoAndStop(i);
			var clip:starling.display.MovieClip = null;
			var v:Vector<Texture> = new Vector<Texture>();
			for (o in mc.childrens()) if (Std.is(o, flash.display.MovieClip)) {
				
				var m:flash.display.MovieClip = cast o;
				
				var str = null;
				for (i in 1...m.totalFrames+1) {
					m.gotoAndStop(i);
					var im = _atlasCreator.addImage(source, coordinateSpace, disposeable, -1, true);//todo: cache more frames
					v.push(im.texture);
					if (str == null) str = im.transformationMatrix;
				}
				clip = new starling.display.MovieClip(v, 60);
				clip.transformationMatrix = str;
				Starling.juggler.add(clip);
				clip.play();
				
				break;
			}
			if (clip == null) {
				var im = _atlasCreator.addImage(source, coordinateSpace, disposeable, j);
				v.push(im.texture);
				clip = new starling.display.MovieClip(v, 60);
				clip.transformationMatrix = im.transformationMatrix;
			}
			j++;
			movies.push(clip);
		}
		var starlingChild = new StarlingButton(movies, 60, untyped source.core);
		
		if (untyped source.getSW() != null) untyped starlingChild.sw(untyped source.getSW());
		
		return starlingChild;
		
	}
}