package pony.flash.starling.utils;

import pony.flash.starling.displayFactory.DisplayFactory;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.time.DeltaTime;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.SubTexture;

using pony.flash.FLExtends;

/**
 * StarlingUtils
 * @author Maletin
 */
class StarlingUtils 
{
	public static function largeImage(data:BitmapData, mipMaps:Bool = false):Sprite
	{
		var result:Sprite = new Sprite();
		
		if ( (data.width <= 2048) && (data.height <= 2048) )
		{
			result.addChild(new Image(Texture.fromBitmapData(data, mipMaps)));
		}
		else
		{
			var xTextures:Int = Math.ceil(data.width / 2048);
			var yTextures:Int = Math.ceil(data.height / 2048);
			
			var rect:Rectangle = new Rectangle();
			var zeroPoint:Point = new Point(0, 0);
			
			for (i in 0...xTextures)
			{
				for (j in 0...yTextures)
				{
					var textureSourceInit:Void->BitmapData = function():BitmapData
					{
						var textureWidth :Int = (i == xTextures - 1) ? data.width  - i * 2048 : 2048;
						var textureHeight:Int = (j == yTextures - 1) ? data.height - j * 2048 : 2048;
						
						var bmpd:BitmapData = ReusableBitmapData.getPowTwo(textureWidth, textureHeight);
						
						rect.x = i * 2048;
						rect.y = j * 2048;
						rect.width = textureWidth;
						rect.height = textureHeight;
						
						bmpd.copyPixels(data, rect, zeroPoint);
						
						return bmpd;
					}
					
					var texture:Texture = Texture.fromBitmapData(textureSourceInit(), mipMaps);
					texture.root.onRestore = function():Void
					{
						texture.root.uploadBitmapData(textureSourceInit());
					}
					
					if ((i == xTextures - 1) || (j == yTextures - 1))
					{
						texture = new SubTexture(texture, new Rectangle(0, 0, data.width  - i * 2048, data.height - j * 2048), true);
					}
					
					var image:Image = new Image(texture);
					image.x = i * 2048;
					image.y = j * 2048;
					
					result.addChild(image);
				}
			}
		}
		
		return result;
	}
	
	public static function disposeWithChildren(object:DisplayObject):Void
	{
		object.removeFromParent(true);
		if (Std.is(object, DisplayObjectContainer))
		{
			var container = cast(object, DisplayObjectContainer);
			while (container.numChildren > 0)
			{
				disposeWithChildren(container.getChildAt(0));
			}
		}
		if (Std.is(object, Image)) untyped object.texture.dispose();
		if (Std.is(object, MovieClip))
		{
			var clip = cast(object, MovieClip);
			for (i in 0...clip.numFrames)
			{
				clip.getFrameTexture(i).dispose();
			}
		}
		
		if (Std.is(object, Image) || Std.is(object, MovieClip)) untyped object.dispose();
	}
	
	public static function enableChildrenTouchable(container:DisplayObjectContainer, enableContainerTouchable:Bool = true):Void
	{
		if (enableContainerTouchable) container.touchable = true;
		for (i in 0...container.numChildren)
		{
			var child:DisplayObject = container.getChildAt(i);
			child.touchable = true;
			if (Std.is(child, DisplayObjectContainer)) enableChildrenTouchable(cast child);
		}
	}
	
	public static function alphaToUntouchable(container:starling.display.DisplayObjectContainer):Void
	{
		for (i in 0...container.numChildren)
		{
			var child:starling.display.DisplayObject = container.getChildAt(i);
			if (!child.touchable) child.alpha = 0.2;
			if (Std.is(child, starling.display.DisplayObjectContainer)) alphaToUntouchable(cast child);
		}
	}
	
	public static function playChildren(container:DisplayObjectContainer):Void
	{
		for (i in 0...container.numChildren)
		{
			var child:DisplayObject = container.getChildAt(i);
			if (Std.is(child, MovieClip)) untyped child.play();
			if (Std.is(child, DisplayObjectContainer)) playChildren(cast child);
		}
	}
	
	public static function setChildrenTextureSmoothing(container:DisplayObjectContainer, smoothing:String = "none"):Void
	{
		for (i in 0...container.numChildren)
		{
			var child:DisplayObject = container.getChildAt(i);
			if (Std.is(child, Image)) cast(child, Image).smoothing = smoothing;
			if (Std.is(child, DisplayObjectContainer)) setChildrenTextureSmoothing(cast child, smoothing);
		}
	}
	
	public static function syncAll(root:IDisplayObject):Void {
		DeltaTime.fixedUpdate << function() {
			for (e in Lib.current.childrens()) {
				var o:IDisplayObject = untyped root.getChildByName(e.name);
				if (o == null) continue;
				o.x = e.x;
				o.y = e.y;
				o.width = e.width;
				o.height = e.height;
				o.alpha = e.alpha;
			}
		}
	}
}