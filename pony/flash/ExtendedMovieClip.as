/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package {

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Adds Resize event
	 * @author AxGord
	 */

	public class ExtendedMovieClip extends MovieClip
	{
		public static var INIT:String = 'init';
		
		public function ExtendedMovieClip() {
			HaxeInit.init();
			super();
			tabChildren = false;
			tabEnabled = false;
			addEventListener(Event.ENTER_FRAME, init);
		}
		
		private function init(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, init);
			dispatchEvent(new Event(INIT));
		}
		
		override public function set scaleX(value:Number):void {
			if (super.scaleX == value) return;
			super.scaleX = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function set scaleY(value:Number):void {
			if (super.scaleY == value) return;
			super.scaleY = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function set width(value:Number):void {
			if (super.width == value) return;
			super.width = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		override public function set height(value:Number):void {
			if (super.width == value) return;
			super.height = value;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public override function gotoAndStop(frame:Object,scene:String=null):void {
			_gotoAndStop(frame, scene);
		}
		public override function gotoAndPlay(frame:Object,scene:String=null):void {
			_gotoAndPlay(frame, scene);
		}
		
		override public function stop():void {
			_stop();
		}
		
		override public function play():void {
			_play();
		}
		
		protected function _gotoAndStop(frame:*,scene:String=null):void {
			super.gotoAndStop(frame, scene);
		}
		protected function _gotoAndPlay(frame:*,scene:String=null):void {
			super.gotoAndPlay(frame, scene);
		}
		
		protected function _play():void {
			super.play();
		}
		
		protected function _stop():void {
			super.stop();
		}
		
	}

}