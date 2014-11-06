package pony.starling.converter;
import flash.display.BitmapData;
import flash.filters.BevelFilter;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.filters.ConvolutionFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;
import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.textures.SubTexture;
import starling.textures.Texture;
import pony.starling.converter.MaxRectsBinPack.FreeRectangleChoiceHeuristic;
import pony.starling.utils.ReusableBitmapData;
import pony.starling.utils.StarlingDrag;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;

/**
 * AtlasCreator
 * @author Maletin
 */
class AtlasCreator 
{
	private var _atlases:Array<Atlas> = new Array<Atlas>();
	
	private static var _loadedTextures:Map<String, TextureStorage> = initStorageMap();
	
	private static var _border:Int = 1;
	
	private static var _additionalBufferSize:Int = 20;
	private static var _additionalBufferSizeLimit:Int = 1024;

	public function new() 
	{
		_atlases.push(new Atlas());
	}
	
	public function addImage(source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject, disposeable:Bool):Image
	{
		var className:String = Type.getClassName(Type.getClass(source));
		
		var result:Image;
		
		var rect:Rectangle = source.getBounds(coordinateSpace);
		rectToInt(rect);
		
		var matrix = StarlingConverter.matrixCalculation(source, coordinateSpace);
		var matrixPoint:Point = matrix.transformPoint(new Point(0, 0));
		
		var texture:Texture = null;
		var preloadedTextures:Dynamic = null;
		var dPivot:Point = null;
		
		if (_loadedTextures.exists(className))
		{
			preloadedTextures = _loadedTextures.get(className).get(matrix.a, matrix.b, matrix.c, matrix.d, source.filters);
		}
		if (preloadedTextures != null)
		{
			texture = preloadedTextures.data;
			dPivot = preloadedTextures.dPivot;
			//trace("Using existing texture");
		}
		else
		{
			var drawResult:Dynamic = draw(source, coordinateSpace);
			
			var nonAlphaRect:Rectangle = drawResult.nonAlphaRect;
			
			var textureBase:Dynamic = createTexture(drawResult.bitmapData, drawResult.bitmapDataRect, !disposeable);
			
			texture = new SubTexture(textureBase.texture, textureBase.addedTo, disposeable);
			
			dPivot = new Point(_border - nonAlphaRect.x - rect.x + matrixPoint.x, _border - nonAlphaRect.y - rect.y + matrixPoint.y);
		}
		
		result = new Image(texture);
		
		result.pivotX = dPivot.x;
		result.pivotY = dPivot.y;
		
		result.x = matrixPoint.x;
		result.y = matrixPoint.y;
		
		if (!_loadedTextures.exists(className)) _loadedTextures.set(className, new TextureStorage());
		_loadedTextures.get(className).add(matrix.a, matrix.b, matrix.c, matrix.d, source.filters, texture, dPivot);
		
		return result;
	}
	
	public function addClip(source:flash.display.MovieClip, coordinateSpace:flash.display.DisplayObject, disposeable:Bool):MovieClip
	{
		var textures:Vector<Texture> = null;
		
		source.gotoAndStop(1);
		var maxRect:Rectangle = null;
		var rect:Rectangle;
		var className:String = Type.getClassName(Type.getClass(source));
		var matrix:Matrix = StarlingConverter.matrixCalculation(source, coordinateSpace);
		
		var preloadedTextures:Dynamic = null;
		var dPivot:Point = null;
		
		if (_loadedTextures.exists(className))
		{
			preloadedTextures = _loadedTextures.get(className).get(matrix.a, matrix.b, matrix.c, matrix.d, source.filters);
		}
		if (preloadedTextures != null)
		{
			textures = preloadedTextures.data;
			dPivot = preloadedTextures.dPivot;
			//trace("Using existing textures");
		}
		else
		{
			textures = new Vector<Texture>();
			var rects:Array<Rectangle> = new Array<Rectangle>();
			var addedRects:Array<Rectangle> = new Array<Rectangle>();
			var addedTextures:Array<Texture> = new Array<Texture>();
			
			for (i in 0...source.totalFrames)
			{				
				source.gotoAndStop(i + 1); //Because first frame on a flash timeline is 1, not 0
				rect = source.getBounds(coordinateSpace);
				rectToInt(rect);
				
				if (source.numChildren == 0)
				{
					rects.push(null);
					addedRects.push(null);
					addedTextures.push(null);
					
					continue;
				}
				
				matrix = StarlingConverter.matrixCalculation(source, coordinateSpace);
				
				var matrixPoint:Point = matrix.transformPoint(new Point(0, 0));
				
				matrix.translate(_additionalBufferSize - rect.x, _additionalBufferSize - rect.y);
				
				var drawResult:Dynamic = draw(source, coordinateSpace);
				
				var nonAlphaRect:Rectangle = drawResult.nonAlphaRect;
				
				var textureBase:Dynamic = createTexture(drawResult.bitmapData, drawResult.bitmapDataRect, !disposeable);
				
				nonAlphaRect.x -= matrixPoint.x - rect.x;
				nonAlphaRect.y -= matrixPoint.y - rect.y;
				
				rects.push(nonAlphaRect);
				addedRects.push(textureBase.addedTo);
				addedTextures.push(textureBase.texture);
			}
			
			var maxRect:Rectangle = null;
			
			for (i in 0...rects.length)
			{
				var currentRect:Rectangle = rects[i];
				
				if (currentRect == null) continue;
				
				if (maxRect == null)
				{
					maxRect = rects[i].clone();
					continue;
				}
				
				if (maxRect.top    > currentRect.top)    maxRect.top    = currentRect.top;
				if (maxRect.left   > currentRect.left)   maxRect.left   = currentRect.left;
				if (maxRect.bottom < currentRect.bottom) maxRect.bottom = currentRect.bottom;
				if (maxRect.right  < currentRect.right)  maxRect.right  = currentRect.right;
			}
				
			for (i in 0...addedTextures.length)
			{
				if (addedTextures[i] == null)
				{
					textures.push(new SubTexture(Texture.fromColor(maxRect.width, maxRect.height, 0x0), maxRect, true, maxRect));
				}
				else
				{
					var currentRect:Rectangle = rects[i];
					var frame:Rectangle = new Rectangle(maxRect.x - currentRect.x, maxRect.y - currentRect.y, maxRect.width, maxRect.height);
					textures.push(new SubTexture(addedTextures[i], addedRects[i], disposeable, frame));
				}
				
				if (dPivot == null)
				{
					source.gotoAndStop(i + 1);
					dPivot = new Point(_border-maxRect.x, _border-maxRect.y);
				}
			}
		}
		
		//TODO set frame to 1-st !null ?
		source.gotoAndStop(1);
		matrix = StarlingConverter.matrixCalculation(source, coordinateSpace);
		var matrixPoint:Point = matrix.transformPoint(new Point(0, 0));
		
		if (!_loadedTextures.exists(className)) _loadedTextures.set(className, new TextureStorage());
		_loadedTextures.get(className).add(matrix.a, matrix.b, matrix.c, matrix.d, source.filters, textures, dPivot);
		
		var clip:MovieClip = new MovieClip(textures, 60);
		
		clip.pivotX = dPivot.x;
		clip.pivotY = dPivot.y;
		
		clip.x = matrixPoint.x;
		clip.y = matrixPoint.y;
		
		return clip;
	}
	
	public function showAtlases():Void
	{
		for (i in 0..._atlases.length)
		{
			_atlases[i].drawOnScreen();
		}
	}
	
	private function draw(source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject):Dynamic
	{
		var additionalSize:Int = _additionalBufferSize;
		
		var rect:Rectangle = source.getBounds(coordinateSpace);
		rectToInt(rect);
		
		var matrix:Matrix = StarlingConverter.matrixCalculation(source, coordinateSpace);
		
		matrix.translate(additionalSize - rect.x, additionalSize - rect.y);
		
		while (additionalSize < _additionalBufferSizeLimit)
		{
			var buffer:BitmapData = ReusableBitmapData.getPowTwo(Std.int(rect.width + additionalSize * 2), Std.int(rect.height + additionalSize * 2));
			buffer.draw(source, matrix, null, null, null, true);
			
			var bufferRect:Rectangle = buffer.getColorBoundsRect(0xFF000000, 0x00000000, false);
			var nonAlphaRect:Rectangle = bufferRect.clone();
			
			nonAlphaRect.x -= additionalSize;
			nonAlphaRect.y -= additionalSize;
			
			if ( (bufferRect.left == 0 || bufferRect.top == 0 || bufferRect.right == buffer.width || bufferRect.bottom == buffer.height) &&
				  bufferRect.width != 0 && bufferRect.height != 0)
			{
				matrix.translate(additionalSize, additionalSize);//Works ONLY FOR x2!
				additionalSize *= 2;
				
				//matrix.translate(-additionalSize, -additionalSize);//Works for every multiplier
				//additionalSize *= 3;
				//matrix.translate(additionalSize, additionalSize);
			}
			else
			{
				//TODO support for larger textures?
				if (bufferRect.width  > Atlas.size - 2 * _border) bufferRect.width  = nonAlphaRect.width  = Atlas.size - 2 * _border;
				if (bufferRect.height > Atlas.size - 2 * _border) bufferRect.height = nonAlphaRect.height = Atlas.size - 2 * _border;
				return { nonAlphaRect:nonAlphaRect, bitmapData:buffer, bitmapDataRect:bufferRect};
			}
		}
		
		throw 'Object $source is too big';
		
		return null;
	}
	
	private function createTexture(bitmapData:BitmapData, area:Rectangle, toAtlas:Bool):Dynamic
	{
		if (toAtlas)
		{
			var addedTo:Rectangle = _atlases[_atlases.length - 1].add(bitmapData, area);
			if (addedTo == null)
			{
				_atlases.push(new Atlas());
				addedTo = _atlases[_atlases.length - 1].add(bitmapData, area);
			}
			
			return { texture:_atlases[_atlases.length - 1].texture, addedTo:addedTo };
		}
		else
		{
			area = area.clone();
			
			area.top    -= AtlasCreator.getBorder();
			area.left   -= AtlasCreator.getBorder();
			area.bottom += AtlasCreator.getBorder();
			area.right  += AtlasCreator.getBorder();
			
			var texture:Texture = null;
			
			if (area.width > bitmapData.width * 0.5 && area.height > bitmapData.height * 0.5)
			{
				//Can't place it in a smaller bitmapData
				texture = Texture.fromBitmapData(bitmapData, false);
				return { texture:texture, addedTo:area };
			}
			else
			{
				var smallerBitmapData:BitmapData = ReusableBitmapData.getPowTwo(cast area.width, cast area.height);
				smallerBitmapData.copyPixels(bitmapData, area, new Point(0, 0));
				
				texture = Texture.fromBitmapData(smallerBitmapData, false);
				area.x = area.y = 0;
				return { texture:texture, addedTo:area };
			}
		}
		return null;
	}
	
	public function generate():Void
	{
		_atlases[_atlases.length - 1].generate();
	}
	
	private static function initStorageMap():Map<String, TextureStorage>
	{
		var result:Map<String, TextureStorage> = new Map<String, TextureStorage>();
		result.set("flash.display.MovieClip", new TextureStorage(false));
		result.set("flash.text.StaticText", new TextureStorage(false));
		result.set("flash.display.Shape", new TextureStorage(false));
		
		return result;
	}
	
	private static function rectToInt(rect:Rectangle):Void
	{
		rect.top    = Math.floor(rect.top);
		rect.left   = Math.floor(rect.left);
		rect.bottom = Math.ceil(rect.bottom);
		rect.right  = Math.ceil(rect.right);
	}
	
	public static function getBorder():Int return _border;
	
}

private class Atlas
{
	public static var size:Int = 2048;
	public var bitmapData:BitmapData = new BitmapData(size, size, true, 0x0);
	public var pack:MaxRectsBinPack = new MaxRectsBinPack(size, size, false);
	public var texture:Texture = Texture.empty(size, size, true, false, false, 1);
	public var upToDate:Bool = false;
	public var full:Bool = false;
	
	public function new()
	{
		//trace("NEW ATLAS CREATED");
	}
	
	public function add(data:BitmapData, rect:Rectangle):Rectangle
	{
		if (full) return null;
		
		rect = rect.clone();
		
		rect.top    -= AtlasCreator.getBorder();
		rect.left   -= AtlasCreator.getBorder();
		rect.bottom += AtlasCreator.getBorder();
		rect.right  += AtlasCreator.getBorder();
		
		var placedRect:Rectangle = pack.insert(cast rect.width, cast rect.height, FreeRectangleChoiceHeuristic.BottomLeftRule);
		
		if (placedRect.width == 0 || placedRect.height == 0)
		{
			generate();
			return null;
		}
		
		bitmapData.copyPixels(data, rect, placedRect.topLeft);
		
		upToDate = false;
		
		return placedRect;
	}
	
	public function generate():Void
	{
		if (upToDate) return;
		
		texture.root.uploadBitmapData(bitmapData);
		texture.root.onRestore = function():Void
        {
            texture.root.uploadBitmapData(bitmapData);
        };
		
		upToDate = true;
	}
	
	public function drawOnScreen():Void
	{
		var debugImage:Image = new Image(texture);
		debugImage.touchable = true;
		untyped Starling.current.root.addChild(debugImage);
		TouchManager.addListener(debugImage, function(_):Void { StarlingDrag.startDrag(debugImage); }, [TouchEventType.Down]);
		TouchManager.addListener(debugImage, function(_):Void { StarlingDrag.stopDrag(debugImage); }, [TouchEventType.Up]);
	}
}

private class TextureStorage
{
	private var _allowsAddition:Bool;
	private var _textures:Array<Dynamic> = new Array<Dynamic>();
	
	public function new(allowsAddition:Bool = true)
	{
		_allowsAddition = allowsAddition;
	}
	
	public function canAdd():Bool { return _allowsAddition; }
	
	public function add(a:Float, b:Float, c:Float, d:Float, filters:Dynamic, data:Dynamic, dPivot:Point):Void
	{
		if (!_allowsAddition) return;
		
		if (get(a, b, c, d, filters) == null) _textures.push({a:a, b:b, c:c, d:d, filters:filters, data:data, dPivot:dPivot});
	}
	
	public function get(a:Float, b:Float, c:Float, d:Float, filters:Dynamic):Dynamic
	{
		if (!_allowsAddition) return null;
		
		for (i in 0..._textures.length)
		{
			var texture:Dynamic = _textures[i];
			if ( (texture.a == a) &&
				 (texture.b == b) &&
				 (texture.c == c) &&
				 (texture.d == d) &&
				 (filtersEqual(texture.filters, filters)) )
				return texture;
		}
		
		return null;
	}
	
	public function filtersEqual(a:Dynamic, b:Dynamic):Bool
	{
		if (a.length != b.length) return false;
		
		for (i in 0...a.length)
		{
			if ( Type.getClass(a[i]) != Type.getClass(b[i]) ) return false;
		}
		
		for (i in 0...a.length)
		{
			switch(Type.getClass(a[i]))
			{
				case BevelFilter:
					if (a[i].angle != b[i].angle) return false;
					if (a[i].blurX != b[i].blurX) return false;
					if (a[i].blurY != b[i].blurY) return false;
					if (a[i].distance != b[i].distance) return false;
					if (a[i].highlightAlpha != b[i].highlightAlpha) return false;
					if (a[i].highlightColor != b[i].highlightColor) return false;
					if (a[i].knockout != b[i].knockout) return false;
					if (a[i].quality != b[i].quality) return false;
					if (a[i].shadowAlpha != b[i].shadowAlpha) return false;
					if (a[i].shadowColor != b[i].shadowColor) return false;
					if (a[i].strength != b[i].strength) return false;
					if (a[i].type != b[i].type) return false;
				case BlurFilter:
					if (a[i].blurX != b[i].blurX) return false;
					if (a[i].blurY != b[i].blurY) return false;
					if (a[i].quality != b[i].quality) return false;
				case ColorMatrixFilter:
					for (j in 0...20)
					{
						if (a[i].matrix[j] != b[i].matrix[j]) return false;
					}
				case ConvolutionFilter:
					if (a[i].alpha != b[i].alpha) return false;
					if (a[i].bias != b[i].bias) return false;
					if (a[i].clamp != b[i].clamp) return false;
					if (a[i].color != b[i].color) return false;
					if (a[i].divisor != b[i].divisor) return false;
					if (a[i].matrixX != b[i].matrixX) return false;
					if (a[i].matrixY != b[i].matrixY) return false;
					if (a[i].preserveAlpha != b[i].preserveAlpha) return false;
					for (j in 0...Std.int(a[i].matrixX * a[i].matrixY))
					{
						if (a[i].matrix[j] != b[i].matrix[j]) return false;
					}
				case DropShadowFilter:
					if (a[i].alpha != b[i].alpha) return false;
					if (a[i].angle != b[i].angle) return false;
					if (a[i].blurX != b[i].blurX) return false;
					if (a[i].blurY != b[i].blurY) return false;
					if (a[i].color != b[i].color) return false;
					if (a[i].distance != b[i].distance) return false;
					if (a[i].hideObject != b[i].hideObject) return false;
					if (a[i].inner != b[i].inner) return false;
					if (a[i].knockout != b[i].knockout) return false;
					if (a[i].quality != b[i].quality) return false;
					if (a[i].strength != b[i].strength) return false;
				case GlowFilter:
					if (a[i].alpha != b[i].alpha) return false;
					if (a[i].blurX != b[i].blurX) return false;
					if (a[i].blurY != b[i].blurY) return false;
					if (a[i].color != b[i].color) return false;
					if (a[i].inner != b[i].inner) return false;
					if (a[i].knockout != b[i].knockout) return false;
					if (a[i].quality != b[i].quality) return false;
					if (a[i].strength != b[i].strength) return false;
				default:
					return false;
			}
		}
		
		return true;
	}
}