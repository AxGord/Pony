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