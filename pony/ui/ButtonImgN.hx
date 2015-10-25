package pony.ui;

import pony.events.Signal1;
import pony.touch.TouchebleBase;
import pony.ui.ButtonCore;

/**
 * ButtonImgN
 * @author AxGord <axgord@gmail.com>
 */
class ButtonImgN extends ButtonCore {

	@:auto public var onImg:Signal1<Int>;
	
	public function new(t:TouchebleBase) {
		super(t);
		onVisual << visualHandler;
	}
	
	private function visualHandler(mode:Int, state:ButtonState):Void {
		if (mode == 1) {
			eImg.dispatch(4);
			return;
		}
		var n = switch state {
			case Default: 1;
			case Focus: 2;
			case Press: 3;
			case Leave : 2;
		}
		if (mode > 1) n += (mode-1) * 3 + 1;
		eImg.dispatch(n);
	}
	
}