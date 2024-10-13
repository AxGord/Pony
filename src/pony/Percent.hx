package pony;

@SuppressWarnings('checkstyle:MagicNumber')
class Percent implements pony.magic.HasSignal {

	@:bindable public var percent:Float = 0;
	@:bindable public var full:Bool = false;
	@:bindable public var run:Bool = false;
	public var current(default, set):Float = 0;
	public var total(default, set):Float = -1;
	public var allow(default, set):Float = 1;

	public function new(allow:Float = 1, total:Float = -1) {
		this.allow = allow;
		this.total = total;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_current(v:Float):Float {
		if (current != v) {
			current = v;
			update();
		}
		return v;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_total(v:Float):Float {
		if (total != v) {
			total = v;
			update();
		}
		return v;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_allow(v:Float):Float {
		if (allow != v) {
			allow = v;
			update();
		}
		return v;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function update():Void {
		if (total == -1) {
			percent = 0;
			full = false;
			run = false;
		} else {
			percent = current / total;
			full = percent >= 1;
			run = full || current >= allow;
		}
	}

}