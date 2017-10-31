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
package pony.flash.starling.initializer;

import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import starling.core.Starling;



/**
 * StarlingCreator
 * @author Maletin
 */
class StarlingCreator 
{
	public var starling:Starling;
	private var _stage:Stage;
	private var _initialWidth:Int;
	private var _initialHeight:Int;

	public function new(showStats:Bool) 
	{
		_stage = Lib.current.stage;
		
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		
		//starling = new Starling(StarlingStarter, Lib.current.stage, null, null, "auto", "auto");
		starling = new Starling(StarlingStarter, Lib.current.stage, new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight), null, "auto", "auto");
		
		_initialWidth = _stage.stageWidth;
		_initialHeight = _stage.stageHeight;
		
		starling.antiAliasing = 0;
		starling.enableErrorChecking = false;
		starling.showStats = showStats;
		
		starling.start();
	}
}