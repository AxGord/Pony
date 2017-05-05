/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.pixi;

import pixi.core.math.shapes.Rectangle;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pony.Or;
import pony.time.DT;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.time.Time;

/**
 * FastMovieClip
 * @author AxGord <axgord@gmail.com>
 */
class FastMovieClip {
	
	private static var storage:Map<String, FastMovieClip> = new Map();
	
	public var totalFrames(get, never):Int;
	private var pool:Array<Sprite> = [];
	private var data:Array<Pair<Rectangle, Rectangle>>;
	public var texture(default, null):Texture;
	private var timer:DTimer;
	public var frame(default, set):Int = 0;
	public var loop:Bool = true;
	
	public function new(data:Or<Array<Texture>, Array<String>>, frameTime:Time, fixedTime:Bool = false) {
		var data = converOr(data);
		texture = data[0];
		var first:Bool = true;
		this.data = [for (t in data) {
			var p = new Pair(t.trim, t.frame);
			if (!first) {
				t.destroy();
			} else {
				first = false;
			}
			p;
		}];
		timer = fixedTime ? DTimer.createFixedTimer(frameTime, -1) : DTimer.createTimer(frameTime, -1);
		timer.complete << tick;
	}
	
	public static function fromStorage(data:Or<Array<Texture>, Array<String>>, frameTime:Time, fixedTime:Bool = false):FastMovieClip {
		var n = idFromTexture(converOrFirst(data));
		if (!storage.exists(n)) {
			return storage[n] = new FastMovieClip(data, frameTime, fixedTime);
		} else {
			return storage[n];
		}
	}
	
	@:extern public static inline function fromSprite(s:Sprite):FastMovieClip return fromTexture(s.texture);
	@:extern public static inline function fromTexture(t:Texture):FastMovieClip return storage[idFromTexture(t)];
	@:extern private static inline function idFromTexture(t:Texture):String return t.baseTexture.imageUrl + '_' + t.frame.x + '_' + t.frame.y;
	
	@:extern private static inline function converOr(data:Or<Array<Texture>, Array<String>>):Array<Texture> {
		return switch data {
			case OrState.A(t): t;
			case OrState.B(s): [for (e in s) Texture.fromFrame(e)];
		};
	}
	
	@:extern private static inline function converOrFirst(data:Or<Array<Texture>, Array<String>>):Texture {
		return switch data {
			case OrState.A(t): t[0];
			case OrState.B(s): Texture.fromFrame(s[0]);
		};
	}
	
	private function tick(dt:DT):Void {
		if (loop && frame >= totalFrames - 1)
			frame = 0;
		else
			frame++;
			
		onFrameUpdate(frame, dt);
			
		if (!loop && frame >= totalFrames - 1) {
			stop();
			DeltaTime.fixedUpdate < onComplete;
		}
	}
	
	dynamic public function onComplete(dt:DT):Void {}
	dynamic public function onFrameUpdate(frame:Int, dt:DT):Void {}
	
	@:extern public inline function get():Sprite {
		if (pool.length > 0) {
			return pool.pop();
		} else {
			return new Sprite(texture);
		}
	}
	
	@:extern public inline function ret(s:Sprite):Void pool.push(s);
	
	@:extern public inline function play(dt:DT=0):Void timer.start(dt);
	
	@:extern public inline function stop():Void {
		timer.stop();
		timer.reset();
	}
	
	@:extern public inline function gotoAndPlay(frame:Int, dt:DT=0):Void {
		this.frame = frame;
		play(dt);
	}
	
	@:extern public inline function gotoAndStop(frame:Int):Void {
		this.frame = frame;
		stop();
	}
	
	@:extern public inline function set_frame(n:Int):Int {
		if (n < 0) n = 0;
		else if (n >= totalFrames) n = data.length - 1;
		texture.trim = data[n].a;
		texture.frame = data[n].b;
		return frame = n;
	}
	
	public function destroy():Void {
		for (s in pool) s.destroy();
		pool = null;
		
		var n = texture.baseTexture.imageUrl;
		storage.remove(n);
		texture.destroy(true);
		texture = null;
		data = null;
		timer.destroy();
		timer = null;
		
		onComplete = null;
	}
	
	@:extern inline private function get_totalFrames():Int return data.length;
	
}