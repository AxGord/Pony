#if cs
package pony.cs;

import cs.system.threading.Monitor;
import cs.system.threading.Mutex;

/**
 * Synchro
 * @author DIS
 */
class Synchro {

	/**
	 * A method implementing C# lock via monitor. Returns true if executing is finished correct, false instead.
	**/
	public static function lock(obj: Dynamic, func: Void -> Void): Bool {
		if ((Type.typeof(obj) == TInt) || (Type.typeof(obj) == TBool) || (Type.typeof(obj) == TFloat))
			throw new cs.system.threading.SynchronizationLockException(); // Небольшой костыль для более-менее корректного поведения.

		var isSynchred: Bool = true;
		Monitor.Enter(obj);
		try {
			func();
		} catch (_: Dynamic) {
			Monitor.Exit(obj);
			return false;
		}
		if (!isSynchred) return false;
		Monitor.Exit(obj);
		return true;
	}

	/**
	 * A method implementing C# mutex. Returns true if executing is finished correct, false instead.
	 * It is guaranteed that mutex will not be abandoned, unless whole application crashes.
	**/
	public static function mutex(func: Void -> Void): Bool {
		var isSynchred: Bool = true;
		final m: Mutex = new Mutex();
		try {
			m.WaitOne();
			func();
		} catch (_: Dynamic) {
			m.ReleaseMutex();
			return false;
		}
		if (!isSynchred) return false;
		m.ReleaseMutex();
		return true;
	}

}
#end
