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
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import haxe.CallStack;
import pony.flash.FLSt;
import pony.geom.Point.IntPoint;
import pony.Pair;
import pony.Pool;
import pony.ui.ButtonCore;
import pony.ui.TreeCore;
#if tweenmax
import com.greensock.TweenMax;
#end

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
	
	#if !starling
	
	private var _header:TreeElement;
	private var _nodes:Array<DisplayObject> = new Array<DisplayObject>();
	private var _xDisplacement:Int = 50;
	
	private var _headerButton:Button;
	private var _heightChangeCallback:Void->Void;
	private var _nodesSprite:Sprite = new Sprite();
	
	private var _bufferRect:Rectangle = new Rectangle();
	
	public var core:TreeCore;
	
	public var minimized(default, set):Bool;
	public var animated(default, set):Bool = false;
	
	public function new(header:TreeElement = null, core:TreeCore = null) {
		//super();
		//FLTools.init < init;
		super();
		
		removeChildren();
		
		_header = header;
		
		this.core = core != null ? core : new TreeCore();
		
		if (_header == null) _xDisplacement = 0;
		addChild(_nodesSprite);
		
		if (_header != null)
		{
			switch (_header)
			{
				case Group(text, t): drawGroup(new IntPoint(0, 0), text);
				default:
			}
		}
		
		//var mask:Sprite = new Sprite();
		//mask.graphics.beginFill(0x0, 1);
		//mask.graphics.drawRect(0, headerHeight(), 1000, 10000);
		//mask.graphics.endFill();
		//this.mask = mask;
		//addChild(mask);
	}
	
	public function setHeaderAndCore(header:TreeElement, core:TreeCore):Void
	{
		_header = header;
		this.core = core;
		switch (_header)
		{
			case Group(text, t): drawGroup(new IntPoint(0, 0), text);
			default:
		}
		_xDisplacement = 50;
	}
	
	public function draw():Void
	{
		for (n in core.nodes)
		{
			switch (n)
			{
				case Group(text, t):
					var subTree:Tree = cast getNewObject(this);
					subTree.setHeaderAndCore(n, t);
					subTree.draw();
					subTree.x = _xDisplacement;
					subTree.y = this.height;
					subTree.setHeightChangeCallback(updateNodesPosition);
					_nodesSprite.addChild(subTree);
					_nodes.push(subTree);
				case Unit(text, f):
					drawUnit(new IntPoint(_xDisplacement, Std.int(this.height)), text, f);
			}
		}
		minimized = !core.opened;
		
		animated = true;
	}
	
	public function treeHeight():Float
	{
		return getBounds(this).bottom;
	}
	
	private function updateNodesPosition():Void
	{
		var previous:Float = _headerButton != null ? _headerButton.height : 0;
		for (node in _nodes)
		{
			node.y = node.visible ? previous : 0;
			if (node.visible) previous = node.y + (Std.is(node, Tree) ? untyped node.treeHeight() : node.height);
		}
		
		if (_heightChangeCallback != null) _heightChangeCallback();
	}
	
	public function setHeightChangeCallback(callback:Void->Void):Void
	{
		_heightChangeCallback = callback;
	}
	
	private function set_minimized(value:Bool):Bool
	{
		minimized = value;
		
		if (_headerButton != null) _headerButton.core.mode = minimized ? 2 : 0;
		
		var toY:Float = minimized ? - _nodesSprite.height : 0;
		if (animated)
		{
			#if tweenmax
			TweenMax.killTweensOf(_nodesSprite);
			TweenMax.to(_nodesSprite, 0.2 + 0.0003 * _nodesSprite.height, { y:toY, onUpdate:updateNodesPosition } );
			#end
		}
		else
		{
			_nodesSprite.y = toY;
			updateNodesPosition();
		}
		
		return minimized;
	}
	
	private function set_animated(value:Bool):Bool
	{
		#if tweenmax
		animated = value;
		#else
		animated = false;
		#end
		
		return animated;
	}
	
	private function drawUnit(p:IntPoint, text:String, func:Void->Void):Void
	{
		var button:Button = cast getNewObject(unit);
		
		button.core.click.add(func);
		
		var node = new Sprite();
		node.addChild(button);
		addToPoint(p, node);
		_nodes.push(node);
		
		var textField = drawText(p, text, cast getNewObject(unitText));
		node.addChild(textField);
	}
	
	private function drawGroup(p:IntPoint, text:String):Void
	{
		var button:Button = cast getNewObject(group);
		_headerButton = button;
		button.core.click.add(toggleMinimize);
		
		var node = new Sprite();
		node.addChild(button);
		button.x = p.x;
		button.y = p.y;
		addChild(node);
		
		var textField = drawText(p, text, cast getNewObject(groupText));
		node.addChild(textField);
	}
	
	private function getNewObject(object:Dynamic):DisplayObject
	{
		return Type.createInstance(Type.getClass(object), []);
	}
	
	private function toggleMinimize():Void
	{
		minimized = !minimized;
	}
	
	private function drawText(p:IntPoint, text:String, textObject:Sprite):Sprite
	{
		textObject.mouseEnabled = textObject.mouseChildren = false;
		untyped textObject.getChildByName("text").text = text;
		untyped textObject.getChildByName("text").mouseEnabled = false;
		return textObject;
	}
	
	private function addToPoint(p:IntPoint, o:DisplayObject):Void {
		o.x = p.x;
		o.y = p.y;
		_nodesSprite.addChild(o);
	}
	
	private function headerHeight():Float
	{
		return _header != null ? _headerButton.height : 0;
	}
	
	#end
}