/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
#if cs
package pony.cs;
import cs.system.threading.Monitor;
import cs.system.threading.Mutex;

/**
 * Synchro
 * @author DIS
 */
class Synchro 
{

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