package pony.flash.starling.ui;

import flash.geom.Rectangle;
import pony.flash.starling.converter.StarlingConverter;
import pony.flash.ui.Button;
import pony.flash.ui.Tree;
import pony.geom.Point.IntPoint;
import pony.ui.gui.TreeCore;
import starling.display.DisplayObject;
import starling.display.Sprite;
#if tweenmax
import com.greensock.TweenMax;
#end

/**
 * StarlingTree
 * @author Maletin
 */
class StarlingTree extends Sprite {

	private final _flashSource: flash.display.Sprite;
	private final _header: TreeElement;
	private final _nodes: Array<DisplayObject> = [];

	private var _xDisplacement: Int = 50;
	private var _headerButton: StarlingButton;
	private var _heightChangeCallback: Void -> Void;
	private var _nodesSprite: Sprite = new Sprite();

	private final _bufferRect: Rectangle = new Rectangle();
	private final group: Button;
	private final unit: Button;
	private final groupText: flash.display.Sprite;
	private final unitText: flash.display.Sprite;

	public var core: TreeCore;

	public var minimized(default, set): Bool;
	public var animated(default, set): Bool = false;

	public function new(flashSource: flash.display.Sprite, ?header: TreeElement, ?core: TreeCore) {
		super();

		_flashSource = flashSource;
		_header = header;

		group = untyped flashSource.group;
		unit = untyped flashSource.unit;
		groupText = untyped flashSource.groupText;
		unitText = untyped flashSource.unitText;

		this.core = core != null ? core : new TreeCore();

		if (_header == null) _xDisplacement = 0;
		addChild(_nodesSprite);

		if (_header != null) {
			switch (_header) {
				case Group(text, _): drawGroup(new IntPoint(0, 0), text);
				case _:
			}
		}

		_nodesSprite.clipRect = new Rectangle(0, _header != null ? _headerButton.height : 1, 10000, 10000);
	}

	public function draw(): Void {
		for (n in core.nodes) {
			switch (n) {
				case Group(text, t):
					final subTree = new StarlingTree(_flashSource, n, t);
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

	public function treeHeight(): Float {
		getBounds(this, _bufferRect);
		return _bufferRect.bottom;
	}

	private function updateNodesPosition(): Void {
		var previous: Float = _headerButton != null ? _headerButton.height : 0;
		for (node in _nodes) {
			node.y = node.visible ? previous : 0;
			if (node.visible) previous = node.y + (Std.is(node, StarlingTree) ? untyped node.treeHeight() : node.height);
		}

		if (_heightChangeCallback != null) _heightChangeCallback();
	}

	public function setHeightChangeCallback(callback: Void -> Void): Void {
		_heightChangeCallback = callback;
	}

	private function set_minimized(value: Bool): Bool {
		minimized = value;

		if (_headerButton != null) _headerButton.core.mode = minimized ? 2 : 0;

		final toY: Float = minimized ? -_nodesSprite.height : 0;
		if (animated) {
			#if tweenmax
			TweenMax.to(
				_nodesSprite, Tree.basicAnimationTime + Tree.additionalAnimationTimePerPixel * _nodesSprite.height,
				{ y: toY, onUpdate: updateNodesPosition }
			);
			#end
		} else {
			_nodesSprite.y = toY;
			updateNodesPosition();
		}

		return minimized;
	}

	private function set_animated(value: Bool): Bool {
		animated = #if tweenmax value #else false #end;

		return animated;
	}

	private function drawUnit(p: IntPoint, text: String, func: Void -> Void): Void {
		final button: StarlingButton = cast getNewObject(unit);

		button.core.onClick.add(func);

		final node = new Sprite();
		node.addChild(button);
		addToPoint(p, node);
		_nodes.push(node);

		final textField = drawText(p, text, cast getNewObject(unitText));
		node.addChild(textField);
	}

	private function drawGroup(p: IntPoint, text: String): Void {
		final button: StarlingButton = cast getNewObject(group);
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
		return StarlingConverter.getObjectWithNoParent(Type.createInstance(Type.getClass(object), []));
	}

	private function toggleMinimize(): Void {
		minimized = !minimized;
	}

	private function drawText(p: IntPoint, text: String, textObject: Sprite): Sprite {
		textObject.touchable = false;
		untyped textObject.getChildByName('text').text = text;
		return textObject;
	}

	private function addToPoint(p: IntPoint, o: DisplayObject): Void {
		o.x = p.x;
		o.y = p.y;
		_nodesSprite.addChild(o);
	}

}
