package pony.flash.starling.initializer;

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
	private var _initialWidth:Int;
	private var _initialHeight:Int;

	public function new(showStats:Bool) 
	{
		_stage = Lib.current.stage;
		
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		
		//starling = new Starling(StarlingStarter, Lib.current.stage, null, null, "auto", "auto");
		starling = new Starling(StarlingStarter, Lib.current.stage, new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight), null, "auto", "auto");
		
		_initialWidth = _stage.stageWidth;
		_initialHeight = _stage.stageHeight;
		
		starling.antiAliasing = 0;
		starling.enableErrorChecking = false;
		starling.showStats = showStats;
		
		starling.start();
	}
}