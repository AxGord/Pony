package pony.ui.touch.starling.touchManager;
import pony.ui.gui.ButtonCore;

/**
 * ...
 * @author Maletin
 */
class ButtonCoreTM extends ButtonCore
{

	public function new(object:Dynamic) 
	{
		super();
		
		TouchManager.addListener(object, touchManagerListener);
	}
	
	public function touchManagerListener(e:TouchManagerEvent):Void
	{		
		eventsTransition(e, this);
	}
	
	public static function eventsTransition(e:TouchManagerEvent, core:ButtonCore):Void
	{
		switch (e.type)
		{
			case Hover:
				core.mouseOver(false);
			case Over:
				core.mouseDown();
				core.mouseOver(true);
			case Down:
				core.mouseOver(false);
				core.mouseDown();
			case Up:
				core.mouseUp();
				core.mouseOut();
			case Out:
				core.mouseOut();
				core.mouseUp();
				core.mouseOver(false);
			case HoverOut:
				core.mouseOut();
			default:
		}
	}
	
}