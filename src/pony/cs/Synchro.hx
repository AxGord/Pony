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
	public static function lock(obj:Dynamic, func:Void -> Void):Bool
	{
		if ((Type.typeof(obj) == TInt) || 
		(Type.typeof(obj) == TBool) ||
		(Type.typeof(obj) == TFloat)) throw new cs.system.threading.SynchronizationLockException(); //Небольшой костыль для более-менее корректного поведения. 
		
		var isSynchred:Bool = true;
		Monitor.Enter(obj);
		try
		{
			func();
		}
		catch(_:Dynamic)
		{
			Monitor.Exit(obj);
			isSynchred = false;
			return false;
		}
		if (isSynchred) 
		{
			Monitor.Exit(obj);
			return true;
		}
		else return false;
	}
	
	/**
	 * A method implementing C# mutex. Returns true if executing is finished correct, false instead.
	 * It is guaranteed that mutex will not be abandoned, unless whole application crashes. 
	 **/
	public static function mutex(func:Void -> Void):Bool
	{
		var isSynchred:Bool = true;
		var m:Mutex = new Mutex();
		try
		{
			m.WaitOne();
			func();
		}
		catch (_:Dynamic)
		{
			m.ReleaseMutex();
			isSynchred = false;
			return false;
		}
		if (isSynchred) 
		{
			m.ReleaseMutex();
			return true;
		}
		else return false;
	}
}
#end