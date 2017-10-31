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
package pony.flash.ui;

import flash.display.MovieClip;
import flash.Lib;
#if starling
import pony.flash.starling.converter.StarlingConverter;
import pony.flash.starling.ui.StarlingWindow;
import pony.flash.starling.converter.IStarlingConvertible;
#end

/**
 * Window
 * @author AxGord <axgord@gmail.com>
 */
#if !starling
class Window extends MovieClip implements IWindow {
#else
class Window extends MovieClip implements IWindow implements IStarlingConvertible {
#end

	private var st:Windows;
	
	inline public function new() {
		super();
		visible = false;
	}
	
	inline public function initm(st:Windows):Void {
		this.st = st;
		init();
	}
	
	private function init():Void {}
	
	public function show():Void {
		st.blurOn();
		visible = true;
	}
	
	private function hide():Void {
		st.blurOff();
		visible = false;
	}

#if starling	
	public function convert(coordinateSpace:flash.display.DisplayObject):starling.display.DisplayObject
	{
		return new pony.flash.starling.ui.StarlingWindow(untyped pony.flash.starling.converter.StarlingConverter.getSprite(cast(this, flash.display.Sprite), coordinateSpace, false));
	}
#end

}