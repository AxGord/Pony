package pony.ui.gui;

import pony.events.Signal1;
import pony.geom.IWards;
import pony.magic.HasSignal;

/**
 * SwitchableList
 * @author AxGord
 */
class SwitchableList implements IWards implements HasSignal {

	@:auto public var change: Signal1<Int>;
	@:auto public var lostState: Signal1<Int>;
	public var currentPos(default, null): Int;

	private var list: Array<ButtonCore>;
	public var state(get, set): Int;
	private var swto: Int;
	private var ret: Bool;
	private var def: Int;

	public function new(a: Array<ButtonCore>, def: Int = 0, swto: Int = 2, ret: Bool = false) {
		this.swto = swto;
		this.ret = ret;
		this.def = def;
		state = def;
		list = a;
		for (i in 0...a.length) {
			if (i == def) {
				a[i].disable();
				a[i].mode = swto;
			}
			//select.listen(a[i].click.sub([0], [i]));
			a[i].onClick.sub(0).bind1(i).add(eChange);
			if (ret) a[i].onClick.sub(swto).bind1(i).add(changeRet);
		}
		change.add(setState, -1);
	}

	private function changeRet(): Void eChange.dispatch( -1 );

	private function setState(n: Int): Void {
		if (state == n) return;
		//if (list[state] != null) list[state].mode = 0;
		if (list[state] != null) {
			list[state].enable();
			list[state].mode = 0;
		}
		//if (list[n] != null) list[n].mode = swto;
		if (list[n] != null) {
			list[n].disable();
			list[n].mode = swto;
		}
		eLostState.dispatch(state);
		state = n;
	}

	public function next(): Void if (state + 1 < list.length) eChange.dispatch(state + 1);
	public function prev(): Void if (state - 1 >= 0) eChange.dispatch(state - 1);
	private inline function get_state(): Int return currentPos;
	private inline function set_state(v: Int): Int return currentPos = v;

}