package pony.starling.converter ;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import pony.flash.ui.Button;
import pony.flash.ui.MusicPlayer;
import pony.flash.ui.ProgressBar;
import pony.flash.ui.SongPlayer;
import pony.flash.ui.Tree;
import pony.flash.ui.TurningFree;
import pony.starling.SpritePack;
import pony.starling.ui.StarlingBar;
import pony.starling.ui.StarlingButton;
import pony.starling.ui.StarlingMusicPlayer;
import pony.starling.ui.StarlingProgressBar;
import pony.starling.ui.StarlingScrollBar;
import pony.starling.ui.StarlingSongPlayer;
import pony.starling.ui.StarlingTree;
import pony.starling.ui.StarlingTurningFree;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.utils.HAlign;
import starling.utils.VAlign;

using pony.flash.FLExtends;
/**
 * StarlingConverter
 * @author Maletin
 */
class StarlingConverter 
{
	private static var _atlasCreator:AtlasCreator = new AtlasCreator();
	
	public static function getObject(source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject, disposeable:Bool = false):starling.display.DisplayObject
	{
		return getObjectInternal(source, coordinateSpace, disposeable, true);
	}
	
	private static function getObjectInternal(source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject, disposeable:Bool = false, atlasGeneration:Bool):starling.display.DisplayObject
	{
		//trace("Converting " + source + " with a name " + source.name);
		
		var starlingChild:starling.display.DisplayObject;
		if (Std.is(source, flash.text.TextField) && hasName(source)) // Dynamic TextField
		{
			starlingChild = getStarlingTextField(cast(source, TextField), coordinateSpace);
		}
		else if (Std.is(source, pony.flash.ui.ScrollBar)) // ScrollBar
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingScrollBar(untyped starlingChild);
			untyped source.starlingScrollBar = starlingChild;
		}
		else if (Std.is(source, pony.flash.ui.Bar)) // ScrollBar
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingBar(untyped starlingChild);
			untyped source.starlingBar = starlingChild;
		}
		
		else if (Std.is(source, pony.flash.ui.ProgressBar)) // ScrollBar
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingProgressBar(untyped starlingChild);
			untyped source.starlingBar = starlingChild;
		}
		else if (Std.is(source, pony.flash.ui.MusicPlayer)) // ScrollBar
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingMusicPlayer(untyped starlingChild);
			untyped source.starlingBar = starlingChild;
		}
		else if (Std.is(source, pony.flash.ui.SongPlayer)) // ScrollBar
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingSongPlayer(untyped starlingChild);
			untyped source.starlingBar = starlingChild;
		}
		
		else if (Std.is(source, TurningFree)) // TurningFree
		{
			starlingChild = getSpriteInternal(untyped source, coordinateSpace, disposeable);
			starlingChild = new StarlingTurningFree(cast starlingChild, cast (source, TurningFree).core, cast (source, TurningFree));
		}
		else if (Std.is(source, Tree)) // Tree
		{
			starlingChild = new StarlingTree(untyped source);
			setPivotPointAndPosition(starlingChild, source, coordinateSpace);
		}
		else if (Std.is(source, IStarlingConvertible))
		{
			starlingChild = cast(source, IStarlingConvertible).convert(coordinateSpace);
		}
		else if (Std.is(source, pony.flash.ui.Button)) // Button
		{
			starlingChild = StarlingButton.builder(_atlasCreator, source, coordinateSpace, disposeable);
		}
		else if (Std.is(source, flash.display.Sprite) && childrenWithNames(cast(source, flash.display.Sprite))) // Container
		{
			starlingChild = getSpriteInternal(cast(source, flash.display.Sprite), coordinateSpace, disposeable);
		}
		else if (Std.is(source, SpritePack))
		{
			starlingChild = StarlingSpritePack.builder(_atlasCreator, source, coordinateSpace, disposeable);
		}
		else if (Std.is(source, flash.display.MovieClip) && cast(source, flash.display.MovieClip).totalFrames > 1) // MovieClip
		{
			starlingChild = _atlasCreator.addClip(cast(source, flash.display.MovieClip), coordinateSpace, disposeable);
			Starling.juggler.add(untyped starlingChild);
			
			untyped starlingChild.currentFrame = 0;
			untyped starlingChild.pause();
		}
		else // Image
		{
			starlingChild = _atlasCreator.addImage(source, coordinateSpace, disposeable);
			starlingChild.touchable = hasName(source);
		}
		//trace(source + " with a name " + source.name + " converted to " + starlingChild);
		
		if (hasName(source)) starlingChild.name = source.name;
		
		if (!disposeable && atlasGeneration) _atlasCreator.generate();
		
		return starlingChild;
	}
	
	public static function getSprite(source:flash.display.Sprite, coordinateSpace:flash.display.DisplayObject, disposeable:Bool):starling.display.Sprite
	{
		return getSpriteInternal(source, coordinateSpace, disposeable, true);
	}
	
	private static function getSpriteInternal(source:flash.display.Sprite, coordinateSpace:flash.display.DisplayObject, disposeable:Bool, atlasGeneration:Bool = false):starling.display.Sprite
	{
		var result:starling.display.Sprite = new starling.display.Sprite();
		
		//Pivot points for containers
		setPivotPointAndPosition(result, source, coordinateSpace);
		result.pivotX = 0;
		result.pivotY = 0;
		
		for (i in 0...untyped source.numChildren)
		{			
			var starlingChild:starling.display.DisplayObject = getObjectInternal(untyped source.getChildAt(i), coordinateSpace, disposeable, atlasGeneration);
			
			result.addChild(starlingChild);
			
			//Pivot points for containers
			starlingChild.x -= result.x;
			starlingChild.y -= result.y;
		}
		
		//Pivot point and zero point visualisation for containers
		
		//var pivotQuad:Quad = new Quad(10, 10, 0xFF6600);
		//pivotQuad.x = result.pivotX;
		//pivotQuad.y = result.pivotY;
		//result.addChild(pivotQuad);
		//
		//var zeroQuad:Quad = new Quad(5, 5, 0x0066FF);
		//result.addChild(zeroQuad);
		
		return result;
	}
	
	public static function getObjectWithNoParent(source:flash.display.DisplayObject, disposeable:Bool = false):starling.display.DisplayObject
	{
		var sprite:flash.display.Sprite = new flash.display.Sprite();
		
		sprite.addChild(source);
		
		return getObject(source, sprite, disposeable);
	}
	
	public static function getBorder():Int { return AtlasCreator.getBorder(); }
	
	public static function showAtlases():Void { _atlasCreator.showAtlases(); }
	
	private static function getStarlingTextField(source:flash.text.TextField, coordinateSpace:flash.display.DisplayObject):starling.text.TextField
	{
		var format:TextFormat = source.getTextFormat();
		
		var selfRect:Rectangle = source.getBounds(source);
		
		var result:starling.text.TextField = new starling.text.TextField(cast(selfRect.width, Int), cast(selfRect.height, Int), source.text, format.font, format.size, format.color, format.bold);
		
		result.vAlign = VAlign.TOP;
		
		switch (format.align)
		{
			case TextFormatAlign.CENTER:
				result.hAlign = HAlign.CENTER;
			case TextFormatAlign.RIGHT:
				result.hAlign = HAlign.RIGHT;
			default:
				result.hAlign = HAlign.LEFT;
		}
		
		var matrix:flash.geom.Matrix = source.transform.matrix.clone();
		
		var parent:flash.display.DisplayObject = source.parent;
		while (parent != coordinateSpace)
		{
			matrix.concat(parent.transform.matrix);
			parent = parent.parent;
		}
		
		result.transformationMatrix = matrix;
		
		var rect:Rectangle = source.getBounds(coordinateSpace);
		var matrixPoint:Point = matrix.transformPoint(new Point(selfRect.x, selfRect.y));
		
		result.x = matrixPoint.x;
		result.y = matrixPoint.y;
		
		return result;
	}
	
	public static function childrenWithNames(clip:flash.display.Sprite):Bool
	{
		for (i in 0...clip.numChildren)
		{
			var child:flash.display.DisplayObject = clip.getChildAt(i);
			if (hasName(child)) return true;
		}
		return false;
	}
	
	private static function hasName(source:flash.display.DisplayObject):Bool
	{
		return source.name.indexOf("instance") == -1;
	}
	
	private static function setPivotPointAndPosition(result:starling.display.DisplayObject, source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject):Void
	{
		var rect:Rectangle = source.getBounds(coordinateSpace);
		
		var matrix:Matrix = matrixCalculation(source, coordinateSpace);

		var matrixPoint:Point = matrix.transformPoint(new Point(0, 0));
		
		result.pivotX = matrixPoint.x - rect.x;
		result.pivotY = matrixPoint.y - rect.y;
		
		result.x = matrixPoint.x;
		result.y = matrixPoint.y;
	}
	
	public static function matrixCalculation(source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject):flash.geom.Matrix
	{
		var matrix:flash.geom.Matrix = source.transform.matrix.clone();
		var parent:flash.display.DisplayObject = source.parent;
		while (parent != coordinateSpace && parent != null)
		{
			matrix.concat(parent.transform.matrix);
			parent = parent.parent;
		}
		
		return matrix;
	}		
}