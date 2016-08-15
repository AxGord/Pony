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

using StringTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
class SliceTools {

	static public function getSliceSprite(name:String, ?useSpriteSheet:String):SliceSprite {
		return getSliceSpriteFromData(parseSliceName(name), useSpriteSheet);
	}
	
	static public function parseSliceName(name:String):SliceData {
		return if (name.indexOf('{slice2v}') != -1) {
			var s = name.split('{slice2v}');
			SliceData.Vert2(s[0]+'0'+s[1], s[0]+'1'+s[1]);
		} else if (name.indexOf('{slice2h}') != -1) {
			var s = name.split('{slice2h}');
			SliceData.Hor2(s[0]+'0'+s[1], s[0]+'1'+s[1]);
		} else if (name.indexOf('{slice3v}') != -1) {
			var s = name.split('{slice3v}');
			SliceData.Vert3(s[0]+'0'+s[1], s[0]+'1'+s[1], s[0]+'2'+s[1]);
		} else if (name.indexOf('{slice3h}') != -1) {
			var s = name.split('{slice3h}');
			SliceData.Hor3(s[0]+'0'+s[1], s[0]+'1'+s[1], s[0]+'2'+s[1]);
		} else if (name.indexOf('{slice4}') != -1) {
			var s = name.split('{slice4}');
			SliceData.Four([for (i in 0...4) s[0]+i+s[1]]);
		} else if (name.indexOf('{slice9}') != -1) {
			var s = name.split('{slice9}');
			SliceData.Nine([for (i in 0...9) s[0]+i+s[1]]);
		} else {
			SliceData.Not(name);
		}
	}
	
	static public function getSliceSpriteFromData(data:SliceData, ?useSpriteSheet:String):SliceSprite {
		return switch data {
			case SliceData.Hor2(a, b):
				new Slice2H([a, b], useSpriteSheet);
			case SliceData.Hor3(a, b, c):
				new Slice3H([a, b, c], useSpriteSheet);
			case SliceData.Vert2(a, b):
				new Slice2V([a, b], useSpriteSheet);
			case SliceData.Vert3(a, b, c):
				new Slice3V([a, b, c], useSpriteSheet);
			case SliceData.Four(a):
				new Slice4(a, useSpriteSheet);
			case SliceData.Nine(a):
				new Slice9(a, useSpriteSheet);
			case SliceData.Not(s):
				new SliceSprite([s], useSpriteSheet);
		}
	}
	
}