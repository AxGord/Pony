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
import pony.flash.FLTools;
import pony.starling.displayFactory.DisplayFactory.IDisplayObject;
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
import pony.starling.converter.StarlingConverter;
#end

/**
 * Initializer
 * @author Maletin
 */
class Initializer 
{
	private var _sprite:IDisplayObjectContainer;
	private var _content:IDisplayObject;
	
	private var _initCallback:IDisplayObjectContainer->IDisplayObject->Void;
	
	private var _initialWidth:Int;
	private var _initialHeight:Int;
	private var _aspectRatio:Float;
	
	#if starling
	private var _starlingCreator:StarlingCreator;
	#else
	private var _viewLimiterA:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	private var _viewLimiterB:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	#end
	
	public static function init(initCallback:IDisplayObjectContainer->IDisplayObject->Void):Void {
		FLTools.init < function() {
			new Initializer(initCallback, 
				#if debug
				true
				#else
				false
				#end
			);
		}
	}
	
	public function new(initCallback:IDisplayObjectContainer->IDisplayObject->Void, showStats:Bool = false, content:flash.display.DisplayObject = null) 
	{
		_initCallback = initCallback;
				
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		_content = (content != null) ? untyped content : untyped Lib.current;
		
		_initialWidth = FLTools.width != -1 ? Std.int(FLTools.width) : Lib.current.stage.stageWidth;
		_initialHeight = FLTools.height != -1 ? Std.int(FLTools.height) : Lib.current.stage.stageHeight;
		_aspectRatio = _initialWidth / _initialHeight;
		
		if (Multitouch.supportsTouchEvents) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		
		#if starling
		_starlingCreator = new StarlingCreator(showStats);
		
		_starlingCreator.starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
	}
	
	private function convert(source:flash.display.Sprite):starling.display.DisplayObject
	{
		var result:starling.display.DisplayObject = cast StarlingConverter.getObject(source, Lib.current.stage);
		source.visible = false;
		//source.alpha = 0.3;
		return result;
	}
	
	private function onRootCreated(e:starling.events.Event):Void
	{
		_starlingCreator.starling.removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		
		_sprite = untyped _starlingCreator.starling.root;
		
		_content = cast convert(untyped _content);
		_sprite.addChild(_content);
		
		TouchManager.init();
		TouchManager.removeScreenByID(0);
		TouchManager.addScreen(new StarlingHitTestSource(cast _sprite));
		#else
		
		_sprite = NativeFlashDisplayFactory.getInstance().createSprite();
		Lib.current.stage.addChild(cast _sprite);
		
		_content.parent.removeChild(_content);
		_sprite.addChild(_content);
		
		Lib.current.stage.addChild(_viewLimiterA);
		Lib.current.stage.addChild(_viewLimiterB);
		
		updateLimiters();
		
		#end
		
		Lib.current.stage.addEventListener(Event.RESIZE, resizeStage);
		resizeStage();
		
		_initCallback(_sprite, _content);
	}
	
	private function resizeStage(e:Event = null):Void
	{
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