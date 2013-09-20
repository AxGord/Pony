/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;

import pony.events.Signal;

/**
 * Loader
 * Organize loading for your application
 * @author AxGord <axgord@gmail.com>
 */
class Loader {
	
	public var intensivity:Int;
	public var beginWait:Int;
	
	private var actions:List < Void->Void > ;
	private var totalActions(default, null):Int = 0;
	public var total:Int = 0;
	public var complites:Int = 0;
	public var progress(default, null):Signal;
	public var complite(default, null):Signal;
	
	public var loaded:Bool = false;
	
	public function new(intensivity:Int = 10, beginWait:Int = 0) {
		this.intensivity = intensivity;
		this.beginWait = beginWait;
		actions = new List < Void->Void >();
		progress = new Signal(this);
		complite = new Signal(this);
		complite.once(end);
		
	}
	
	public function init(fastLoad:Bool = false):Void {
		if (!fastLoad) {
			if (beginWait == 0)
				begin();
			else
				DeltaTime.update.add(wait);
		} else
			fastEnd();
	}
	
	private function fast():Void {
		complite.dispatch();
	}
	
	private function wait():Void {
		if (beginWait-- <= 0) {
			DeltaTime.update.remove(wait);
			begin();
		}
	}
	
	inline private function begin():Void {
		DeltaTime.update.add(update);
	}
	
	private function update():Void {
		for (_ in 0...intensivity) {
			#if fastload
			if (actions.length > 0) actions.pop();
			else break;
			#else
			if (actions.length > 0) actions.pop()();
			else break;
			#end
		}
		if (totalActions == 0)
			progress.dispatch(counterPercent());
		else if (total == 0)
			progress.dispatch(listPercent());
		else
			progress.dispatch((listPercent() + counterPercent())/2);
		if (actions.length == 0 && complites == total)
			complite.dispatch();
	}
	
	inline private function listPercent():Float return 1 - actions.length / totalActions;
	inline private function counterPercent():Float return complites / total;
	
	public function end():Void {
		DeltaTime.update.remove(update);
		loaded = true;
	}
	
	public function addAction(f:Void->Void):Void {
		totalActions++;
		actions.push(f);
	}
	
	inline private function fastEnd():Void {
		complite.dispatch();
	}
	
}