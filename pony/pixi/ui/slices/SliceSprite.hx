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
package pony.pixi.ui.slices;

import pixi.core.sprites.Sprite;

using pony.pixi.PixiExtends;

/**
 * SliceSprite
 * @author AxGord <axgord@gmail.com>
 */
class SliceSprite extends Sprite {
	
	public var sliceWidth(default, set):Float;
	public var sliceHeight(default, set):Float;
	
	private var inited:Bool = false;
	private var images:Array<Sprite>;
	private var creep:Float;
	
	public function new(data:Array<String>, ?useSpriteSheet:String, creep:Float = 0) {
		super();
		this.creep = creep;
		if (useSpriteSheet != null)
			images = [for (e in data) PixiAssets.image(useSpriteSheet, e)];
		else
			images = [for (e in data) PixiAssets.image(e)];
		images.loadedList(init);
	}
	
	private function init():Void {
		inited = true;
		if (sliceWidth != null) {
			sliceWidth = sliceWidth;
		} else {
			sliceWidth = images[0].width;
		}
		if (sliceHeight != null) {
			sliceHeight = sliceHeight;
		} else {
			sliceHeight = images[0].height;
		}
		for (img in images) addChild(img);
	}
	
	private function set_sliceWidth(v:Float):Float {
		sliceWidth = v;
		if (!inited) return v;
		for (img in images) img.width = v;
		return v;
	}
	
	private function set_sliceHeight(v:Float):Float {
		sliceHeight = v;
		if (!inited) return v;
		for (img in images) img.height = v;
		return v;
	}
	
	
}