package pony.ui.gui;

import pony.events.Signal0;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.Tasks;
import pony.time.DeltaTime;

using pony.Tools;

/**
 * BaseLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class BaseLayoutCore<T> implements Declarator implements HasSignal implements IWH {

	public var objects(default, null): Array<T> = [];
	public var size(get, never): Point<Float>;
	@:auto private var onReady: Signal0;
	private var ready: Bool = false;
	public var tasks: Tasks;

	private var _w: Float = 0;
	private var _h: Float = 0;
	private var _needUpdate: Bool = false;

	public function new() {
		tasks = new Tasks(tasksReady);
	}

	public function add(o: T): Void {
		objects.push(o);
		addWait(o);
	}

	public function addAt(o: T, index: Int): Void {
		objects.insert(index, o);
		addWait(o);
	}

	public function remove(o: T): Void {
		objects.remove(o);
		needUpdate();
	}

	public function addToBegin(o: T): Void {
		objects.unshift(o);
		addWait(o);
	}

	private function addWait(o: T): Void {
		if (Std.is(o, IWH)) {
			tasks.add();
			cast(o, IWH).wait(tasks.end);
		} else load(o);
		needUpdate();
	}

	private function endUpdate(): Void {
		if (objects == null) return;
		tasks.end();
		_needUpdate = false;
	}

	public function needUpdate(): Void {
		if (objects == null) return;
		if (!_needUpdate) {
			_needUpdate = true;
			tasks.add();
			DeltaTime.fixedUpdate < endUpdate;
		}
	}

	public dynamic function load(o: T): Void {}
	public dynamic function destroyChild(o: T): Void {}
	public dynamic function getSize(o: T): Point<Float> return throw 'Unknown type';
	public dynamic function getSizeMod(o: T, p: Point<Float>): Point<Float> return p;
	public dynamic function setXpos(o: T, v: Float): Void {}
	public dynamic function setYpos(o: T, v: Float): Void {}
	private function get_size(): Point<Float> return new Point(_w, _h);

	private function tasksReady(): Void {
		if (objects == null) return;
		if (ready) {
			update();
		} else {
			ready = true;
			update();
			eReady.dispatch();
			eReady.destroy();
		}
	}

	public function wait(cb: Void -> Void): Void {
		if (objects == null) return;
		if (ready) cb();
		else if (tasks.ready) {
			tasksReady();
			cb();
		} else onReady < cb;
	}

	public function update(): Void {}

	@:extern private inline function getObjSize(o: T): Point<Float> {
		return getSizeMod(o, Std.is(o, IWH) ? cast(o, IWH).size : getSize(o));
	}

	public function destroy(): Void {
		for (o in objects) {
			if (Std.is(o, IWH))
				cast(o, IWH).destroyIWH();
			else
				destroyChild(o);
		}
		@:nullSafety(Off) objects = null;

		DeltaTime.fixedUpdate >> endUpdate;
		destroySignals();
		@:nullSafety(Off) tasks = null;
	}

	public function destroyIWH(): Void destroy();

}