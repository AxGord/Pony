package pony.pixi.ui.slices;

using pony.pixi.PixiExtends;

/**
 * Slice2V
 * @author AxGord <axgord@gmail.com>
 */
class Slice2V extends Slice3V {

	public function new(data: Array<String>, ?useSpriteSheet: String, creep: Float = 0) {
		data.push(data[0]);
		super(data, useSpriteSheet, creep);
	}

	override private function init(): Void {
		super.init();
		images[2].flipY();
	}

	override private function update(): Void {
		if (!inited) return;
		super.update();
		images[2].flipYpos();
	}

}
