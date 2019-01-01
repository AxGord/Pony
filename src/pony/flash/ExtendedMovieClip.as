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