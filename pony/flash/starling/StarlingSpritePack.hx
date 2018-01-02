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
package pony.flash.starling;

import flash.display.BitmapData;
import pony.flash.FLTools;
import pony.flash.starling.converter.AtlasCreator;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/**
 * StarlingSpritePack
 * @author AxGord
 */
class StarlingSpritePack extends Sprite {

	private var data:Array<Image>;
	
	public var currentFrame(default, set):Int = 0;
	
	public function new(a:Array<Image>) {
		super();
		data = a;
		addChild(a[0]);
	}
	
	public function set_currentFrame(frame:Int):Int {
		if (frame < 0 || frame >= data.length) throw 'Uncorrect frame';
		//trace(frame);
		removeChild(data[currentFrame]);
		addChild(data[frame]);
		currentFrame = frame;
		return frame;
	}
	
	public static function builder(_atlasCreator:AtlasCreator, source:flash.display.DisplayObject, coordinateSpace:flash.display.DisplayObject, disposeable:Bool = false):starling.display.DisplayObject {
		var m:SpritePack = cast source;
		var a:Array<Image> = [];
		
		for (f in 1...(m.totalFrames + 1)) {
			m.gotoAndStop(f);
			var bitmap:BitmapData = new BitmapData(Std.int(Math.min(FLTools.width, m.width)), Std.int(Math.min(FLTools.height, m.height)));
			bitmap.draw(m);
			a.push(new Image(Texture.fromBitmapData(bitmap)));
			bitmap.dispose();
		}
		return new StarlingSpritePack(a);
	}
	
}