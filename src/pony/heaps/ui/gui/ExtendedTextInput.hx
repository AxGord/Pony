package pony.heaps.ui.gui;

import h2d.Font;
import h2d.Object;
import h2d.RenderContext;
import h2d.TextInput;
import h2d.Tile;

import hxd.Event;
import hxd.Key;

import pony.color.UColor;
import pony.geom.IWH;
import pony.geom.Point;
import pony.math.MathTools;
import pony.text.TextTools;
import pony.time.DeltaTime;
import pony.ui.keyboard.Keyboard;

@:enum abstract Transform(Int) {
	var uppercase = 1;
	var none = 0;
	var lowercase = -1;

	@:from public static inline function fromString(s: String): Transform {
		return switch s {
			case 'uppercase': uppercase;
			case 'lowercase': lowercase;
			case _: none;
		}
	}
}

/**
 * Extended text input
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class ExtendedTextInput extends TextInput implements IWH {

	public var enabled(default, set): Bool = true;
	public var lockFocus(default, set): Bool = false;
	public var onlyEn: Bool = false;
	public var transform: Transform = none;
	public var maxChars: UInt = 0;
	public var maxLines: UInt = 0;
	public var size(get, never): Point<Float>;

	private var nextChar: Null<String> = null;
	private var needFocus: Bool = false;

	public function new(font: Font, ?parent: Object) {
		super(font, parent);
		interactive.onTextInput = Tools.nullFunction1;
		interactive.onFocus = focusHandler;
		interactive.onFocusLost = focusLostHandler;
	}

	public function set_enabled(v: Bool): Bool {
		if (v == enabled) return v;
		enabled = v;
		interactive.visible = v;
		if (!v) blur();
		else if (lockFocus) focus();
		return v;
	}

	private inline function getLinesCount(): UInt return getAllLines().length;

	public function set_lockFocus(v: Bool): Bool {
		lockFocus = v;
		if (v) focus();
		else blur();
		return v;
	}

	override public function focus(): Void {
		if (enabled) {
			super.focus();
			needFocus = true;
			DeltaTime.skipUpdate(focusNow);
			DeltaTime.skipFrames(4, focusNow); // focus bugfix
		}
	}

	private function focusNow(): Void {
		if (needFocus) interactive.focus();
	}

	private function focusHandler(e: Event): Void {
		Keyboard.input << inputHandler;
		onFocus(e);
	}

	private function focusLostHandler(e: Event): Void {
		if (lockFocus) {
			focus();
		} else {
			Keyboard.input >> inputHandler;
			onFocusLost(e);
		}
	}

	private function inputHandler(charCode: UInt): Void {
		var event: Event = new Event(ETextInput);
		event.charCode = charCode;
		onTextInput(event);
		handleKey(event);
	}

	override private function handleKey(e: Event): Void {
		if (!canEdit) {
			nextChar = null;
			super.handleKey(e);
		} else switch e.keyCode {
			case #if sys 0 #else null #end: nextChar = String.fromCharCode(e.charCode);
			case Key.UP:
				var oldIndex: Int = cursorIndex;
				var index: Int = text.lastIndexOf('\n', cursorIndex - 1);
				cursorIndex = index != -1 ? MathTools.cmin(text.lastIndexOf('\n', index - 1) + (cursorIndex - index), index) : 0;
				updateSelection(oldIndex);
			case Key.DOWN:
				var oldIndex: Int = cursorIndex;
				var index: Int = text.indexOf('\n', cursorIndex);
				if (index != -1) {
					var prevIndex: Int = text.lastIndexOf('\n', cursorIndex - 1);
					var lastIndex: Int = text.indexOf('\n', index + 1);
					if (lastIndex == -1) lastIndex = text.length;
					cursorIndex = MathTools.cmin(index + (cursorIndex - prevIndex), lastIndex);
				} else {
					cursorIndex = text.length;
				}
				updateSelection(oldIndex);
			case _:
				var textBeforeChange: String = text;
				var changed: Bool = false;
				if (nextChar != null) {
					var char: String = nextChar;
					if (onlyEn) {
						var ch: String = String.fromCharCode(e.keyCode).toUpperCase();
						if (@:nullSafety(Off) TextTools.letters['en'].indexOf(ch) != -1)
							char = char == char.toLowerCase() ? ch.toLowerCase() : ch;
					}
					switch transform {
						case uppercase: char = char.toUpperCase();
						case lowercase: char = char.toLowerCase();
						case none:
					}
					@:nullSafety(Off) var code: UInt = char.charCodeAt(0);
					if (font.hasChar(code)) {
						beforeChange();
						if (selectionRange != null) cutSelection();
						text = text.substr(0, cursorIndex) + char + text.substr(cursorIndex);
						cursorIndex++;
						changed = true;
					}
				}
				nextChar = null;
				super.handleKey(e);
				if (text.length > textBeforeChange.length) {
					if (
						(maxChars > 0 && text.length > maxChars) ||
						(maxLines > 0 && getLinesCount() > maxLines) ||
						(maxWidth != null && textWidth > maxWidth)
					) {
						cursorIndex--;
						text = textBeforeChange;
						changed = false;
					}
				}
				if (changed) onChange();
		}
	}

	private function updateSelection(oldIndex: Int): Void {
		cursorBlink = 0.;
		if (Key.isDown(Key.SHIFT)) {
			if (cursorIndex == oldIndex) return;
			if (selectionRange == null) {
				selectionRange = oldIndex < cursorIndex ?
					{ start : oldIndex, length : cursorIndex - oldIndex } : { start : cursorIndex, length : oldIndex - cursorIndex };
			} else if (oldIndex == selectionRange.start) {
				selectionRange.length += oldIndex - cursorIndex;
				selectionRange.start = cursorIndex;
			} else {
				selectionRange.length += cursorIndex - oldIndex;
			}
			if (selectionRange.length == 0) {
				@:nullSafety(Off) selectionRange = null;
			} else if (selectionRange.length < 0) {
				selectionRange.start += selectionRange.length;
				selectionRange.length = -selectionRange.length;
			}
			selectionSize = 0;
		} else {
			@:nullSafety(Off) selectionRange = null;
		}
	}

	public inline function setCursorParams(y: Float, h: Float, ?color: Null<UColor>): Void {
		cursorTile.dy = y;
		if (color != null) selectionTile = Tile.fromColor(color, 0, hxd.Math.ceil(font.lineHeight), color.invertAlpha.af);
		selectionTile.dy = y;
		selectionTile.setSize(0, textHeight + h);
		cursorTile.setSize(cursorTile.width, textHeight + h);
	}

	public inline function blur(): Void {
		if (!lockFocus || !enabled) {
			needFocus = false;
			interactive.blur();
			cursorIndex = -1;
			selectionRange = {start: 0, length: 0};
		}
	}

	override function sync(ctx: RenderContext): Void {
		super.sync(ctx);
		if (maxLines > 0) interactive.height = font.lineHeight * maxLines;
	}

	public function wait(cb: Void -> Void): Void cb();
	private function get_size(): Point<Float> return new Point<Float>(textWidth * scaleX, textHeight * scaleY);

	public function destroyIWH(): Void {
		enabled = false;
		remove();
	}

}