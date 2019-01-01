package pony.pixi.ui.slices;

/**
 * Slice9
 * @author AxGord <axgord@gmail.com>
 */
class Slice9 extends SliceSprite {
	
	override private function init():Void {
		images[1].x = images[0].width - creep;
		images[3].y = images[0].height - creep;
		images[4].x = images[1].x;
		images[4].y = images[3].y;
		if (sliceWidth == null)
			sliceWidth = images[0].width + images[1].width + images[2].width;
		if (sliceHeight == null)
			sliceHeight = images[0].height + images[3].height + images[6].height;
		super.init();
	}
	
	override private function set_sliceWidth(v:Float):Float {
		sliceWidth = v;
		updateWidth();
		return v;
	}
	
	private function updateWidth():Void {
		if (!inited) return;
		images[1].width = sliceWidth - images[0].width - images[2].width + creep*2;
		images[2].x = images[0].width + images[1].width - creep*2;
		images[4].width = images[1].width;
		images[5].x = images[2].x;
		images[7].width = images[1].width;
		images[7].x = images[1].x;
		images[8].x = images[2].x;
	}
	
	override private function set_sliceHeight(v:Float):Float {
		sliceHeight = v;
		updateHeight();
		return v;
	}
	
	private function updateHeight():Void {
		if (!inited) return;
		images[3].height = sliceHeight - images[0].height - images[6].height + creep*2;
		images[6].y = images[0].height + images[3].height - creep*2;
		images[4].height = images[3].height;
		images[5].y = images[3].y;
		images[5].height = images[3].height;
		images[7].y = images[6].y;
		images[8].y = images[6].y;
	}
	
}