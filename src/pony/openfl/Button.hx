package pony.openfl;

import openfl.display.Sprite;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;

/**
 * Button
 * @author AxGord <axgord@gmail.com>
 */
class Button extends Sprite {

	public var core(default, null): ButtonImgN;

	private final states: Array<SBitmap>;
	private var zone: SBitmap;

	public function new(states: Array<String>) {
		super();
		final created: Map<String, SBitmap> = [];
		this.states = [
			for (s in states) {
				if (s == null)
					null;
				else if (created.exists(s))
					created[s];
				else {
					final b = new SBitmap(s);
					addChild(b);
					b.visible = false;
					created[s] = b;
				}
			}
		];
		this.states[0].visible = true;
		if (this.states.length > 3) {
			zone = this.states[3] == null ? new SBitmap(states[0]) : this.states[3];
			this.states.splice(3, 1);
		} else {
			zone = new SBitmap(states[0]);
		}
		final z = new Sprite();
		z.addChild(zone);
		z.alpha = 0;
		z.buttonMode = true;
		addChild(z);
		core = new ButtonImgN(new Touchable(z));
		core.onImg << change;

	}

	private function change(img: Int): Void {
		img--;
		for (b in states) if (b != null) b.visible = false;
		if (img == 3 && states[img] == null) {
			zone.visible = false;
			return;
		} else {
			zone.visible = true;
		}
		if (img >= states.length) img = states.length - 1;
		while (states[img] == null) img--;
		states[img].visible = true;
	}

}
