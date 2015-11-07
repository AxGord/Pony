package pony.flash.starling.initializer;
import pony.flash.starling.displayFactory.DisplayFactory;
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
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.NativeFlashDisplayFactory;
import pony.time.DeltaTime;
import pony.ui.touch.starling.touchManager.hitTestSources.NativeHitTestSource;
import pony.ui.touch.starling.touchManager.InputMode;
import pony.ui.touch.starling.touchManager.touchInputs.NativeFlashTouchInput;
import pony.ui.touch.starling.touchManager.TouchManager;
#if starling
import starling.display.Sprite;
import starling.display.Quad;
import starling.core.Starling;
import pony.flash.starling.converter.StarlingConverter;
import pony.ui.touch.starling.touchManager.hitTestSources.StarlingHitTestSource;
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
	private var _viewLimiterA:Quad = new Quad(1, 1, Lib.current.stage.color);
	private var _viewLimiterB:Quad = new Quad(1, 1, Lib.current.stage.color);
	#else
	private var _viewLimiterA:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	private var _viewLimiterB:Bitmap = new Bitmap(new BitmapData(1, 1, false, Lib.current.stage.color));
	#end
	
	public static function init(initCallback:IDisplayObjectContainer->IDisplayObject->Void):Void {
		DeltaTime.fixedUpdate < function() {
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
		FLTools.width = _initialWidth;
		FLTools.height = _initialHeight;
		_aspectRatio = _initialWidth / _initialHeight;
		
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
		
		Starling.current.stage.addChild(_viewLimiterA);
		Starling.current.stage.addChild(_viewLimiterB);
		
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
			viewPortRectangle.width = stage.stageWidth;
			viewPortRectangle.height = stage.stageHeight;
			Starling.current.viewPort = viewPortRectangle;
			Starling.current.stage.stageWidth = stage.stageWidth;
			Starling.current.stage.stageHeight = stage.stageHeight;
		#end
		
		_sprite.x = Std.int((stage.stageWidth - newWidth) / 2);
		_sprite.y = Std.int((stage.stageHeight - newHeight) / 2);
		
		updateLimiters();
	}
	
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
	
}