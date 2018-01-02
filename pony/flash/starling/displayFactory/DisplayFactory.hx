/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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