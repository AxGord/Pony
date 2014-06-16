/**
* Copyright (c) 2013-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import pony.flash.FLSt;
import pony.geom.Point.IntPoint;
import pony.Pair;
import pony.Pool;
import pony.ui.ButtonCore;
import pony.ui.TreeCore;

using pony.flash.FLExtends;

/**
 * Tree
 * @author AxGord <axgord@gmail.com>
 */
class Tree extends Sprite implements FLSt {
	
	@:st private var group:Button;
	@:st private var unit:Button;
	@:st private var groupText:Sprite;
	@:st private var unitText:Sprite;
	
	public var core:TreeCore;
	
	private var groupPool:Pool<Button>;
	private var unitPool:Pool<Button>;
	private var groupTextPool:Pool<Sprite>;
	private var unitTextPool:Pool<Sprite>;
	
	public var defaultMode:Int = 0;
	
	public function new() {
		super();
		FLTools.init < init;
	}
	
	private function init():Void {
		core = new TreeCore(Std.int(group.height), drawUnit, drawGroup);
		groupTextPool = new Pool(Type.getClass(groupText));
		unitTextPool = new Pool(Type.getClass(unitText));
		unitPool = new Pool(Type.getClass(unit));
		groupPool = new Pool(Type.getClass(group));
		removeAllChild();
	}
	
	private function drawUnit(p:IntPoint, text:String):Pair<ButtonCore, Void->Void> {
		var o:Button = unitPool.get();
		addToPoint(p, o);
		var t = drawText(p, text, unitTextPool.get());
		return new Pair(o.core, function() {
			removeChild(o);
			unitPool.ret(o);
			removeChild(t);
			unitTextPool.ret(t);
		} );
	}
	
	private function drawGroup(p:IntPoint, text:String):Pair<ButtonCore, Void->Void> {
		var o:Button = groupPool.get();
		addToPoint(p, o);
		var t = drawText(p, text, groupTextPool.get());
		return new Pair(o.core, function() {
			removeChild(o);
			groupPool.ret(o);
			removeChild(t);
			groupTextPool.ret(t);
		} );
	}
	
	private function drawText(p:IntPoint, text:String, o:Sprite):Sprite {
		addToPoint(p, o);
		o.mouseChildren = false;
		o.mouseEnabled = false;
		untyped o.text.text = text;
		return o;
	}
	
	private function addToPoint(p:IntPoint, o:DisplayObject):Void {
		o.x = p.x;
		o.y = p.y;
		addChild(o);
	}
	
}