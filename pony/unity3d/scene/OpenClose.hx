/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.unity3d.scene;

import pony.events.Signal;
import pony.events.Signal0;
import unityengine.MonoBehaviour;
import unityengine.Quaternion;
import unityengine.Vector3;
using hugs.HUGSWrapper;
/**
 * OpenCloseUCore
 * @author AxGord <axgord@gmail.com>
 */
@:nativeGen class OpenClose extends MonoBehaviour {
	
	public var openPos:Vector3;
	public var openRotation:Quaternion;
	@:meta(UnityEngine.HideInInspector)
	public var open(get, set):Bool;
	private var _open:Bool = false;
	public var onOpen(default, null):Signal0<OpenClose>;
	public var onClose(default, null):Signal0<OpenClose>;
	@:meta(UnityEngine.HideInInspector)
	private var startPos:Vector3;
	@:meta(UnityEngine.HideInInspector)
	private var startRotation:Quaternion;
	
	@:meta(UnityEngine.HideInInspector)
	private var needChangePos:Bool;
	@:meta(UnityEngine.HideInInspector)
	private var needChangeRot:Bool;
	
	public function new() {
		super();
		onOpen = Signal.create(this);
		onClose = Signal.create(this);
	}
	
	private function Start():Void {
		startPos = transform.position;
		startRotation = transform.rotation;
		//if (openPos.x == 0 && openPos.y == 0 && openPos.z == 0) openPos = startPos;
		needChangePos = !(openPos.x == 0 && openPos.y == 0 && openPos.z == 0);
		//if (openRotation.x == 0 && openRotation.y == 0 && openRotation.z == 0) openRotation = startRotation;
		needChangeRot = !(openRotation.x == 0 && openRotation.y == 0 && openRotation.z == 0);
	}
	
	inline private function get_open():Bool return _open;
	
	public function set_open(to:Bool):Bool {
		if (_open == to) return to;
		if (to) {
			silentOpen();
			onOpen.dispatch();
		} else {
			silentClose();
			onClose.dispatch();
		}
		return to;
	}
	
	public function silentOpen():Void {
		_open = true;
		if (needChangePos) transform.position = openPos;
		if (needChangeRot) transform.rotation = openRotation;
	}
	
	public function silentClose():Void {
		_open = false;
		if (needChangePos) transform.position = startPos;
		if (needChangeRot) transform.rotation = startRotation;
	}
	
	inline public function change():Void open = !open;
	
	public function syncWith(d:Door):Void {
		onOpen << d.silentOpen;
		onClose << d.silentClose;
		d.onOpen << silentOpen;
		d.onClose << silentClose;
	}
	
	public function unsyncWith(d:Door):Void {
		onOpen >> d.silentOpen;
		onClose >> d.silentClose;
		d.onOpen >> silentOpen;
		d.onClose >> silentClose;
	}
	
}