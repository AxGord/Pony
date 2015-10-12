package pony.touchManager;

import pony.events.Signal0;
import pony.magic.HasSignal;

/**
 * Toucheble
 * @author AxGord <axgord@gmail.com>
 */
class TouchebleBase implements HasSignal {

	@:auto public var onOver:Signal0;
	@:auto public var onOut:Signal0;
	@:auto public var onOutUp:Signal0;
	@:auto public var onOverDown:Signal0;
	@:auto public var onOutDown:Signal0;
	@:auto public var onDown:Signal0;
	@:auto public var onUp:Signal0;
	@:auto public var onClick:Signal0;
	
	public function new() {}
	
}