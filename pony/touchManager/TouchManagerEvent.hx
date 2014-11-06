package pony.touchManager;

/**
 * ...
 * @author Maletin
 */
 
class TouchManagerEvent
{
	public var type:TouchEventType;
	
	public var mouseOver:Bool;
	
	public var globalX:Float;
	public var globalY:Float;
	
	public var previousGlobalX:Float;
	public var previousGlobalY:Float;
	
	public var value:Float;
	
	public var gesture:TouchManagerGesture;
	
	public var speedX:Float;
	public var speedY:Float;
	

	public function new()
	{
		
	}
	
}