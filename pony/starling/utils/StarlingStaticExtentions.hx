package pony.starling.utils;
import starling.display.MovieClip;
import pony.starling.displayFactory.DisplayFactory.IMovieClip;

/**
 * StarlingStaticExtentions
 * @author Maletin
 */
class StarlingStaticExtentions 
{
	public static function gotoAndPlay1(clip:MovieClip, frame:Int):Void
	{
		clip.currentFrame = frame - 1;
		clip.play();
	}
	
	public static function gotoAndStop1(clip:MovieClip, frame:Int):Void
	{
		clip.currentFrame = frame - 1;
		clip.pause();
	}
	
	public static function gotoAndPlay(clip:IMovieClip, frame:Int):Void
	{
		if (Std.is(clip, starling.display.MovieClip)) gotoAndPlay1(cast clip, frame);
		if (Std.is(clip, flash.display.MovieClip)) untyped clip.gotoAndPlay(frame);
	}
	
	public static function gotoAndStop(clip:IMovieClip, frame:Int):Void
	{
		if (Std.is(clip, starling.display.MovieClip)) gotoAndStop1(cast clip, frame);
		if (Std.is(clip, flash.display.MovieClip)) untyped clip.gotoAndStop(frame);
	}
}