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

import pony.time.DeltaTime;

/**
 * PopupManager
 * @author AxGord <axgord@gmail.com>
 */
class PopupManager<Popup> {
	
	private var list:Array<Popup> = [];
	private var current:IPopup;
	private var wantFromList:Bool = false;
	
	public var onStartClose:Void -> Void;
	
	public function new() {}
	
	public function showPopup(type:Popup):Void {
		if (current == null && !wantFromList) {
			_showPopup(type);
		} else {
			list.push(type);
		}
	}
	
	public function hardPopup(type:Popup):Void {
		abortFromList();
		list = [];
		endClose();
		_showPopup(type);
	}
	
	private function _showPopup(type:Popup):Void {
		current = getPopup(type);
		current.onClose = close;
	}
	
	public dynamic function getPopup(type:Popup):IPopup return throw 'Method not set';
	public dynamic function onClose():Void {}
	
	public function close():Void {
		if (abortFromList()) return;
		if (current == null) return;
		if (onStartClose != null)
			onStartClose();
		else
			endClose();
	}
	
	public function endClose():Void {
		if (current == null) return;
		current.destroyPopup();
		current = null;
		onClose();
		if (!wantFromList && list.length > 0 ) {
			wantFromList = true;
			DeltaTime.fixedUpdate < showFromList;
		}
	}

	private function abortFromList():Bool {
		if (wantFromList) {
			wantFromList = false;
			DeltaTime.fixedUpdate >> showFromList;
			return true;
		} else {
			return false;
		}
	}

	private function showFromList():Void {
		wantFromList = false;
		_showPopup(list.shift());
	}
	
	@:extern public inline function clearList():Void list = [];
	
}