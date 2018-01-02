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
package pony.ui.gui;

/**
 * ZeroPlaceCore
 * @author AxGord <axgord@gmail.com>
 */
class ZeroPlaceCore<T> extends BaseLayoutCore<T> {
	
	override public function update():Void {
		if (objects == null) return;
		if (!ready) return;
		if (objects.length == 0) {
			_w = 0;
			_h = 0;
		} else if (objects.length == 1) {
			_w = getObjSize(objects[0]).x;
			_h = getObjSize(objects[0]).y;
			setXpos(objects[0], -_w/2);
			setYpos(objects[0], -_h/2);
		} else {
			_w = 0;
			_h = 0;
			for (obj in objects) {
				var sw = getObjSize(obj).x;
				var sh = getObjSize(obj).y;
				if (sw > _w) _w = sw;
				if (sh > _h) _h = sh;
				setXpos(obj, -sw/2);
				setYpos(obj, -sh/2);
			}
		}
	}
	
}