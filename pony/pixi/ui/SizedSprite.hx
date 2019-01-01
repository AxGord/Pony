package pony.pixi.ui;

import pixi.core.sprites.Sprite;
import pony.geom.IWH;
import pony.geom.Point;

/**
 * SizedSprite
 * @author AxGord <axgord@gmail.com>
 */
class SizedSprite extends Sprite implements IWH {

	public var size(get, never):Point<Float>;
	
	private var _size:Point<Float>;
	
	public function new(p:Point<Float>) {
		_size = p;
		super();
	}
	
	public function wait(cb:Void->Void):Void cb();
	
	private function get_size():Point<Float> return _size;
	
	public function destroyIWH():Void destroy();
	
}