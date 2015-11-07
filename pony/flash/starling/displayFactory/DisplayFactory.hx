package pony.flash.starling.displayFactory;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * DisplayFactory
 * @author Maletin
 */
typedef IDisplayObject = {
	var alpha:Float;
	var height:Float;
	var name:String;
	var parent:IDisplayObjectContainer;
	var rotation:Float;//Degrees / Rads!!!
	var scaleX:Float;
	var scaleY:Float;
	var stage:IDisplayObjectContainer;
	var visible:Bool;
	var width:Float;
	var x:Float;
	var y:Float;
	function getBounds(targetSpace:IDisplayObject):Rectangle;
	function globalToLocal(globalPoint:Point):Point;
	function localToGlobal(localPoint:Point):Point;
}

typedef IDisplayObjectContainer = {
	> IDisplayObject,
	var numChildren:Int;
	function addChild(child:IDisplayObject):IDisplayObject;
	function addChildAt(child:IDisplayObject, index:Int):IDisplayObject;
	function contains(child:IDisplayObject):Bool;
	function getChildAt(index:Int):IDisplayObject;
	function getChildByName(name:String):IDisplayObject;
	function getChildIndex(child:IDisplayObject):Int;
	function removeChild(child:IDisplayObject):IDisplayObject;
	function removeChildAt(index:Int):IDisplayObject;	
	function setChildIndex(child:IDisplayObject, index:Int):Void;
	function swapChildren(child1:IDisplayObject, child2:IDisplayObject):Void;
	function swapChildrenAt(index1:Int, index2:Int):Void;
}
	
typedef IMovieClip = {
	> IDisplayObject,//TODO container?
	var currentFrame:Int;
	//numframes/totalframes
	function play():Void;
	function stop():Void;//Different behavior?
	//function addChild(child:IDisplayObject):Void;
}

typedef ITextField = {
	> IDisplayObject,
	var border:Bool;
	var text:String;
}
 
class DisplayFactory 
{
	#if starling
		private static var _current:IDisplayFactory = StarlingDisplayFactory.getInstance();
	#else
		private static var _current:IDisplayFactory = NativeFlashDisplayFactory.getInstance();
	#end
	
	public static function createSprite():IDisplayObjectContainer
	{
		return _current.createSprite();
	}
	
	public static function createTextField(width:Float, height:Float, text:String):ITextField
	{
		return _current.createTextField(width, height, text);
	}
	
	public static function createMovieClip():IMovieClip
	{
		return _current.createMovieClip();
	}
	
}