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
import pony.time.DeltaTime;
import pony.ui.touch.starling.touchManager.TouchManager;
import unityengine.Vector3;
import unityengine.Input;

/**
 * UnityTouchInput
 * @author Maletin
 */
class UnityTouchInput
{
	public function new() 
	{
		DeltaTime.update.add(update);
	}
	
	public function update():Void
	{
		var mousePos = Input.mousePosition;

		if (Input.GetMouseButtonDown(0))
		{
			TouchManager.down(mousePos.x, mousePos.y, false);
		}
		else if (Input.GetMouseButtonUp(0))
		{
			TouchManager.up(mousePos.x, mousePos.y, false);
		}
		else
		{
			TouchManager.move(mousePos.x, mousePos.y, false);
		}
		
		//TODO: Mousewheel
	}
	
}