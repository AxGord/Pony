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
package pony.ui.gui;

import pony.events.Signal1;
import pony.geom.IWards;
import pony.magic.HasSignal;

/**
 * SwitchableList
 * @author AxGord
 */
class SwitchableList implements IWards implements HasSignal {
	
	@:auto public var change:Signal1<Int>;
	@:auto public var lostState:Signal1<Int>;
	public var currentPos(default,null):Int;

	private var list:Array<ButtonCore>;
	public var state(get,set):Int;
	private var swto:Int;
	private var ret:Bool;
	private var def:Int;
	
	public function new(a:Array<ButtonCore>, def:Int = 0, swto:Int = 2, ret:Bool = false) {
		this.swto = swto;
		this.ret = ret;
		this.def = def;
		state = def;
		list = a;
		for (i in 0...a.length) {
			if (i == def)
			{
				a[i].disable();
				a[i].mode = swto;
			}
			//select.listen(a[i].click.sub([0], [i]));
			a[i].onClick.sub(0).bind1(i).add(eChange);
			if (ret) a[i].onClick.sub(swto).bind1(i).add(changeRet);
		}
		change.add(setState, -1);
	}
	
	private function changeRet():Void eChange.dispatch( -1 );
	
	private function setState(n:Int):Void {
		if (state == n) return;
		//if (list[state] != null) list[state].mode = 0;
		if (list[state] != null) {
			list[state].enable();
			list[state].mode = 0;
		}
		//if (list[n] != null) list[n].mode = swto;
		if (list[n] != null) {
			list[n].disable();
			list[n].mode = swto;
		}
		eLostState.dispatch(state);
		state = n;
	}
	
	public function next():Void {
		if (state + 1 < list.length) eChange.dispatch(state+1);
	}
	
	public function prev():Void {
		if (state - 1 >= 0) eChange.dispatch(state-1);
	}
	
	inline private function get_state():Int return currentPos;
	inline private function set_state(v:Int):Int return currentPos = v;
	
}