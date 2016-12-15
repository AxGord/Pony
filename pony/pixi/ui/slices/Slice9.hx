/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.pixi.ui.slices;

/**
 * Slice9
 * @author AxGord <axgord@gmail.com>
 */
class Slice9 extends SliceSprite {
	
	override private function init():Void {
		images[1].x = images[0].width - creep;
		images[3].y = images[0].height - creep;
		images[4].x = images[1].x;
		images[4].y = images[3].y;
		if (sliceWidth == null)
			sliceWidth = images[0].width + images[1].width + images[2].width;
		if (sliceHeight == null)
			sliceHeight = images[0].height + images[3].height + images[6].height;
		super.init();
	}
	
	override private function set_sliceWidth(v:Float):Float {
		sliceWidth = v;
		updateWidth();
		return v;
	}
	
	private function updateWidth():Void {
		if (!inited) return;
		images[1].width = sliceWidth - images[0].width - images[2].width + creep*2;
		images[2].x = images[0].width + images[1].width - creep*2;
		images[4].width = images[1].width;
		images[5].x = images[2].x;
		images[7].width = images[1].width;
		images[7].x = images[1].x;
		images[8].x = images[2].x;
	}
	
	override private function set_sliceHeight(v:Float):Float {
		sliceHeight = v;
		updateHeight();
		return v;
	}
	
	private function updateHeight():Void {
		if (!inited) return;
		images[3].height = sliceHeight - images[0].height - images[6].height + creep*2;
		images[6].y = images[0].height + images[3].height - creep*2;
		images[4].height = images[3].height;
		images[5].y = images[3].y;
		images[5].height = images[3].height;
		images[7].y = images[6].y;
		images[8].y = images[6].y;
	}
	
}