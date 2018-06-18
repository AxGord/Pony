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

	public var objects(default, null):Array<T> = [];
	public var size(get, never):Point<Float>;
	@:auto private var onReady:Signal0;
	private var ready:Bool = false;
	public var tasks:Tasks;
	
	private var _w:Float;
	private var _h:Float;
	private var _needUpdate:Bool = false;
	
	public function new() {
		tasks = new Tasks(tasksReady);
	}
	
	public function add(o:T):Void {
		objects.push(o);
		addWait(o);
	}

	public function remove(o:T):Void {
		objects.remove(o);
	}
	
	public function addToBegin(o:T):Void {
		objects.unshift(o);
		addWait(o);
	}
	
	private function addWait(o:T) {
		if (Std.is(o, IWH)) {
			tasks.add();
			cast(o, IWH).wait(tasks.end);
		} else load(o);
		needUpdate();
	}
	
	private function endUpdate():Void {
		if (objects == null) return;
		tasks.end();
		_needUpdate = false;
	}
	
	public function needUpdate():Void {
		if (objects == null) return;
		if (!_needUpdate) {
			_needUpdate = true;
			tasks.add();
			DeltaTime.fixedUpdate < endUpdate;
		}
	}
	
	public dynamic function load(o:T):Void {}
	public dynamic function destroyChild(o:T):Void {}
	public dynamic function getSize(o:T):Point<Float> return throw 'Unknown type';
	public dynamic function getSizeMod(o:T, p:Point<Float>):Point<Float> return p;
	public dynamic function setXpos(o:T, v:Float):Void {}
	public dynamic function setYpos(o:T, v:Float):Void {}
	private function get_size():Point<Float> return new Point(_w, _h);
	
	private function tasksReady():Void {
		if (objects == null) return;
		if (ready) {
			update();
		} else {
			ready = true;
			update();
			eReady.dispatch();
			eReady.destroy();
		}
	}
	
	public function wait(cb:Void->Void):Void {
		if (objects == null) return;
		if (ready) cb();
		else if (tasks.ready) {
			tasksReady();
			cb();
		} else onReady < cb;
	}
	
	public function update():Void {}
	
	@:extern inline private function getObjSize(o:T):Point<Float> {
		return getSizeMod(o, Std.is(o, IWH) ? cast(o, IWH).size : getSize(o));
	}
	
	public function destroy():Void {
		for (o in objects) {
			if (Std.is(o, IWH))
				cast(o, IWH).destroyIWH();
			else
				destroyChild(o);
		}
		objects = null;
		
		DeltaTime.fixedUpdate >> endUpdate;
		destroySignals();
		tasks = null;
	}
	
	public function destroyIWH():Void destroy();
	
}