package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.core.textures.RenderTexture;
import pixi.core.display.DisplayObject.DestroyOptions;
import pony.geom.IWH;
import pony.geom.Point;
import pony.color.UColor;
import pony.time.DeltaTime;
import pony.time.Tween;
import pony.ui.gui.SmoothBarCore;

/**
 * SpinLoader
 * @author AxGord <axgord@gmail.com>
 */
class SpinLoader extends Sprite implements IWH {

	public var core(default, null):SmoothBarCore;
	public var size(get, never):Point<Float>;

	private var _size:Point<Float>;
	private var app:App;
	private var renderTexture:RenderTexture;
	private var graphics:Graphics = new Graphics();
	private var trackRadius:Int;
	private var circleRadius:Int;
	private var steps:Int;
	private var prevStep:Int = 0;
	private var pulse:Tween = new Tween(1...0, TweenType.Square, 1000, false, true, true, true);
	private var spin:Float;

	public function new(trackRadius:Int, circleRadius:Int, color:UColor, spin:Float = 0, ?app:App) {
		steps = Std.int(trackRadius / Math.sqrt(circleRadius) * 3);
		core = new SmoothBarCore(steps);
		var w:Int = (trackRadius + circleRadius) * 2;
		_size = new Point<Float>(w, w);
		this.app = app == null ? App.main : app;
		this.trackRadius = trackRadius;
		this.circleRadius = circleRadius;
		this.spin = spin;
		renderTexture = RenderTexture.create(w, w);
		super(renderTexture);
		core.smoothChangeX = changeHandler;

		graphics.beginFill(color);
		graphics.drawCircle(0, 0, circleRadius);

		core.smooth = true;
		core.endInit();

		pulse.onUpdate << pulseHandler;

		if (spin != 0) {
			anchor.set(0.5);
			DeltaTime.fixedUpdate << spinHandler;
			core.changeSmoothPercent - 1 << stopSpinHandler;
		}
	}

	private function stopSpinHandler():Void DeltaTime.fixedUpdate >> spinHandler;
	private function spinHandler(v:Float):Void rotation += v * spin;
	private function get_size():Point<Float> return spin != 0 ? new Point<Float>(0, 0) : _size;
	public function wait(cb:Void -> Void):Void cb();
	public function destroyIWH():Void destroy();
	private function pulseHandler(v:Float):Void alpha = v;
	public inline function startPulse():Void pulse.play();
	public inline function stopPulse():Void pulse.stopOnBegin();

	private function changeHandler(v:Float):Void {
		var current:Int = Std.int(v);
		for (i in prevStep...current) draw(i / steps);
		if (current != v) draw(v / steps);
		prevStep = current;
	}

	private inline function draw(n:Float):Void {
		var angle:Float = n * Math.PI * 2;
		graphics.x = trackRadius * Math.cos(angle) + trackRadius + circleRadius;
		graphics.y = trackRadius * Math.sin(angle) + trackRadius + circleRadius;
		app.app.renderer.render(graphics, renderTexture, false);
	}

	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		DeltaTime.fixedUpdate >> spinHandler;
		renderTexture.destroy(true);
		renderTexture = null;
		pulse.destroy();
		pulse = null;
		core.destroy();
		core = null;
		graphics.destroy();
		graphics = null;
		super.destroy(options);
	}

}