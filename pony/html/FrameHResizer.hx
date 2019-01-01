package pony.html;

import js.html.MouseEvent;

/**
 * Frame horizontal resizer
 * @author AxGord <axgord@gmail.com>
 */
class FrameHResizer extends FrameBaseResizer {

	public function new(frameA:String, resizer:String, frameB:String, frameAMin:Int, frameBMin:Int) {
		super(frameA, resizer, frameB, frameAMin, frameBMin);
	}

	override private function get_sizeA():Int return frameA.clientHeight;
	override private function get_sizeB():Int return frameB.clientHeight;

	override private function set_posA(v:Int):Int {
		frameA.style.height = v + 'px';
		return v;
	}

	override private function set_posB(v:Int):Int {
		frameB.style.bottom = v + 'px';
		resizer.style.bottom = (v - (resizer.clientHeight / 2)) + 'px';
		return v;
	}

	override private function getMousePos(e:MouseEvent):Int return e.clientY;

}