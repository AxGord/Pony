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
package pony.ui;
import pony.DeltaTime;
import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class SlideCore {
	
	public var total:Float;
	public var current:Float;
	public var speed:Float;
	public var minimalMove:Float = 0.1;
	public var update(default, null):Signal;
	
	public var opened(default, null):Bool;
	public var closed(default, null):Bool;
	
	public var onOpen(default, null):Signal;
	public var onClose(default, null):Signal;
	
	public function new(total:Float=1, speed:Float=30) {
		this.total = total;
		this.speed = speed;
		current = 0;
		opened = false;
		closed = true;
		update = new Signal();
		onOpen = new Signal();
		onClose = new Signal();
	}
	
	public function open(?to:Float):Void {
		if (to != null) total = to;
		if (opened) return;
		if (!closed) DeltaTime.update.remove(closing);
		closed = false;
		DeltaTime.update.add(opening);
	}
	
	public function close():Void {
		if (closed) return;
		if (!opened) DeltaTime.update.remove(opening);
		opened = false;
		DeltaTime.update.add(closing);
	}
	
	private function opening(dt:Float):Void {
		current += (total * minimalMove + current) * dt * speed;
		if (current >= total) {
			current = total;
			opened = true;
			DeltaTime.update.remove(opening);
			onOpen.dispatch();
		}
		update.dispatch(current, opened, closed);
	}
	
	
	private function closing(dt:Float):Void {
		current -= (total * minimalMove + (total - current)) * dt * speed;
		if (current <= 0) {
			current = 0;
			closed = true;
			DeltaTime.update.remove(closing);
			onClose.dispatch();
		}
		update.dispatch(current, opened, closed);
	}
	
	
}