package pony.starling.initializer;

import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import starling.core.Starling;



/**
 * StarlingCreator
 * @author Maletin
 */
class StarlingCreator 
{
	public var starling:Starling;
	private var _stage:Stage;

	public function new() 
	{
		_stage = Lib.current.stage;
		
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		
		starling = new Starling(StarlingStarter, Lib.current.stage, null, null, "auto", "auto");
		
		starling.antiAliasing = 0;
		starling.enableErrorChecking = false;
		starling.showStats = true;
		
		starling.start();
		
		Lib.current.stage.addEventListener(Event.RESIZE, resizeStage);
	}
	
	private function resizeStage(e:Event)
	{
		var viewPortRectangle:Rectangle = new Rectangle();
		viewPortRectangle.width = _stage.stageWidth;
		viewPortRectangle.height = _stage.stageHeight;
		Starling.current.viewPort = viewPortRectangle;
		
 		starling.stage.stageWidth = _stage.stageWidth;
		starling.stage.stageHeight = _stage.stageHeight;
	}
	
}