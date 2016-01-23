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
package pony.pixijs.ui;

import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import pixi.extras.BitmapText;
import pony.events.Signal0;
import pony.geom.Border;
import pony.geom.GeomTools;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

using pony.Tools;
using pony.pixijs.PixijsExtends;

/**
 * Layout
 * @author AxGord <axgord@gmail.com>
 */
class Layout extends Sprite implements Declarator implements HasSignal {

	@:arg public var layoutWidth:Float;
	@:arg public var layoutHeight:Float;
	@:arg public var objects:Array<Container>;
	@:arg public var vert:Bool = false;
	@:arg public var border:Border<Int> = 0;
	
	@:auto public var onUpdate:Signal0;
	
	private var momentalLoad:Bool = true;
	
	public function new() {
		super();
		var loadlist:Array<Sprite> = [];
		for (obj in objects) if (Std.is(obj, Sprite)) loadlist.push(cast obj);
		loadlist.loadedList(update);
		momentalLoad = false;
	}
	
	private function update():Void {
		var positions = GeomTools.pointsCeil(GeomTools.center(
				new Point(layoutWidth, layoutHeight),
				[for (obj in objects)
					Std.is(obj, BitmapText) || Std.is(obj, Text)
					? new Point(untyped obj.textWidth, untyped obj.textHeight)
					: new Point(obj.width, obj.height)],
				vert, border
			));
		for (p in objects.pair(positions)) {
			p.a.x = p.b.x;
			p.a.y = p.b.y;
			addChild(p.a);
		}
		objects = null;
		if (momentalLoad)
			DeltaTime.fixedUpdate < eUpdate.dispatch.bind(false);
		else
			eUpdate.dispatch();
	}
	
	override public function destroy():Void {
		destroySignals();
		for (obj in objects) {
			removeChild(obj);
			obj.destroy();
		}
		objects = null;
		border = null;
		super.destroy();
	}
	
}