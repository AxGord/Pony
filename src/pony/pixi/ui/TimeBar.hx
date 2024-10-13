package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pony.geom.Border;
import pony.geom.Point;
import pony.pixi.ETextStyle;
import pony.time.DTimer;
import pony.time.Time;
import pony.time.TimeInterval;

/**
 * TimeBar
 * @author AxGord <axgord@gmail.com>
 */
class TimeBar extends LabelBar {

	public var timer:DTimer;
	private var ignoreBeginAnimation:Bool = false;

	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?border:Border<Int>,
		?style:ETextStyle,
		shadow:Bool = false,
		invert:Bool = false,
		useSpriteSheet:Bool = false,
		creep:Float = 0
	) {
		labelInitVisible = false;
		super(bg, fillBegin, fill, animation, animationSpeed, border, style, shadow, invert, useSpriteSheet, creep);
		timer = DTimer.createFixedTimer(null);
		onReady < timerInit;
	}

	private function timerInit(p:Point<Int>):Void {
		timer.progress << progressHandler;
		timer.update << updateHandler;
		timer.complete.add(startAnimation, -10);
		text = '00:00';
		if (!ignoreBeginAnimation) startAnimation();
	}

	private function progressHandler(p:Float):Void core.percent = p;
	private function updateHandler(t:Time):Void text = t.showMinSec();

	public function start(t:TimeInterval, ?cur:Time):Void {
		ignoreBeginAnimation = true;
		stopAnimation();
		timer.time = t;
		timer.reset();
		if (cur != null) timer.currentTime = cur;
		timer.start();
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function pause():Void timer.stop();

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function play():Void timer.start();

	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		timer.destroy();
		timer = null;
		super.destroy(options);
	}

}