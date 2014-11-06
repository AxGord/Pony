package pony.starling.initializer;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.starling.converter.StarlingConverter;
import pony.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.starling.displayFactory.NativeFlashDisplayFactory;
import pony.touchManager.hitTestSources.NativeHitTestSource;
import pony.touchManager.hitTestSources.StarlingHitTestSource;
import pony.touchManager.InputMode;
import pony.touchManager.touchInputs.NativeFlashTouchInput;
import pony.touchManager.TouchManager;
#if starling
import starling.display.Sprite;
import starling.core.Starling;
#end

/**
 * Initializer
 * @author Maletin
 */
class Initializer 
{
	private var _sprite:IDisplayObjectContainer;
	private var _contentSprite:IDisplayObjectContainer;
	
	private var _initCallback:IDisplayObjectContainer->IDisplayObjectContainer->Void;
	
	private var _initialWidth:Int;
	private var _initialHeight:Int;
	private var _aspectRatio:Float;
	private var _needResize:Bool = false;
	
	#if starling
	private var _starlingCreator:StarlingCreator;
	#else
	private var _viewLimiterA:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	private var _viewLimiterB:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	#end
	
	public function new(initCallback:IDisplayObjectContainer->IDisplayObjectContainer->Void, showStats:Bool = false, contentSprite:flash.display.DisplayObject = null) 
	{
		_initCallback = initCallback;
				
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		_contentSprite = (contentSprite != null) ? untyped contentSprite : untyped Lib.current;
		
		_initialWidth = Lib.current.stage.stageWidth;
		_initialHeight = Lib.current.stage.stageHeight;
		_aspectRatio = Lib.current.stage.stageWidth / Lib.current.stage.stageHeight;
		
		#if starling
		_starlingCreator = new StarlingCreator(showStats);
		
		_starlingCreator.starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
	}
	
	private function convert(source:flash.display.Sprite):starling.display.Sprite
	{
		var result:Sprite = cast StarlingConverter.getObject(source, Lib.current.stage);
		source.visible = false;
		//source.alpha = 0.3;
		return result;
	}
	
	private function onRootCreated(e:starling.events.Event):Void
	{
		_starlingCreator.starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		
		_sprite = untyped _starlingCreator.starling.root;
		
		_contentSprite = cast convert(untyped _contentSprite);
		_sprite.addChild(_contentSprite);
		#else
		
		_sprite = NativeFlashDisplayFactory.getInstance().createSprite();
		Lib.current.stage.addChild(cast _sprite);
		
		_contentSprite.parent.removeChild(_contentSprite);
		_sprite.addChild(_contentSprite);
		
		Lib.current.stage.addChild(_viewLimiterA);
		Lib.current.stage.addChild(_viewLimiterB);
		
		updateLimiters();
		
		#end
		if (Multitouch.supportsTouchEvents) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
		touchManagerInit();
		
		Lib.current.stage.addEventListener(Event.RESIZE, resizeStage);
		//Lib.current.stage.addEventListener(Event.RESIZE, needResize);
		//Lib.current.stage.addEventListener(Event.ENTER_FRAME, resizeStage);
		
		_initCallback(_sprite, _contentSprite);
	}
	
	private function needResize(e:Event):Void
	{
		_needResize = true;
	}
	
	private function resizeStage(e:Event):Void
	{
		//if (!_needResize) return;
		//_needResize = false;
		trace("resize");
		var stage = Lib.current.stage;
		var smallerWidth:Bool = stage.stageWidth / stage.stageHeight < _aspectRatio;
		
		var newWidth:Int  = Std.int( smallerWidth ? stage.stageWidth  : stage.stageHeight * _aspectRatio);
		var newHeight:Int = Std.int(!smallerWidth ? stage.stageHeight : stage.stageWidth  / _aspectRatio);
		
		_sprite.scaleX = newWidth / _initialWidth;
		_sprite.scaleY = newHeight / _initialHeight;
		
		#if starling
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.x = (stage.stageWidth - newWidth) / 2;
			viewPortRectangle.y = (stage.stageHeight - newHeight) / 2;
			viewPortRectangle.width = newWidth;
			viewPortRectangle.height = newHeight;
			
			Starling.current.viewPort = viewPortRectangle;
			
			Starling.current.stage.stageWidth = newWidth;
			Starling.current.stage.stageHeight = newHeight;
		#else
			_sprite.x = (stage.stageWidth - newWidth) / 2;
			_sprite.y = (stage.stageHeight - newHeight) / 2;
		
			updateLimiters();
		#end
	}
	
	private function touchManagerInit():Void
	{
		InputMode.init();
		
		#if starling
			TouchManager.addScreen(new StarlingHitTestSource(cast _sprite));
		#else
			TouchManager.addScreen(new NativeHitTestSource(cast _sprite));
		#end
		
		new NativeFlashTouchInput(Lib.current.stage);
		//new StarlingTouchInputVisualized(cast _sprite);
	}
	
	#if !starling
	private function updateLimiters():Void
	{
		var stage = Lib.current.stage;
		var smallerWidth:Bool = stage.stageWidth / stage.stageHeight < _aspectRatio;
		
		_viewLimiterA.x = 0;
		_viewLimiterA.y = 0;
		_viewLimiterB.x = smallerWidth ? 0 : (stage.stageWidth - stage.stageHeight * _aspectRatio) / 2 + stage.stageHeight * _aspectRatio;
		_viewLimiterB.y = smallerWidth ? (stage.stageHeight - stage.stageWidth / _aspectRatio) / 2 + stage.stageWidth / _aspectRatio : 0;
		_viewLimiterA.width = smallerWidth ? stage.stageWidth : (stage.stageWidth - stage.stageHeight * _aspectRatio) / 2;
		_viewLimiterA.height = smallerWidth ? (stage.stageHeight - stage.stageWidth / _aspectRatio) / 2 : stage.height;
		_viewLimiterB.width = smallerWidth ? stage.stageWidth : (stage.stageWidth - stage.stageHeight * _aspectRatio) / 2;
		_viewLimiterB.height = smallerWidth ? (stage.stageHeight - stage.stageWidth / _aspectRatio) / 2 : stage.height;
	}
	#end
	
}