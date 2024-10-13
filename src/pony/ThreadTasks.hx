package pony;

import haxe.MainLoop;

/**
 * Thread Tasks
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
abstract ThreadTasks(UInt) {

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new() this = 0;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function add(f:UInt -> Void):Void {
		this++;
		MainLoop.addThread(function():Void {
			f(this);
			this--;
		});
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function wait():Void while (this > 0) Sys.sleep(0.1);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function multyTask(count:Int, f:UInt -> Void):Void {
		if (count == 1) {
			f(1);
		} else if (count > 1) {
			var t = new ThreadTasks();
			while (count-- > 0) t.add(f);
			t.wait();
		}
	}

}

class ThreadTasksWhile {

	private var states:Array<Bool> = [];
	private var waits:Array<Bool> = [];
	private var endedCount:Int = 0;
	public var error:Bool = false;

	public function new() {}

	public function add(f:(Void -> Void) -> (Void -> Void) -> Bool):Void {
		var id:Int = states.length;
		states.push(false);
		waits.push(false);
		function lock() states[id] = true;
		function unlock() states[id] = false;
		function wait() waits[id] = true;
		function endwait() waits[id] = false;
		function waitandsleep() {
			wait();
			unlock();
			while (states.indexOf(true) != -1 || waits.indexOf(true) < id) Sys.sleep(0.01);
			lock();
			endwait();
		}
		MainLoop.addThread(function():Void {
			waitandsleep();

			try {
				while (f(lock, unlock)) {
					waitandsleep();
				}
			} catch (err:Any) {
				trace(err);
				error = true;
			}

			endedCount++;
			unlock();
		});
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function ended():Bool return error || states.length == endedCount;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function wait():Void while (!ended()) Sys.sleep(0.01);

	public static function multyTask(count:Int, f:(Void -> Void) -> (Void -> Void) -> Bool):Void {
		if (count == 1) {
			while (f(Tools.nullFunction0, Tools.nullFunction0)) {}
		} else if (count > 1) {
			var t = new ThreadTasksWhile();
			while (count-- > 0) t.add(f);
			t.wait();
			if (t.error) Sys.exit(1);
		}
	}

}