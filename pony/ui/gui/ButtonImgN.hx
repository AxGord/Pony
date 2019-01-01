package pony.ui.gui;

import pony.events.Signal1;
import pony.ui.touch.TouchableBase;
import pony.ui.gui.ButtonCore;

/**
 * ButtonImgN
 * @author AxGord <axgord@gmail.com>
 */
class ButtonImgN extends ButtonCore {

	@:auto public var onImg:Signal1<Int>;
	
	public function new(t:TouchableBase) {
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