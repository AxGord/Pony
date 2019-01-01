package pony.pixi.ui.slices;

/**
 * Slice3V
 * @author AxGord <axgord@gmail.com>
 */
class Slice3V extends SliceSprite {
	
	override private function init():Void {
		images[1].y = images[0].height - creep;
		if (sliceHeight == null)
			sliceHeight = images[0].height + images[1].height + images[2].height;
		super.init();
	}
	
	override private function set_sliceHeight(v:Float):Float {
		sliceHeight = v;
		update();
		return v;
	}
	
	private function update():Void {
		if (!inited) return;
		images[1].height = sliceHeight - images[0].height - images[2].height + creep * 2;
		images[2].y = images[0].height + images[1].height - creep * 2;
	}
	
}