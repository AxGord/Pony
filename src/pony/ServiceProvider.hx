package pony;

import haxe.Exception;
import pony.Or;
import pony.magic.WR;

private typedef WCB = Or<() -> Void, WR -> Void>;

private typedef Export = { typeName: String, name: String };

/**
 * ServiceProvider — type-based DI container.
 *
 * Services are registered under all type names they are assignable to (concrete class,
 * super classes, implemented interfaces). Lookup walks the scope chain looking for the
 * requested type. At each level, if a single instance of the requested type exists it
 * is returned regardless of name; if multiple exist, the field name disambiguates them.
 *
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) final class ServiceProvider {

	private final parent: Null<ServiceProvider>;
	// typeName -> (name -> instance). One instance may appear under multiple typeNames.
	private final byType: Map<String, Map<String, Dynamic>> = [];
	// typeName -> (name -> pending callbacks). Acts both as the "loading" marker and the waiter list.
	private final waits: Map<String, Map<String, Array<WCB>>> = [];
	private final exports: Array<Export> = [];

	public function new(?parent: ServiceProvider) {
		this.parent = parent;
	}

	public function load(typeNames: Array<String>, name: String, export: Bool = false): Void {
		if (export) {
			for (tn in typeNames) if (!isExported(tn, name)) exports.push({ typeName: tn, name: name });
			if (parent != null)
				parent.load(typeNames, name, true);
			else
				loadLocal(typeNames, name);
		} else {
			loadLocal(typeNames, name);
		}
	}

	private function loadLocal(typeNames: Array<String>, name: String): Void {
		for (tn in typeNames) {
			var byName: Null<Map<String, Array<WCB>>> = waits[tn];
			if (byName == null) {
				byName = [];
				waits[tn] = byName;
			}
			if (byName.exists(name)) throw new Exception('Second load: type=$tn name=$name');
			byName[name] = [];
		}
	}

	public function register(typeNames: Array<String>, name: String, service: Dynamic, export: Bool = false): Void {
		if (export) {
			for (tn in typeNames) if (!isExported(tn, name)) exports.push({ typeName: tn, name: name });
			if (parent != null)
				parent.register(typeNames, name, service, true);
			else
				registerLocal(typeNames, name, service);
		} else {
			registerLocal(typeNames, name, service);
		}
	}

	private function registerLocal(typeNames: Array<String>, name: String, service: Dynamic): Void {
		for (tn in typeNames) {
			var byName: Null<Map<String, Dynamic>> = byType[tn];
			if (byName == null) {
				byName = [];
				byType[tn] = byName;
			}
			byName[name] = service;
			// Fire pending waiters for this (type, name).
			final waitersByName: Null<Map<String, Array<WCB>>> = waits[tn];
			if (waitersByName != null) {
				final w: Null<Array<WCB>> = waitersByName[name];
				if (w != null) {
					for (wcb in w) callw(wcb, service);
					waitersByName.remove(name);
					if (!waitersByName.iterator().hasNext()) waits.remove(tn);
				}
			}
		}
	}

	private inline function callw(w: WCB, service: Dynamic): Void {
		switch w {
			case A(cb):
				cb();
			case B(cb):
				cb(service);
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

	public inline function exists(typeName: String, name: String): Bool {
		return existsInCurrent(typeName, name) || existsInParents(typeName, name);
	}

	public inline function existsInParents(typeName: String, name: String): Bool {
		return !isExported(typeName, name) && parent != null && parent.exists(typeName, name);
	}

	public function existsInCurrent(typeName: String, name: String): Bool {
		final byName: Null<Map<String, Dynamic>> = byType[typeName];
		if (byName != null && byName.exists(name)) return true;
		final waitersByName: Null<Map<String, Array<WCB>>> = waits[typeName];
		return waitersByName != null && waitersByName.exists(name);
	}

	public function isExported(typeName: String, name: String): Bool {
		for (e in exports) if (e.typeName == typeName && e.name == name) return true;
		return false;
	}

	@:nullSafety(Off) public function get<T>(typeName: String, name: String): T {
		final byName: Null<Map<String, Dynamic>> = byType[typeName];
		if (byName != null) {
			var count: Int = 0;
			var only: Null<Dynamic> = null;
			var firstName: Null<String> = null;
			for (k => v in byName) {
				count++;
				if (count == 1) {
					only = v;
					firstName = k;
				}
				if (count > 1) break;
			}
			if (count == 1) return only;
			if (count > 1) {
				final exact: Null<Dynamic> = byName[name];
				if (exact != null) return exact;
				throw new Exception('Ambiguous service: type=$typeName has multiple entries, name="$name" matches none');
			}
		}
		if (parent == null) throw new Exception('Service not exists: type=$typeName name=$name');
		return parent.get(typeName, name);
	}

	public inline function waitReady(typeName: String, name: String, ?cb: () -> Void, ?wcb: WR -> Void): Void {
		waitReadyWcb(typeName, name, toWcb(cb, wcb));
	}

	private function waitReadyWcb(typeName: String, name: String, wcb: WCB): Void {
		final waitersByName: Null<Map<String, Array<WCB>>> = waits[typeName];
		if (waitersByName != null) {
			final w: Null<Array<WCB>> = waitersByName[name];
			if (w != null) {
				w.push(wcb);
				return;
			}
		}
		final service: Null<Dynamic> = try get(typeName, name) catch (_: Dynamic) null;
		if (service != null) {
			callw(wcb, service);
		} else if (parent != null) {
			parent.waitReadyWcb(typeName, name, wcb);
		} else {
			throw new Exception('Service not exists: type=$typeName name=$name');
		}
	}

	public inline function sub(): ServiceProvider return new ServiceProvider(this);

	public function destroy(): Void {
		exports.resize(0);
		byType.clear();
		waits.clear();
	}

}
