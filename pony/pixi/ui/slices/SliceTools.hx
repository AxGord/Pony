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

using StringTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
class SliceTools {

	static public function getSliceSprite(name:String, ?useSpriteSheet:String, creep:Float = 0):SliceSprite {
		return getSliceSpriteFromData(parseSliceName(name), useSpriteSheet, creep);
	}
	
	static public function parseSliceName(name:String):SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2(slice(name, 2, 'v'));
		else if (check(name, 2, 'h'))
			SliceData.Hor2(slice(name, 2, 'h'));
		else if (check(name, 3, 'v'))
			SliceData.Vert3(slice(name, 3, 'v'));
		else if (check(name, 3, 'h'))
			SliceData.Hor3(slice(name, 3, 'h'));
		else if (check(name, 4))
			SliceData.Four(slice(name, 4));
		else if (check(name, 6, 'v'))
			SliceData.Vert6(slice(name, 6, 'v'));
		else if (check(name, 6, 'h'))
			SliceData.Hor6(slice(name, 6, 'h'));
		else if (check(name, 9))
			SliceData.Nine(slice(name, 9));
		else
			SliceData.Not(name);
	}
	
	@:extern inline static private function check(name:String, n:Int, letter:String = ''):Bool {
		return name.indexOf('{slice$n$letter}') != -1;
	}
	
	static private function slice(name:String, n:Int, letter:String = ''):Array<String> {
		var s = name.split('{slice$n$letter}');
		return [for (i in 0...n) s[0]+i+s[1]];
	}
	
	static public function getSliceSpriteFromData(data:SliceData, ?useSpriteSheet:String, creep:Float = 0):SliceSprite {
		return switch data {
			case SliceData.Hor2(a):
				new Slice2H(a, useSpriteSheet, creep);
			case SliceData.Hor3(a):
				new Slice3H(a, useSpriteSheet, creep);
			case SliceData.Vert2(a):
				new Slice2V(a, useSpriteSheet, creep);
			case SliceData.Vert3(a):
				new Slice3V(a, useSpriteSheet, creep);
			case SliceData.Four(a):
				new Slice4(a, useSpriteSheet, creep);
			case SliceData.Hor6(a):
				new Slice6H(a, useSpriteSheet, creep);
			case SliceData.Vert6(a):
				new Slice6V(a, useSpriteSheet, creep);
			case SliceData.Nine(a):
				new Slice9(a, useSpriteSheet, creep);
			case SliceData.Not(s):
				new SliceSprite([s], useSpriteSheet);
		}
	}
	
}