/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.unity3d.scene;
import pony.ui.ButtonCore;
import pony.unity3d.ui.TintButton;
import unityengine.Color;
import unityengine.GameObject;
import unityengine.Material;
import unityengine.MonoBehaviour;
import unityengine.Renderer;
import unityengine.Transform;

using hugs.HUGSWrapper;
/**
 * Slice
 * @author BoBaH6eToH
 */
@:nativeGen class Slice extends TooltipSaver
{
	public var untransparentTexture:Material;
	public var buttonForSlice:GameObject;
	
	private var buttonSlice:ButtonCore;
	
	private var childrenMaterials:Array<Material>;
	
	override private function Start() 
	{
		super.Start();
		childrenMaterials = [for (e in getComponentsInChildrenOfType(Renderer)) e.material];
		buttonSlice = buttonForSlice.getTypedComponent(TintButton).core;
		buttonSlice.click.add(click);
	}
	
	inline private function click(mode:Int):Void 
	{
		if (mode == 2)
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = untransparentTexture;
		else {
			var i:Int = 0;
			for (e in getComponentsInChildrenOfType(Renderer)) e.material = childrenMaterials[i++];
		}
		saveColors();
	}
	
}