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
package pony.ui.touch.starling.touchManager.hitTestSources;
import flash.geom.Point;
import starling.display.DisplayObjectContainer;
import starling.core.Starling;

/**
 * ...
 * @author Maletin
 */
class StarlingHitTestSource implements IHitTestSource
{
	private var _container:DisplayObjectContainer;
	private var _point:Point = new Point();

	public function new(container:DisplayObjectContainer) 
	{
		_container = container;
	}
	
	/* INTERFACE touchManager.IHitTestSource */
	
	public function hitTest(x:Float, y:Float):Dynamic 
	{
		_point.x = x - Starling.current.viewPort.x;
		_point.y = y - Starling.current.viewPort.y;
		return _container.hitTest(_container.globalToLocal(_point), true);
	}
	
	public function parent(object:Dynamic):Dynamic
	{
		if (!Std.is(object, starling.display.DisplayObject)) return null;
		if (object == _container) return null;
		var objectsParent = object.parent;
		return objectsParent;
	}
	
}