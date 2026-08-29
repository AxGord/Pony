package pony.heaps;

import h2d.Drawable;
import h2d.Graphics;
import h2d.Object;
import h2d.Scene;
import haxe.Timer;
import hxd.App;
import hxd.SceneEvents.InteractiveScene;
import hxd.Window;
import pony.color.UColor;
import pony.events.Signal1;
import pony.geom.Point;
import pony.geom.Rect;
import pony.magic.HasLink;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.ui.keyboard.Keyboard;
#if js
import js.Browser;
import js.html.Element;
import pony.js.SmartCanvas;
#end

/**
 * HeapsApp
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class HeapsApp extends App implements HasSignal implements HasLink {

	public static var instance: Null<HeapsApp>;
	public static var s2dReady(get, never): Bool;
	public static var fps(get, set): Float;

	public static inline final FPS_COMPENSATION: Float = 1.05;

	private static var fpsInterval: Float = 1 / (hxd.Timer.wantedFPS * FPS_COMPENSATION);

	@:auto public var onInit: Signal1<HeapsApp>;

	public var noScale(link, link): Bool = canvas.noScale;

	public var sizeUpdate(default, set): Bool = false;

	public var canvas: SmartCanvas;

	#if debugTimes
	public var heapsTime: Float = 0;
	public var systemTime: Float = 0;
	public var updateTime: Float = 0;

	#if js
	private var lastHashlinkTime: Float = 0;
	#end
	#end

	private static inline final renderPause: Bool = false;

	private var alignCenter: Bool = false;
	private var border: Null<Graphics>;
	private var lastTick: Float = Timer.stamp();

	public function new(?size: Point<Int>, ?color: UColor, #if js ?parentDom: Element, #end sizeUpdate: Bool = true) {
		#if js
		Keyboard.preventDefault = false;
		canvas = new SmartCanvas(size, parentDom);
		canvas.canvas.setAttribute('propagateKeyEvents', 'false');
		// `true` is globalEvents: every heaps listener goes on the window. In an iframe, which is how
		// itch.io serves a game, that loses both the keys and the finger, hence the two lines below.
		@:privateAccess Window.inst = new Window(canvas.canvas, true);
		// Empty on purpose: Safari sends touches only to an element with a listener of its own, and
		// fakes a mousedown/mouseup pair at the lift otherwise, so a held finger reads as a tap.
		canvas.canvas.addEventListener('touchstart', _ -> {});
		// The page around keeps the focus, and heaps cancels the mousedown that would hand it over.
		Browser.window.addEventListener('pointerdown', _ -> if (!Browser.document.hasFocus()) Browser.window.focus());
		AudioSessionKeeper.init();
		initMediaSession();
		#else
		canvas = new SmartCanvas(size);
		onInit < sdlInitHandler;
		#end
		super();
		if (color != null) engine.backgroundColor = color;
		#if mobile
		@:privateAccess engine.window.window.displayMode = DisplayMode.Fullscreen;
		#end
		this.sizeUpdate = sizeUpdate;
		if (instance == null) instance = this;
	}

	private static inline function get_fps(): Float return hxd.Timer.wantedFPS;

	public static inline function set_fps(value: Float): Float {
		hxd.Timer.wantedFPS = value;
		fpsInterval = 1 / (value * FPS_COMPENSATION);
		return value;
	}

	override private function update(dt: Float): Void {
		#if debugTimes
		final now: Float = Timer.stamp();
		#end
		DeltaTime.fixedValue = dt;
		DeltaTime.fixedDispatch();
		#if debugTimes
		updateTime = Timer.stamp() - now;
		#end
	}

	#if hl
	override private function mainLoop(): Void {
		#if debugTimes
		systemTime = Timer.stamp() - lastTick - heapsTime - updateTime;
		#end
		final sleepTime: Float = fpsInterval - (Timer.stamp() - lastTick);
		if (sleepTime > 0) Sys.sleep(sleepTime);
		lastTick = Timer.stamp();
		super.mainLoop();
		#if debugTimes
		heapsTime = Timer.stamp() - lastTick - updateTime;
		#end
	}
	#elseif js
	override private function mainLoop(): Void {
		final now: Float = Timer.stamp();
		final elapsed: Float = now - lastTick;
		if (elapsed >= fpsInterval) {
			#if debugTimes
			systemTime = now - lastHashlinkTime;
			#end
			lastTick = now - elapsed % fpsInterval;
			super.mainLoop();
			#if debugTimes
			lastHashlinkTime = Timer.stamp();
			heapsTime = lastHashlinkTime - now - updateTime;
			#end
		}
	}
	#end

	override private function init(): Void eInit.dispatch(this);

	public inline function setScalableScene(?scene: Scene, alignCenter: Bool = true, disposePrevious: Bool = true): Void {
		noScale = false;
		this.alignCenter = alignCenter;
		if (scene == null) scene = new Scene();
		setScene(scene, disposePrevious);
	}

	public inline function setFixedScene(?scene: Scene, alignCenter: Bool = false, disposePrevious: Bool = true): Void {
		noScale = true;
		this.alignCenter = alignCenter;
		if (scene == null) scene = new Scene();
		setScene(scene, disposePrevious);
	}

	override public function setScene(scene: InteractiveScene, disposePrevious: Bool = true): Void {
		super.setScene(scene, disposePrevious);
		if (sizeUpdate) canvas.updateSize();
		#if !js
		windowResizeHandler();
		#end
	}

	#if !js
	private function sdlInitHandler(): Void {
		@:privateAccess engine.window.addResizeEvent(windowResizeHandler);
	}

	private function windowResizeHandler(): Void {
		@:privateAccess canvas.setSize(engine.window.window.width, engine.window.window.height);
	}
	#end

	private function set_sizeUpdate(b: Bool): Bool {
		if (b != sizeUpdate) {
			sizeUpdate = b;
			if (!renderPause) {
				if (b)
					canvas.onStageResize << stageResizeHandler;
				else
					canvas.onStageResize >> stageResizeHandler;
			}
		}
		return b;
	}

	public function drawBorders(?color: UInt): Void {
		var border: Graphics = new Graphics();
		this.border = border;
		border.beginFill(@:nullSafety(Off) (color == null) ? engine.backgroundColor : color);
		final w: Int = canvas.stageInitSize.x * 2;
		final h: Int = canvas.stageInitSize.y * 2;
		border.drawRect(-w, -h, w, h * 3);
		border.drawRect(canvas.stageInitSize.x, -h, w, h * 3);
		border.drawRect(-w, -h, w * 3, h);
		border.drawRect(-w, canvas.stageInitSize.y, w * 3, h);
		s2d.add(border, 100);
	}

	public function stageResizeHandler(ratio: Float, rect: Rect<Float>): Void {
		if (s2d != null) {
			s2d.scaleMode = ScaleMode.Stretch(Std.int(rect.width), Std.int(rect.height));
			if (alignCenter) s2d.setPosition(rect.x, rect.y);
		}
	}

	public inline function localToGlobal(obj: Object, ?pos: Point<Float>): Point<Float>
		return pos != null ? pos + obj.localToGlobal() - canvas.rect.start : obj.localToGlobal() - canvas.rect.start;

	public inline function globalToLocal(x: Float, y: Float): Point<Float>
		return @:privateAccess new Point(s2d.interactiveCamera.screenXToCamera(x, y), s2d.interactiveCamera.screenYToCamera(x, y));

	private static inline function get_s2dReady(): Bool return instance != null && instance.s2d != null;


	#if js
	/**
	 * The playback session AudioSessionKeeper asks for also puts the page into Now Playing, where
	 * Safari otherwise shows the host name. Everything it needs the document already declares, so
	 * nothing is configured here: `<title>`, `<meta name="author">` and `<link rel="icon">`.
	 */
	private static function initMediaSession(): Void {
		final author: Null<Element> = Browser.document.querySelector('meta[name="author"]');
		final icon: Null<Element> = Browser.document.querySelector('link[rel~="icon"]');
		final artist: String = author != null ? author.getAttribute('content') ?? '' : '';
		final iconHref: String = icon != null ? icon.getAttribute('href') ?? '' : '';
		js.Syntax.code(
			'if (navigator.mediaSession && window.MediaMetadata) navigator.mediaSession.metadata = new MediaMetadata({0})',
			{ title: Browser.document.title, artist: artist, artwork: iconHref == '' ? [] : [{ src: iconHref }] }
		);
	}
	#end

}
