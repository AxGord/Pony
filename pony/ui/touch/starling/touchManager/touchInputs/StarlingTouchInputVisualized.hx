/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.touch.starling.touchManager.touchInputs;

import flash.geom.Point;
import flash.Vector;
import pony.ui.touch.starling.touchManager.InputMode;
import pony.ui.touch.starling.touchManager.TouchManager;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

/**
 * ...
 * @author Maletin
 */
class StarlingTouchInputVisualized extends StarlingTouchInput
{
	private var _visualizers:Map<Int, DisplayObject> = new Map<Int, DisplayObject>();

	public function new(displayObject:DisplayObjectContainer) 
	{
		super(displayObject);
	}
	
	override private function onTouch(e:TouchEvent):Void
	{
		super.onTouch(e);
		
		var touches:Vector<Touch> = e.getTouches(cast(e.target, DisplayObject));
		for (i in 0...touches.length)
		{		
			var touch:Touch = touches[i];
			
			if (touch == null) return;

			if (touch.phase == TouchPhase.BEGAN)
			{
				addVisualizer(touch);
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				destroyVisualizer(touch);
			}
			
			
			if ( (touch.phase == TouchPhase.MOVED) ||
				( (touch.phase == TouchPhase.HOVER) && (!InputMode.touchMode()) ) )
			{
				moveVisualizer(touch);
			}
		}
	}	
	
	private function addVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id))
		{
			var tf:TextField = new TextField(200, 50, ("" + touch.id));
			tf.border = true;
			tf.touchable = false;
			untyped _displayObject.addChild(tf);
			
			_visualizers.set(touch.id, tf);
		}
		
		moveVisualizer(touch);
	}
	
	private function moveVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id)) return;
		
		var tf = _visualizers.get(touch.id);
		
		var point:Point = new Point(touch.globalX, touch.globalY);
		point = _displayObject.globalToLocal(point);
		
		tf.x = point.x;
		tf.y = point.y;
	}
	
	private function destroyVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id)) return;
		
		var tf = _visualizers.get(touch.id);
		untyped _displayObject.removeChild(tf);
		_visualizers.remove(touch.id);
	}
	
}