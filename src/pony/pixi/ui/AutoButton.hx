package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.math.shapes.Rectangle;
import pixi.core.renderers.webgl.filters.Filter;
import pixi.core.sprites.Sprite;
import pixi.filters.colormatrix.ColorMatrixFilter;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.touch.Touchable;

/**
 * AutoButton
 * @author AxGord <axgord@gmail.com>
 */
class AutoButton extends Sprite implements IWH {

	private static var GRAY_FILTER:Array<Filter>;
	private static var LIGHT_FILTER:Array<Filter>;
	private static var DARK_FILTER:Array<Filter>;
	
	private static function __init__():Void {
		var f = new ColorMatrixFilter();
		f.kodachrome(true);
		LIGHT_FILTER = [f];
		var f = new ColorMatrixFilter();
		f.desaturate(true);
		GRAY_FILTER = [f];
		var f = new ColorMatrixFilter();
		f.vintage(true);
		DARK_FILTER = [f];
	}
	
	public var size(get, never):Point<Float>;
	private var _size:Point<Float>;
	
	public var core(default, null):ButtonCore;
	private var img:Sprite;
	
	public function new(s:Sprite) {
		super();
		s.pivot.set(s.width / 2, s.height / 2);
		s.position = s.pivot;
		addChild(img = s);
		_size = new Point<Float>(s.width, s.height);
		hitArea = new Rectangle(0, 0, s.width, s.height);
		core = new ButtonCore(new Touchable(this));
		core.onVisual << visualHandler;
	}
	
	private function visualHandler(mode:Int, state:ButtonState):Void {
		if (mode == 1) {
			buttonMode = false;
			img.filters = GRAY_FILTER;
		} else {
			buttonMode = true;
			
			switch state {
				case ButtonState.Default:
					img.filters = null;
					img.scale.set(1);
				case ButtonState.Focus, ButtonState.Leave:
					img.filters = LIGHT_FILTER;
					img.scale.set(1.05);
				case ButtonState.Press:
					img.filters = DARK_FILTER;
					img.scale.set(0.95);
			}
		}
	}
	
	private function get_size():Point<Float> return _size;
	public function wait(cb:Void -> Void):Void cb();
	public function destroyIWH():Void destroy();
	
}