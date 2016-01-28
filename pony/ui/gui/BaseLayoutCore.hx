/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.gui;

import pony.events.Signal0;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.Tasks;
import pony.time.DeltaTime;

using pony.Tools;

/**
 * BaseLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
class BaseLayoutCore<T> implements Declarator implements HasSignal implements IWH {

	private var objects:Array<T> = [];
	public var size(get, never):Point<Float>;
	@:auto private var onReady:Signal0;
	private var ready:Bool = false;
	public var tasks:Tasks;
	
	private var _w:Float;
	private var _h:Float;
	
	public function new() {
		tasks = new Tasks(tasksReady);
	}
	
	public function add(o:T):Void {
		objects.push(o);
		if (Std.is(o, IWH)) {
			tasks.add();
			cast(o, IWH).waitReady(DeltaTime.notInstant(tasks.end));
		} else load(o);
	}
	
	public dynamic function load(o:T):Void {}
	public dynamic function getSize(o:T):Point<Float> return throw 'Unknown type';
	public dynamic function setXpos(o:T, v:Float):Void {}
	public dynamic function setYpos(o:T, v:Float):Void {}
	private function get_size():Point<Float> return new Point(_w, _h);
	
	private function tasksReady():Void {
		if (ready) {
			update();
		} else {
			ready = true;
			update();
			eReady.dispatch();
		}
	}
	
	public function waitReady(cb:Void->Void):Void {
		if (ready) cb();
		else if (tasks.ready) {
			tasksReady();
			cb();
		} else onReady < cb;
	}
	
	public function update():Void {}
	
	@:extern inline private function getObjSize(o:T):Point<Float> {
		return Std.is(o, IWH) ? cast(o, IWH).size : getSize(o);
	}
	
}