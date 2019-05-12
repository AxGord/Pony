package pony.js;

import js.html.CanvasElement;
import js.html.Element;
import js.Browser;
import pony.geom.Point;
import pony.geom.Rect;
import pony.events.Signal2;

@:enum abstract SmallDeviceQuality(Int) to Int {
	var ideal = 1;
	var low = 2;
	var normal = 3;
	var good = 4;
}

class SmartCanvas extends ElementResizeControl {

	private static inline var PX:String = 'px';

	@:auto public var onStageResize:Signal2<Float, Rect<Float>>;

	public var canvas(default, null):CanvasElement;
	public var stageWidth(default, null):Int = 0;
	public var stageHeight(default, null):Int = 0;
	public var stageInitSize(default, null):Point<Int>;
	public var scale(default, null):Float;
	public var ratio(default, null):Float;
	public var rect:Rect<Float>;

	public var smallDeviceQuality(default, set):SmallDeviceQuality;
	private var smallDeviceQualityOffset:Float;

	public function new(
		?size:Point<Int>,
		?parentDom:Element,
		smallDeviceQuality:SmallDeviceQuality = SmallDeviceQuality.ideal
	) {
		if (parentDom == null)
			parentDom = Browser.document.body;
		super(parentDom);
		canvas = Browser.document.createCanvasElement();
		canvas.style.position = 'static';
		if (size != null) {
			stageInitSize = size;
			stageWidth = size.x;
			stageHeight = size.y;
		}
		parentDom.appendChild(canvas);
		this.smallDeviceQuality = smallDeviceQuality;
		eStageResize.onTake << syncSize;
		eStageResize.onLost << unsyncSize;
	}

	public inline function set_smallDeviceQuality(q:SmallDeviceQuality):SmallDeviceQuality {
		if (this.smallDeviceQuality != q) {
			this.smallDeviceQuality = q;
			smallDeviceQualityOffset = 1 - 1 / q;
			setSize(width, height);
		}
		return q;
	}

	public dynamic function ratioMod(value:Float):Float return value;
	public function fullscreen():Void JsTools.fse(element);

	private function changeParentDomHandler(actual:Element, prev:Element):Void {
		prev.removeChild(canvas);
		actual.appendChild(canvas);
		resizeHandler();
	}

	private function syncSize():Void {
		changeElement << changeParentDomHandler;
		onResize << setSize;
		setSize(width, height);
	}

	private function unsyncSize():Void {
		changeElement >> changeParentDomHandler;
		onResize >> setSize;
	}

	public function setSize(w:Int, h:Int):Void {
		setCanvasSize(w, h);
		if (stageInitSize != null)
			setStageSize(w, h);
	}

	@:extern private inline function setCanvasSize(w:Int, h:Int):Void {
		canvas.style.width = w + PX;
		canvas.style.height = h + PX;
	}

	@:extern private inline function setStageSize(w:Int, h:Int):Void {
		var wd = w / stageInitSize.x;
		var hd = h / stageInitSize.y;
		scale = wd > hd ? hd : wd;
		
		ratio = (smallDeviceQuality:Int) <= 1 ? 1 : smallDeviceQualityOffset + scale / smallDeviceQuality;
		if (ratio > 1) ratio = 1;
		ratio = ratioMod(ratio);

		var wr:Float = width / scale * ratio;
		var hr:Float = height / scale * ratio;

		var xr:Float = 0;
		var yr:Float = 0;
		if (wd > hd)
			xr = (wr - stageInitSize.x * ratio) / 2;
		else
			yr = (hr - stageInitSize.y * ratio) / 2;
		
		rect = new Rect(xr, yr, wr, hr);
		eStageResize.dispatch(ratio, rect);
	}

}