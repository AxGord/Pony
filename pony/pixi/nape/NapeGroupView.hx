package pony.pixi.nape;

import haxe.io.Bytes;
import pixi.core.sprites.Sprite;
import pony.geom.Point;
import pony.geom.Rect;
import pony.physics.nape.BodyBase;
import pony.physics.nape.DebugLineStyle;
import pony.physics.nape.NapeGroup;

/**
 * NapeGroupView
 * @author AxGord <axgord@gmail.com>
 */
class NapeGroupView extends Sprite {

	public var debugLines(default, set):DebugLineStyle;

	public var core(default, null):NapeGroup;
	private var objects:Array<BodyBaseView<BodyBase>> = [];

	public function new(core:NapeGroup) {
		super();
		this.core = core;
	}

	public function clear():Void {
		for (o in objects.copy()) o.destroy();
	}

	private function set_debugLines(v:DebugLineStyle):DebugLineStyle {
		debugLines = v;
		for (e in objects) e.debugLines = v;
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

	public function createStaticCircle(r:Float, isBullet:Bool = false):BodyCircleView {
		return reg(new BodyCircleView(core.createStaticCircle(r, isBullet)));
	}

	public function createShape(data:Bytes, resolution:Float, isBullet:Bool = false):BodyShapeView {
		return reg(new BodyShapeView(core.createShape(data, resolution, isBullet)));
	}

}