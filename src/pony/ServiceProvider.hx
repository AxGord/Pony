package pony;

import haxe.Exception;

import pony.Or;
import pony.magic.WR;

private typedef WCB = Or<() -> Void, WR -> Void>;

/**
 * ServiceProvider
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) final class ServiceProvider {

	private final parent: Null<ServiceProvider>;
	private final services: Map<String, Dynamic>;
	private final waits: Map<String, Array<WCB>> = [];
	private final exports: Array<String> = [];

	public function new(?parent: ServiceProvider, ?services: Map<String, Dynamic>) {
		this.parent = parent;
		this.services = services != null ? services : [];
	}

	public function load<T>(name: String, export: Bool = false): Void {
		if (export) {
			exports.push(name);
			if (parent != null)
				parent.load(name, true);
			else
				load(name);
		} else {
			if (waits.exists(name)) throw new Exception('Second load $name');
			waits[name] = [];
		}
	}

	public function set<T>(name: String, service: T, export: Bool = false): Void {
		if (export) {
			if (!exports.contains(name)) exports.push(name);
			if (parent != null)
				parent.set(name, service, true);
			else
				set(name, service);
		} else {
			services.set(name, service);
			final w: Null<Array<WCB>> = waits[name];
			if (w != null) {
				for (wcb in w) callw(wcb, service);
				waits.remove(name);
			}
		}
	}

	private inline function callw(w: WCB, service: Dynamic): Void {
		switch w {
			case A(cb): cb();
			case B(cb): cb(service);
		}
	}

	private inline function toWcb(?cb: () -> Void, ?wcb: WR -> Void): WCB {
		return if (cb != null) {
			if (wcb != null)
				throw new Exception('Only one callback allowed');
			else
				A(cb);
		} else if (wcb != null) {
			B(wcb);
		} else {
			throw new Exception('Callback not set');
		};
	}

	public inline function exists(name: String): Bool {
		return existsInCurrent(name) || existsInParents(name);
	}

	public inline function existsInParents(name: String): Bool {
		return !isExported(name) && parent != null && parent.exists(name);
	}

	public inline function existsInCurrent(name: String): Bool {
		return waits.exists(name) || services.exists(name);
	}

	public inline function isExported(name: String): Bool {
		return exports.contains(name);
	}

	@:nullSafety(Off) public function get<T>(name: String): T {
		var service: Null<T> = services.get(name);
		if (service == null) {
			if (parent == null) throw new Exception('Service not exists: $name');
			service = parent.get(name);
		}
		return service;
	}

	public inline function waitReady(name: String, ?cb: () -> Void, ?wcb: WR -> Void): Void {
		waitReadyWcb(name, toWcb(cb, wcb));
	}

	private function waitReadyWcb(name: String, wcb: WCB): Void {
		final w: Null<Array<WCB>> = waits[name];
		if (w != null) {
			w.push(wcb);
		} else {
			var service: Null<Dynamic> = try get(name) catch (_: Dynamic) null;
			if (service != null) {
				callw(wcb, service);
			} else {
				if (parent != null)
					parent.waitReadyWcb(name, wcb);
				else
					throw new Exception('Service not exists');
			}
		}
	}

	public inline function sub(): ServiceProvider return new ServiceProvider(this);

	public function destroy(): Void {
		exports.resize(0);
		services.clear();
		waits.clear();
	}

}