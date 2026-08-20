package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import pony.flash.FLStage;
import pony.geom.Point.IntPoint;
import pony.ui.gui.TreeCore;
#if tweenmax
import com.greensock.TweenMax;
#end

/**
 * Tree
 * @author AxGord <axgord@gmail.com>
 */
class Tree extends Sprite implements FLStage {

	@:stage private var group: Button;
	@:stage private var unit: Button;
	@:stage private var groupText: Sprite;
	@:stage private var unitText: Sprite;

	public static var basicAnimationTime: Float = 0.1;
	public static var additionalAnimationTimePerPixel: Float = 0.00015;

	#if !starling
	private var _header: TreeElement;

	private final _nodes: Array<DisplayObject> = [];

	private var _xDisplacement: Int = 50;
	private var _headerButton: Button;
	private var _heightChangeCallback: Void -> Void;
	private var _nodesSprite: Sprite = new Sprite();

	private final _bufferRect: Rectangle = new Rectangle();

	public var core: TreeCore;

	public var minimized(default, set): Bool;
	public var animated(default, set): Bool = false;

	public function new(?header: TreeElement, ?core: TreeCore) {
		super();

		removeChildren();

		_header = header;

		this.core = core != null ? core : new TreeCore();

		if (_header == null) _xDisplacement = 0;
		addChild(_nodesSprite);

		if (_header != null) {
			switch (_header) {
				case Group(text, _): drawGroup(new IntPoint(0, 0), text);
				case _:
			}
		}
	}

	public function setHeaderAndCore(header: TreeElement, core: TreeCore): Void {
		_header = header;
		this.core = core;
		switch (_header) {
			case Group(text, _): drawGroup(new IntPoint(0, 0), text);
			case _:
		}
		_xDisplacement = 50;
	}

	public function draw(): Void {
		for (n in core.nodes) {
			switch (n) {
				case Group(text, t):
					final subTree: Tree = cast getNewObject(this);
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

		FLTools.reverseChildren(_nodesSprite);
	}

	public function treeHeight(): Float return getBounds(this).bottom;

	private function updateNodesPosition(): Void {
		var previous: Float = _headerButton != null ? _headerButton.height : 0;
		for (node in _nodes) {
			if (!Std.is(node, Tree)) node.visible = node.y + _nodesSprite.y >= -y;
			node.y = previous;
			previous = node.y + (Std.is(node, Tree) ? untyped node.treeHeight() : node.height);
		}

		if (_heightChangeCallback != null) _heightChangeCallback();
	}

	public function setHeightChangeCallback(callback: Void -> Void): Void {
		_heightChangeCallback = callback;
	}

	private function set_minimized(value: Bool): Bool {
		minimized = value;

		if (_headerButton != null) _headerButton.core.mode = minimized ? 2 : 0;

		final toY: Float = minimized ? -nodesSpriteBottom() : 0;
		if (animated) {
			#if tweenmax
			TweenMax.killTweensOf(_nodesSprite);
			TweenMax.to(
				_nodesSprite, basicAnimationTime + additionalAnimationTimePerPixel * nodesSpriteBottom(),
				{ y: toY, onUpdate: updateNodesPosition }
			);
			#end
		} else {
			_nodesSprite.y = toY;
			updateNodesPosition();
		}

		return minimized;
	}

	private function nodesSpriteBottom(): Float {
		return _nodesSprite.getRect(_nodesSprite).bottom - (_headerButton != null ? _headerButton.height : 0);
	}

	private function set_animated(value: Bool): Bool {
		animated = #if tweenmax value #else false #end;

		return animated;
	}

	private function drawUnit(p: IntPoint, text: String, func: Void -> Void): Void {
		final button: Button = cast getNewObject(unit);

		button.core.onClick.add(func);

		final node = new Sprite();
		node.addChild(button);
		addToPoint(p, node);
		_nodes.push(node);

		final textField = drawText(p, text, cast getNewObject(unitText));
		node.addChild(textField);
	}

	private function drawGroup(p: IntPoint, text: String): Void {
		final button: Button = cast getNewObject(group);
		_headerButton = button;
		button.core.onClick.add(toggleMinimize);

		final node = new Sprite();
		node.addChild(button);
		button.x = p.x;
		button.y = p.y;
		addChild(node);

		final textField = drawText(p, text, cast getNewObject(groupText));
		node.addChild(textField);
	}

	private function getNewObject(object: Dynamic): DisplayObject {
		return Type.createInstance(Type.getClass(object), []);
	}

	private function toggleMinimize(): Void {
		minimized = !minimized;
	}

	private function drawText(p: IntPoint, text: String, textObject: Sprite): Sprite {
		textObject.mouseEnabled = textObject.mouseChildren = false;
		untyped textObject.getChildByName('text').text = text;
		untyped textObject.getChildByName('text').mouseEnabled = false;
		return textObject;
	}

	private function addToPoint(p: IntPoint, o: DisplayObject): Void {
		o.x = p.x;
		o.y = p.y;
		_nodesSprite.addChild(o);
	}

	private function headerHeight(): Float return _header != null ? _headerButton.height : 0;
	#end

}
