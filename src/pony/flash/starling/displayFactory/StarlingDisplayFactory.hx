package pony.flash.starling.displayFactory;

import starling.display.Sprite;
import starling.text.TextField;
import starling.display.MovieClip;
import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.DisplayFactory.IMovieClip;
import pony.flash.starling.displayFactory.DisplayFactory.ITextField;

/**
 * StarlingDisplayFactory
 * @author Maletin
 */
class StarlingDisplayFactory implements IDisplayFactory {

	private static var _instance: StarlingDisplayFactory = new StarlingDisplayFactory();

	public function new() {
		if (_instance != null)
			throw 'Singletone creation error';
	}

	public static function getInstance(): StarlingDisplayFactory {
		return _instance;
	}

	public function createSprite(): IDisplayObjectContainer {
		return cast new Sprite();
	}

	public function createTextField(width: Float, height: Float, text: String): ITextField {
		return cast new TextField(Std.int(width), Std.int(height), text);
	}

	public function createMovieClip(): IMovieClip {
		// return cast new MovieClip();
		throw 'Starling movieclip creation not implemented yet';
		return null;
	}

}