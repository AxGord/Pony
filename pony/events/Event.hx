/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
* 
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
* 
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/

package pony.events;

/**
 * @author AxGord
 */

class Event 
{
	/**
	 * Event arguments
	 */
	public var args(getArgs, setError):Array<Dynamic>;
	private var _args:Array<Dynamic>;
	private function getArgs():Array<Dynamic> { return _args; }
	
	/**
	 * If set true, next listeners not execute.
	 */
	public var stop:Bool;
	
	/**
	 * If set true, next listeners not excute. And not execute runAfter functions.
	 */
	public var abort:Bool;
	
	/**
	 * Event target. Type Signal or EventDispatcher.
	 */
	public var target:Dynamic;
	
	public var signal:Signal;
	
	/**
	 * You can use this for change priority or another operation with Listener.
	 */
	public var listener:Listener;
	
	/**
	 * Listeners results.
	 */
	public var results:Hash<Dynamic>;
	
	/**
	 * Create new Event.
	 * @param	?args event arguments.
	 */
	public function new(?args:Array<Dynamic>) 
	{
		results = new Hash<Dynamic>();
		abort = stop = false;
		if (args == null)
			_args = [];
		else
			_args = args;
	}
	
	/**
	 * Add function for run after execute all listener.
	 * @param	f Function
	 */
	public dynamic function runAfter(f:Void->Void):Void { }

	/**
	 * Remove this listener from this signal.
	 */
	public function removeListener():Void {
		signal.removeListener(listener);
	}
	
	/**
	 * [args[n]] - Stupid Dynamic type :(.
	 */
	public function arg(n:Int):Dynamic {
		return args[n];
	}
	
	private function setError(v:Dynamic):Dynamic throw 'You can\'t set this field'
	
}