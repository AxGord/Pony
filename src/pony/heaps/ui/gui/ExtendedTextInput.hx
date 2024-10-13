package pony.heaps.ui.gui;

import h2d.Font;
import h2d.Object;
import h2d.RenderContext;
import h2d.TextInput;
import h2d.Tile;

import hxd.Event;
import hxd.Key;
import hxd.System;

import pony.color.UColor;
import pony.geom.IWH;
import pony.geom.Point;
import pony.math.MathTools;
import pony.text.TextTools;
import pony.time.DeltaTime;
import pony.ui.keyboard.Keyboard;

#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Transform(Int) {
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

	private inline function writeSelectedToClipboard(): Void {
		writeToClipboard(getSelectedText());
	}

	private function writeText(t: String): Void {
		if (t != null && t.length > 0) {
			beforeChange();
			if (selectionRange != null) cutSelection();
			var before: String = text;
			text = text.substr(0, cursorIndex) + t + text.substr(cursorIndex);
			cursorIndex += t.length;
			checkChangedText(before, true);
		}
	}

	private inline function doUndo(): Void {
		nextChar = null;
		if (undo.length > 0 && canEdit) {
			redo.push(curHistoryState());
			@:nullSafety(Off) setState(undo.pop());
			onChange();
		}
	}

	private inline function doRedo(): Void {
		nextChar = null;
		if (redo.length > 0 && canEdit) {
			undo.push(curHistoryState());
			@:nullSafety(Off) setState(redo.pop());
			onChange();
		}
	}

	override private function handleKey(e: Event): Void {
		if (!canEdit) {
			nextChar = null;
			super.handleKey(e);
		} else switch [e.keyCode, isMod()] {
			case [#if sys 0 #else null #end, _]: nextChar = String.fromCharCode(e.charCode);
			case [Key.UP, _]:
				var oldIndex: Int = cursorIndex;
				var index: Int = text.lastIndexOf('\n', cursorIndex - 1);
				cursorIndex = index != -1 ? MathTools.cmin(text.lastIndexOf('\n', index - 1) + (cursorIndex - index), index) : 0;
				updateSelection(oldIndex);
			case [Key.DOWN, _]:
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
			case [Key.Z, true]:
				if (Key.isDown(Key.SHIFT))
					doRedo();
				else
					doUndo();
			case [Key.Y, true]:
				doRedo();
			case [Key.A, true]:
				nextChar = null;
				if (text != '') {
					cursorIndex = text.length;
					selectionRange = {start: 0, length: text.length};
					selectionSize = 0;
				}
			case [Key.C, true]:
				nextChar = null;
				if (text != '' && selectionRange != null) writeSelectedToClipboard();
			case [Key.X, true]:
				nextChar = null;
				if (canEdit && text != '' && selectionRange != null) {
					writeSelectedToClipboard();
					beforeChange();
					cutSelection();
					onChange();
				}
			case [Key.V, true]:
				nextChar = null;
				if (canEdit) readFromClipboard(writeText);
			case [_, true]:
				nextChar = null;
			case _ if (Key.isDown(Key.CTRL)):
				nextChar = null;
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
				checkChangedText(textBeforeChange, changed);
		}
	}

	private function checkChangedText(textBeforeChange: String, changed: Bool): Void {
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

	override private function sync(ctx: RenderContext): Void {
		super.sync(ctx);
		if (maxLines > 0) interactive.height = font.lineHeight * maxLines;
	}

	override private function getCursorYOffset(): Float {
		var lines: Array<String> = getAllLines();
		var currIndex: UInt = 0;
		var lineNum: UInt = 0;
		for (i in 0...lines.length) {
			currIndex += lines[i].length;
			if (cursorIndex < currIndex) {
				lineNum = i;
				break;
			}
		}
		return lineNum * (font.lineHeight + lineSpacing);
	}

	@:access(h2d.Tile)
	override private function draw(ctx: RenderContext): Void {
		if (selectionRange != null) {
			var lines: Array<String> = getAllLines();
			var lineOffset: Int = 0;

			for (i in 0...lines.length) {
				var line: String = lines[i];
				var selEnd: UInt = line.length;
				if (selectionRange.start > lineOffset + line.length || selectionRange.start + selectionRange.length < lineOffset) {
					lineOffset += line.length;
					continue;
				}

				var selStart: Int = Math.floor(Math.max(0, selectionRange.start - lineOffset));
				var selEnd: Int = Math.floor(Math.min(
					line.length - selStart, selectionRange.length + selectionRange.start - lineOffset - selStart
				));

				selectionPos = calcTextWidth(line.substr(0, selStart));
				selectionSize = calcTextWidth(line.substr(selStart, selEnd));
				if (selectionRange.start + selectionRange.length == text.length) selectionSize += cursorTile.width; // last pixel

				selectionTile.dx += selectionPos;
				selectionTile.dy += i * (font.lineHeight + lineSpacing);
				selectionTile.width += selectionSize;
				emitTile(ctx, selectionTile);
				selectionTile.dx -= selectionPos;
				selectionTile.dy -= i * (font.lineHeight + lineSpacing);
				selectionTile.width -= selectionSize;
				lineOffset += line.length;
			}
		}
		var range: {start:Int, length:Int} = selectionRange;
		@:nullSafety(Off) selectionRange = null;
		super.draw(ctx);
		selectionRange = range;
	}

	public function clear(): Void {
		undo.resize(0);
		redo.resize(0);
		text = '';
	}

	public function wait(cb: Void -> Void): Void cb();
	private function get_size(): Point<Float> return new Point<Float>(textWidth * scaleX, textHeight * scaleY);

	public function destroyIWH(): Void {
		enabled = false;
		clear();
		remove();
	}

	private static inline function readFromClipboard(cb: String -> Void): Void {
		#if js
		try js.Browser.navigator.clipboard.readText().then(cb) catch (_: Dynamic) {}
		#else
		cb(System.getClipboardText());
		#end
	}

	private static inline function writeToClipboard(s: String): Void {
		#if js
		try js.Browser.navigator.clipboard.writeText(s) catch (_: Dynamic) {}
		#else
		System.setClipboardText(s);
		#end
	}

	private static inline function isMacMod(): Bool return Key.isDown(Key.LEFT_WINDOW_KEY) || Key.isDown(Key.RIGHT_WINDOW_KEY);
	private static inline function isOtherMod(): Bool return Key.isDown(Key.CTRL);

	#if js
	private static inline function isMod(): Bool return pony.JsTools.os == Macos ? isMacMod() : isOtherMod();
	#elseif mac
	private static inline function isMod(): Bool return isMacMod();
	#else
	private static inline function isMod(): Bool return isOtherMod();
	#end

}