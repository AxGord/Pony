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
package pony.ui.gui;
import pony.geom.Direction;
import pony.events.Event;
import pony.events.Signal;
import pony.geom.Point;
using pony.Tools;
/**
 * ...
 * @author AxGord
 */
class PipeCore {
	
	private var data:Array<Array<DirectionContainer<Bool>>>;

	public var remove:Signal;
	public var add:Signal;
	
	private var xc:Int;
	private var yc:Int;
	
	public function new(xc:Int, yc:Int) {
		this.xc = xc;
		this.yc = yc;
		remove = new Signal();
		add = new Signal();
		data = [];
		for (y in 0...yc) {
			var a:Array<DirectionContainer<Bool>> = [];
			for (x in 0...xc) a.push(empty());
			data.push(a);
		}
	}
	
	public inline function empty():DirectionContainer<Bool> return { left:false, right:false, up:false, down:false };
	
	public inline function clearPoint(p:Point<Int>):Void setPoint(p, empty());
	
	public function setPoint(p:Point<Int>, state:DirectionContainer<Bool>):Void {
		/*
		trace('Position');
		trace(p);
		trace('Old state');
		trace(data[p.y][p.x]);
		trace('New state');
		trace(state);
		*/
		//var saveState:DirectionContainer<Bool> = data[p.y][p.x];
		
		var removed:List<Array<Int>> = new List<Array<Int>>();
		var added:List<Array<Int>> = new List<Array<Int>>();
		
		if (data[p.y][p.x].down && !state.down) {
			for (i in (p.y + 1)...yc) {
				if (data[i][p.x].up) {
					act(remove, removed, [1, p.x, p.y, i]);
					var j:Int = p.y;
					while ( --j > 0 ) if (data[j][p.x].down) {
						act(add, added, [1, p.x, j, i]);
						break;
					}
					break;
				}
				if (data[i][p.x].down) break;
			}
		}
		if (data[p.y][p.x].up && !state.up) {
			var i:Int = p.y;
			while (--i > 0) {
				if (data[i][p.x].down) {
					act(remove, removed, [1, p.x, i, p.y]);
					for (j in (p.y + 1)...yc) if (data[j][p.x].up) {
						act(add, added, [1, p.x, i, j]);
						break;
					}
					break;
				}
				if (data[i][p.x].up) break;
			}
		}
		if (data[p.y][p.x].right && !state.right) {
			for (i in (p.x + 1)...xc) {
				if (data[p.y][i].left) {
					remove.dispatch(false, p.y, p.x, i);
					break;
				}
				if (data[p.y][i].right) break;
			}
		}
		if (data[p.y][p.x].left && !state.left) {
			var i:Int = p.x;
			while (--i > 0) {
				if (data[p.y][i].right) {
					remove.dispatch(false, p.y, i, p.x);
					break;
				}
				if (data[p.y][i].left) break;
			}
		}
		
		
		if (state.down && !data[p.y][p.x].down) {
			for (i in (p.y + 1)...yc) {
				if (data[i][p.x].up) {
					var j:Int = p.y;
					while (--j > 0) if (data[j][p.x].down) {
						act(remove, removed, [1, p.x, j, i]);
						break;
					}
					act(add, added, [1, p.x, p.y, i]);
					break;
				}
				if (data[i][p.x].down) break;
			}
		}
		if (state.up && !data[p.y][p.x].up) {
			var i:Int = p.y;
			while (--i > 0) {
				if (data[i][p.x].down) {
					for (j in (p.y + 1)...yc) if (data[j][p.x].up) {
						act(remove, removed, [1, p.x, i, j]);
						break;
					}
					act(add, added, [1, p.x, i, p.y]);
					break;
				}
				if (data[i][p.x].up) break;
			}
		}
		if (state.left && !data[p.y][p.x].left) {
			for (i in (p.x+1)...xc) {
				if (data[p.y][i].right) {
					var j:Int = p.x;
					while (--j > 0) if (data[p.y][j].left) {
						remove.dispatch(false, p.y, j, i);
						break;
					}
					add.dispatch(false, p.y, p.x, i);
					break;
				}
				if (data[p.y][i].left) break;
			}
		}
		if (state.right && !data[p.y][p.x].right) {
			var i:Int = p.x;
			while (--i > 0) {
				if (data[p.y][i].left) {
					for (j in (p.x + 1)...xc) if (data[p.y][j].right) {
						remove.dispatch(false, p.y, i, j);
						break;
					}
					add.dispatch(false, p.y, i, p.x);
					break;
				}
				if (data[p.y][i].right) break;
			}
		}
		
		data[p.y][p.x] = state;
	}
	
	private inline static function act(signal:Signal, storage:List<Array<Int>>, point:Array<Int>):Void {
		if (!storage.thereIs(point)) {
			signal.dispatch(point[0] == 1 ? true : false, point[1], point[2], point[3]);
			storage.add(point);
		}
	}
	
}