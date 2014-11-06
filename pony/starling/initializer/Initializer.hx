package pony.starling.initializer;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.starling.converter.StarlingConverter;
import pony.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.touchManager.InputMode;
import starling.display.Sprite;
import pony.starling.displayFactory.NativeFlashDisplayFactory;
import pony.touchManager.hitTestSources.NativeHitTestSource;
import pony.touchManager.hitTestSources.StarlingHitTestSource;
import pony.touchManager.touchInputs.NativeFlashTouchInput;
import pony.touchManager.touchInputs.StarlingTouchInputVisualized;
import pony.touchManager.TouchManager;

/**
 * Initializer
 * @author Maletin
 */
class Initializer 
{
	private var _sprite:IDisplayObjectContainer;
	private var _contentSprite:IDisplayObjectContainer;
	
	private var _initCallback:IDisplayObjectContainer->IDisplayObjectContainer->Void;
	
	#if starling
	private var _starlingCreator:StarlingCreator;
	#end
	
	public function new(initCallback:IDisplayObjectContainer->IDisplayObjectContainer->Void, contentSprite:flash.display.DisplayObject = null) 
	{
		_initCallback = initCallback;
				
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		_contentSprite = (contentSprite != null) ? untyped contentSprite : untyped Lib.current;
		
		#if starling
		_starlingCreator = new StarlingCreator();
		
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
		
		#end
		if (Multitouch.supportsTouchEvents) Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
	
		touchManagerInit();
		
		_initCallback(_sprite, _contentSprite);
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
	
}