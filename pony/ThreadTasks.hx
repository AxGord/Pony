/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;

import haxe.MainLoop;

/**
 * Thread Tasks
 * @author AxGord <axgord@gmail.com>
 */
abstract ThreadTasks(UInt) {

	@:extern public inline function new() this = 0;

	@:extern public inline function add(f:UInt -> Void):Void {
		this++;
		MainLoop.addThread(function():Void {
			f(this);
			this--;
		});
	}

	@:extern public inline function wait():Void while (this > 0) Sys.sleep(0.1);

	@:extern public static inline function multyTask(count:Int, f:UInt -> Void):Void {
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

	@:extern public inline function ended():Bool return error || states.length == endedCount;

	@:extern public inline function wait():Void while (!ended()) Sys.sleep(0.01);

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