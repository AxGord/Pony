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

	public function new(?parent: ServiceProvider, ?services: Map<String, Dynamic>) {
		this.parent = parent;
		this.services = services != null ? services : [];
	}

	public function load<T>(name: String): Void {
		if (waits.exists(name)) throw new Exception('Second load $name');
		waits[name] = [];
	}

	public function set<T>(name: String, service: T): Void {
		services.set(name, service);
		final w: Null<Array<WCB>> = waits[name];
		if (w != null) {
			for (wcb in w) callw(wcb, service);
			waits.remove(name);
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

	public function get<T>(name: String): T {
		var service: Null<T> = services.get(name);
		if (service == null) {
			if (parent == null) throw new Exception('Service not exists');
			service = parent.get(name);
			set(name, service);
		}
		@:nullSafety(Off) return service;
	}

	public function waitReady(name: String, ?cb: () -> Void, ?wcb: WR -> Void): Void {
		final wcb: WCB = toWcb(cb, wcb);
		final w: Null<Array<WCB>> = waits[name];
		if (w != null) {
			w.push(wcb);
		} else {
			var service: Null<Dynamic> = try get(name) catch (_: Dynamic) null;
			if (service != null) {
				callw(wcb, service);
			} else {
				final w: Null<Array<WCB>> = parent != null ? parent.waits[name] : null;
				if (w != null)
					w.push(wcb);
				else
					throw new Exception('Service not exists');
			}
		}
	}

	public inline function sub(): ServiceProvider return new ServiceProvider(this);

	public inline function destroy(): Void {
		services.clear();
		waits.clear();
	}

}