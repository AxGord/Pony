package pony.flash.ui;

import flash.display.MovieClip;
import flash.display.Sprite;
import pony.flash.FLStage;
import pony.geom.Angle;
import pony.ui.gui.TurningCore;

/**
 * Turning
 * @author AxGord <axgord@gmail.com>
 */
class Turning extends Sprite implements FLStage {

	@:stage private var handle: MovieClip;

	public var core: TurningCore;

	public function new() {
		super();
		core = new TurningCore();
		core.changeAngle << function(r: Angle) handle.rotation = r;
	}

}