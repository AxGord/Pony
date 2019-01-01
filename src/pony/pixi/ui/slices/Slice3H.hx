package pony.pixi.ui.slices;

/**
 * Slice3H
 * @author AxGord <axgord@gmail.com>
 */
class Slice3H extends SliceSprite {
	
	override private function init():Void {
		images[1].x = images[0].width - creep;
		if (sliceWidth == null)
			sliceWidth = images[0].width + images[1].width + images[2].width;
		super.init();
	}
	
	override private function set_sliceWidth(v:Float):Float {
		sliceWidth = v;
		update();
		return v;
	}
	
	private function update():Void {
		if (!inited) return;
		images[1].width = sliceWidth - images[0].width - images[2].width + creep * 2;
		images[2].x = images[0].width + images[1].width - creep * 2;
	}
	
}