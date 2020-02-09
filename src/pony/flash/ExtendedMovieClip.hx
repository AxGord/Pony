package pony.flash;

import flash.display.MovieClip;

/**
 * Adds Resize event
 * @author AxGord <axgord@gmail.com>
 */
@:native('ExtendedMovieClip') extern class ExtendedMovieClip extends MovieClip {

	public static var INIT: String;
	private function _gotoAndStop(frame: Dynamic, scene: String = null): Void;
	private function _gotoAndPlay(frame: Dynamic, scene: String = null): Void;
	private function _play(): Void;
	private function _stop(): Void;

}