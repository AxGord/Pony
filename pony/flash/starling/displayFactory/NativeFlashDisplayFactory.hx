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
package pony.flash.starling.displayFactory;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.DisplayFactory.IMovieClip;
import pony.flash.starling.displayFactory.DisplayFactory.ITextField;

/**
 * NativeFlashDisplayFactory
 * @author Maletin
 */
class NativeFlashDisplayFactory implements IDisplayFactory
{
	private static var _instance:NativeFlashDisplayFactory = new NativeFlashDisplayFactory();

	public function new() 
	{
		if (_instance != null) throw "Singletone creation error";
	}
	
	public static function getInstance():NativeFlashDisplayFactory { return _instance; }
	
	public function createSprite():IDisplayObjectContainer
	{
		return cast new Sprite();
	}
	
	public function createTextField(width:Float, height:Float, text:String):ITextField
	{
		var tf:TextField = new TextField();
		tf.width = width;
		tf.height = height;
		tf.text = text;
		return cast tf;
	}
	
	public function createMovieClip():IMovieClip
	{
		return cast new MovieClip();
	}
	
}