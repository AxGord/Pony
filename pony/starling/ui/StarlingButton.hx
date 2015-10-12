package pony.starling.ui;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;
import pony.flash.ui.Button;
import pony.starling.converter.AtlasCreator;
import pony.touchManager.Toucheble;
import pony.touchManager.TouchManagerHandCursor;
import pony.ui.ButtonImgN;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;

using pony.flash.FLExtends;

/**
 * StarlingButton
 * @author Maletin
 */
class StarlingButton extends Sprite
{
	public static var config = {def: 1, focus: 2, press: 3, zone: 4, disabled: 5};
	
	private var mc:Array<MovieClip>;
	
	public var core:ButtonImgN;
	private var _handCursor:TouchManagerHandCursor;
	private var _hitArea:Rectangle;

	private var _framerate:Int;
	private var prev:Int = -1;
	
	public function new(textures:Array<MovieClip>, framerate:Int) 
	{
		super();
		mc = textures;
		_framerate = framerate;
		var hitAreaFrame:Int = mc.length > config.zone - 1 ? config.zone : config.def;
		_hitArea = new Rectangle(mc[hitAreaFrame-1].x, mc[hitAreaFrame-1].y, mc[hitAreaFrame-1].width, mc[hitAreaFrame-1].height);
		gotoAndStop(config.def);
		core = new ButtonImgN(new Toucheble(this));
		core.onImg << imgHandler;
		useHandCursor = true;
	}
	
	private function imgHandler(img:Int):Void {
		if (img == 4) {
			useHandCursor = false;
			gotoAndStop(5);
			return;
		}
		useHandCursor = true;
	
		gotoAndStop(img > 4 ? img + 1 : img);
	}
	
	inline public function clone():StarlingButton {
		var b = new StarlingButton(mc, _framerate);
		b.x = x;
		b.y = y;
		return b;
	}
		
	override public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
    {		
		// on a touch test, invisible or untouchable objects cause the test to fail
		if (forTouch && (!visible || !touchable)) return null;
			
		// otherwise, check bounding box
		if (_hitArea.containsPoint(localPoint)) return this;
		return null;
    }
	
	private function gotoAndStop(frame:Int):Void
	{
		frame--;
		if (prev != -1) removeChild(mc[prev]);
		addChild(mc[frame]);
		mc[frame].currentFrame = 0;
		prev = frame;
	}
	
	public static function builder(_atlasCreator:AtlasCreator, source:Button, coordinateSpace:flash.display.DisplayObject, disposeable:Bool = false):starling.display.DisplayObject {
		
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
					var im = _atlasCreator.addImage(source, coordinateSpace, disposeable, j++);
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
				var im = _atlasCreator.addImage(source, coordinateSpace, disposeable, j++);
				v.push(im.texture);
				clip = new starling.display.MovieClip(v, 60);
				clip.transformationMatrix = im.transformationMatrix;
			}
			movies.push(clip);
		}
		var starlingChild = new StarlingButton(movies, 60);
		
		starlingChild.core.switchMap(@:privateAccess source._sw);
		if (@:privateAccess source._bsw) starlingChild.core.bswitch();
		
		return starlingChild;
		
	}
}