package pony.ui.gui;

import pony.time.DT;
import pony.time.DeltaTime;

/**
 * SmoothBarCore
 * @author AxGord <axgord@gmail.com>
 */
class SmoothBarCore extends BarCore {

	@:bindable public var smooth:Bool = false;
	
	@:bindable public var smoothPercent:Float = 0;
	@:bindable public var smoothPos:Float = 0;
	
	@:extern inline
	public static function create(width:Float, height:Float, invert:Bool=false):SmoothBarCore {
		var isVert = height > width;
		return new SmoothBarCore(isVert ? height : width, isVert, invert);
	}
	
	public function new(size:Float, isVertical:Bool = false, invert:Bool = false) {
		super(size, isVertical, invert);
		changeSmooth - true << enableSmoothPercent;
		changeSmooth - false << disableSmoothPercent;
		if (isVertical) {
			changeSmoothPos << function(v) smoothChangeY(inv(v));
		} else {
			changeSmoothPos << function(v) smoothChangeX(inv(v));
		}
	}
	
	private function enableSmoothPercent():Void {
		changePercent << updateSmoothPercentTarget;
	}
	
	private function disableSmoothPercent():Void {
		changePercent >> updateSmoothPercentTarget;	
	}
	
	private function updateSmoothPercentTarget(p:Float):Void {
		if (p != smoothPercent)
			DeltaTime.fixedUpdate << updateSmoothPercent;
	}
	
	private function updateSmoothPercent(dt:DT):Void {
		var d = percent - smoothPercent;
		var n = smoothPercent + dt * d * (1000 / 200);
		if (d > 0) {
			if (n >= percent - 0.001) {
				n = percent;
				DeltaTime.fixedUpdate >> updateSmoothPercent;
			}
		} else {
			if (n <= percent + 0.001) {
				n = percent;
				DeltaTime.fixedUpdate >> updateSmoothPercent;
			}
		}
		smoothPercent = n;
		changeSmoothPercentHandler(smoothPercent);
	}
	
	@:extern inline private function changeSmoothPercentHandler(v:Float):Void smoothPos = v * size;
	
	/**
	 * Use this method for connect view
	 */
	dynamic public function smoothChangeX(v:Float):Void { }
	
	/**
	 * Use this method for connect view
	 */
	dynamic public function smoothChangeY(v:Float):Void {}
	
	override public function endInit():Void {
		super.endInit();
		if (isVertical) {
			smoothChangeY(inv(0));
		} else {
			smoothChangeX(inv(0));
		}
	}
	
}