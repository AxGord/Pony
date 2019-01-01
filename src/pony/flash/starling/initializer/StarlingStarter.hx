package pony.flash.starling.initializer;

import flash.Lib;
import starling.display.Quad;
import starling.display.Sprite;

/**
 * Starter
 * @author Maletin
 */
class StarlingStarter extends Sprite
{
	public function new() 
	{
		super();
		
		var bgQuad:Quad = new Quad(Lib.current.stage.stageWidth, Lib.current.stage.stageWidth, 0x0);
		bgQuad.alpha = 0;
		bgQuad.touchable = true;
		addChildAt(bgQuad, 0);		
	}
}