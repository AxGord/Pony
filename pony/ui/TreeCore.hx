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
package pony.ui;

import pony.geom.Point;
import pony.magic.Declarator;

private enum TreeElement {
	Group(name:String, tree:TreeCore);
	Unit(name:String, fun:Void->Void);
}

/**
 * Tree
 * @author AxGord <axgord@gmail.com>
 */
class TreeCore implements Declarator {
	
	@:arg private var elementHeight:Int;
	@:arg private var drawUnit:IntPoint->String->Pair<ButtonCore, Void->Void> ;
	@:arg private var drawGroup:IntPoint->String->Pair<ButtonCore, Void->Void>;
	@:arg private var lvl:Int = 0;
	@:arg private var parent:TreeCore = null;
	
	public var opened:Bool = lvl == 0;
	
	private var nodes(default, null):Array<TreeElement> = [];
	private var removers:List < Void->Void > = new List();
	
	public function addGroup(text:String):TreeCore {
		var t = new TreeCore(elementHeight, drawUnit, drawGroup, lvl+1, this);
		nodes.push(Group(text, t));
		return t;
	}
	
	public function addUnit(text:String, f:Void->Void):Void {
		nodes.push(Unit(text, f));
	}
	
	public function draw(line:Int = 0):Int {
		if (opened) for (n in nodes) {
			switch n {
				case Unit(text, f):
					var p = drawUnit(new IntPoint(lvl * elementHeight, line * elementHeight), text);
					p.a.click.add(f);
					removers.push(p.a.click.remove.bind(f));
					removers.push(p.b);
					line++;
				case Group(text, t):
					var p = drawGroup(new IntPoint(lvl * elementHeight, line * elementHeight), text);
					var b = p.a;
					if (t.opened) {
						b.mode = 0;
						b.click.add(t.close);
						removers.push(b.click.remove.bind(t.close));
					} else {
						b.mode = 2;
						b.click.add(t.open);
						removers.push(b.click.remove.bind(t.open));
					}
					b.click.add(update);
					removers.push(b.click.remove.bind(update));
					removers.push(p.b);
					line = t.draw(line+1);
			}
		}
		return line;
	}
	
	public function close():Void opened = false;
	public function open():Void opened = true;
	
	private function update():Void {
		if (parent == null) {
			clear();
			draw();
		} else parent.update();
	}
	
	public function clear():Void {
		for (e in removers) e();
		removers.clear();
		for (n in nodes) switch n {
			case Group(_, t): t.clear();
			case _:
		}
	}
	
}