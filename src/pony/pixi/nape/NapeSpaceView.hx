package pony.pixi.nape;

import haxe.io.Bytes;
import pony.ui.touch.Touchable;
import pony.geom.Point;
import pony.geom.Rect;
import pony.physics.nape.BodyBase;
import pony.physics.nape.BodyShape;
import pony.physics.nape.DebugLineStyle;
import pony.physics.nape.NapeSpace;
import nape.space.Space;
import nape.phys.Body;
import nape.geom.Vec2;
import pixi.core.sprites.Sprite;
import pixi.core.graphics.Graphics;

/**
 * NapeSpaceView
 * @author AxGord <axgord@gmail.com>
 */
@:forward()
abstract NapeSpaceView(NapeSpaceViewBase) from NapeSpaceViewBase to NapeSpaceViewBase {
	
	public inline function new(w:Float, h:Float, ?gravity:Point<Float>):Void {
		this = new NapeSpaceViewBase(w, h, gravity);
	}

	@:op(a.b) public inline function resolve(s:String):NapeGroupView {
		return this.resolve(s);
	}
}

/**
 * NapeSpaceViewBase
 * @author AxGord <axgord@gmail.com>
 */
class NapeSpaceViewBase extends Sprite implements pony.magic.HasLink {

	public var play(link, never):Void -> Void = core.play;
	public var pause(link, never):Void -> Void = core.pause;
	public var debugLines(default, set):DebugLineStyle;

	public var core(default, null):NapeSpace;
	private var objects:Array<BodyBaseView<BodyBase>> = [];
	private var groups:Map<String, NapeGroupView> = new Map<String, NapeGroupView>();

	public var touchable(default, null):Touchable;

	public function new(w:Float, h:Float, ?gravity:Point<Float>) {
		super();
		core = new NapeSpace(w, h, gravity);
		var bgm = new Graphics();
		bgm.beginFill(0x212121);
		bgm.drawRect(0, 0, w, h);
		addChild(bgm);
		mask = bgm;
		interactive = false;
		interactiveChildren = false;
	}

	public function clear():Void {
		for (g in groups) g.clear();
		for (o in objects.copy()) o.destroy();
	}

	public function resolve(name:String):NapeGroupView {
		if (!groups.exists(name)) {
			var g = new NapeGroupView(core.resolve(name));
			g.debugLines = debugLines;
			groups[name] = g;
			addChild(g);
			return g;
		}
		return groups[name];
	}

	/**
	 *  Add backround and activate touchable
	 *  @param color - bg color
	 *  @return Graphics - for adding to stage
	 */
	public function bg(?color:Null<Int>):Graphics {
		var g = new Graphics();
		if (color == null)
			g.beginFill(0, 0);
		else
			g.beginFill(color);
		g.drawRect(0, 0, core.width, core.height);
		g.interactive = true;
		touchable = new Touchable(g);
		return g;
	}

	private function set_debugLines(v:DebugLineStyle):DebugLineStyle {
		debugLines = v;
		for (e in objects) e.debugLines = v;
		for (g in groups) g.debugLines = v;
		return v;
	}

	public function reg<S:BodyBase, T:BodyBaseView<S>>(obj:T):T {
		obj.debugLines = debugLines;
		addChild(obj);
		objects.push(cast obj);
		obj.core.onDestroy < function() {
			removeChild(obj);
			objects.remove(cast obj);
		}
		return obj;
	}

	public function createBox(size:Point<Float>, isBullet:Bool = false):BodyBoxView {
		return reg(new BodyBoxView(core.createBox(size, isBullet)));
	}

	public function createStaticBox(size:Point<Float>, isBullet:Bool = false):BodyBoxView {
		return reg(new BodyBoxView(core.createStaticBox(size, isBullet)));
	}

	public function createRect(size:Rect<Float>, isBullet:Bool = false):BodyRectView {
		return reg(new BodyRectView(core.createRect(size, isBullet)));
	}

	public function createStaticRect(size:Rect<Float>, isBullet:Bool = false):BodyRectView {
		return reg(new BodyRectView(core.createStaticRect(size, isBullet)));
	}

	public function createCircle(r:Float, isBullet:Bool = false):BodyCircleView {
		return reg(new BodyCircleView(core.createCircle(r, isBullet)));
	}

	public function createStaticCircle(r:Float, pos:Point<Float>, isBullet:Bool = false):BodyCircleView {
		return reg(new BodyCircleView(core.createStaticCircle(r, pos, isBullet)));
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShapeView {
		return reg(new BodyShapeView(core.createShape(data, resolution, isBullet)));
	}

	public function createBody(data:Body, ?anchor:Vec2, isBullet:Bool = false, isStatic:Bool = false):BodyBodyView {
		return reg(new BodyBodyView(core.createBody(data, anchor, isStatic, isBullet)));
	}

	public static function clearCache():Void {
		BodyShape.CACHE = new Map();
		BodyBaseView.clearCache();
	}

}