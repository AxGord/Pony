package pony.flash.starling.displayFactory;

import pony.flash.starling.displayFactory.DisplayFactory.IDisplayObjectContainer;
import pony.flash.starling.displayFactory.DisplayFactory.IMovieClip;
import pony.flash.starling.displayFactory.DisplayFactory.ITextField;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.text.TextField;

/**
 * StarlingDisplayFactory
 * @author Maletin
 */
class StarlingDisplayFactory implements IDisplayFactory {

	private static final _instance: StarlingDisplayFactory = new StarlingDisplayFactory();

	public function new() {
		if (_instance != null) throw 'Singletone creation error';
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
	}

	public static function getInstance(): StarlingDisplayFactory {
		return _instance;
	}

}
