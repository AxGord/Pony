package pony.tests;

import haxe.CallStack;
import haxe.Log;
import haxe.PosInfos;
import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import pony.Pair;

using pony.Tools;

/**
 * AsyncTests
 * @author DIS
 * @author AxGord
 */
class AsyncTests extends TestCase {

	public static var isRead: Map<Int, Bool>;
	private static final assertList: List<{ a: Dynamic, b: Dynamic, pos: PosInfos }> = new List();
	private static var testCount: Int = 0;
	private static var complite: Bool = false;
	private static final dec: String = '----------';
	private static final waitList: List<{ it: IntIterator, cb: Void -> Void }> = new List<{ it: IntIterator, cb: Void -> Void }>();
	private static var counter: Int = 0;
	private static var lock: Bool;

	public static function init(count: Int): Void {
		if (testCount != 0) throw 'Second init';
		Log.trace('$dec Begin tests ($count) $dec');
		testCount = count;
		isRead = [for (i in 0...count) i => false];
	}

	public static inline function equals<T>(a: T, b: T, ?infos: PosInfos): Void {
		assertList.push({ a: a, b: b, pos: infos });
	}

	public static function setFlag(n: Int, ?infos: PosInfos) {
		#if cs
		pony.cs.Synchro.lock(isRead, function() {
		#end
		// trace(counter++);
		if (n >= testCount || n < 0) throw 'Wrong test number';
		if (isRead[n]) throw 'Double complite';
		Log.trace('$dec Test #$n finished $dec', infos);
		isRead[n] = true;
		if (lock) {
			trace('Locked call');
			return;
		}
		lock = true;
		checkWaitList();
		for (e in isRead) if (!e) {
			lock = false;
			return;
		}
		final test: TestRunner = new TestRunner();
		test.add(new AsyncTests());
		test.run();
		#if cs
		});
		#end
	}

	public function testRun(): Void {
		for (e in assertList) assertEquals(e.a, e.b, e.pos);
		complite = true;
	}

	public static function finish(?infos: PosInfos): Void {
		if (!complite) throw 'Tests not complited: ' + {
			final a = [for (k in isRead.keys()) if (!isRead[k]) k];
			a;
		};
		Log.trace('$dec All tests finished $dec', infos);
	}

	public static function wait(it: IntIterator, cb: Void -> Void): Void {
		if (checkWait(it)) {
			cb();
		} else {
			waitList.push({ it: it, cb: cb });
		}
	}

	private static function checkWait(it: IntIterator): Bool {
		for (i in it.copy()) if (!isRead[i]) return false;
		return true;
	}

	private static function checkWaitList(): Void {
		for (e in waitList) if (checkWait(e.it)) {
			e.cb();
			waitList.remove(e);
		}
	}

}
