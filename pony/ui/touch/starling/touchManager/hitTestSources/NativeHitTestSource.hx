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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.geom.Point;
import flash.text.TextField;

/**
 * ...
 * @author Maletin
 */
class NativeHitTestSource implements IHitTestSource
{
	private var _container:DisplayObjectContainer;
	private var _point:Point = new Point();

	public function new(container:DisplayObjectContainer) 
	{
		_container = container;
	}
	
	/* INTERFACE touchManager.hitTestSources.IHitTestSource */
	
	public function hitTest(x:Float, y:Float):Dynamic 
	{
		_point.x = x;
		_point.y = y;
		
		//getChildAt(0).globalToLocal is needed because otherwise it won't work with scaled sprites for some reason.
		//Should work with all the projects initialized with Initializer class, but not tested in other situations.
		_point = _container.getChildAt(0).globalToLocal(_point);
		return childUnderPoint(_point.x, _point.y, _container);
	}
	
	private function childUnderPoint(x:Float, y:Float, container:DisplayObjectContainer, testShape:Bool = true):Dynamic
	{
		if (!container.mouseChildren && container.mouseEnabled && container.visible) return container;
		if ((!container.mouseChildren && !container.mouseEnabled) || !container.visible) return null;
		var i:Int = container.numChildren - 1;
		while (i >= 0)
		{
			var child:DisplayObject = container.getChildAt(i);
			if (child == null || !child.visible)
			{
				i--;
				continue;
			}
			if (child.hitTestPoint(x, y, testShape))
			{
				if (Std.is(child, DisplayObjectContainer))
				{
					var containerChild:Dynamic = childUnderPoint(x, y, cast child, testShape);
					if (containerChild != null) return containerChild;
				}
				else if (Std.is(child, InteractiveObject))
				{
					if (untyped child.mouseEnabled && !isStaticTextField(child)) return child;
				}
			}
			
			i--;
		}
		
		if (container.mouseEnabled) return container;
		return null;
	}
	
	private inline function isStaticTextField(child:DisplayObject):Bool
	{
		//If it's a textfield with no name, then it's static textfield
		return ( child.name.indexOf("instance") != -1 && Std.is(child, TextField) );
	}
	
	public function parent(object:Dynamic):Dynamic
	{
		if (!Std.is(object, flash.display.DisplayObject)) return null;
		if (object == _container) return null;
		var objectsParent = object.parent;
		return objectsParent;
	}
	
}