package pony.heaps.ui.gui;

import h2d.RenderContext;
import h2d.TextInput;

import hxd.Event;

import pony.geom.IWH;
import pony.geom.Point;
import pony.text.TextTools;

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

	public var onlyEn: Bool = false;
	public var transform: Transform = none;
	public var maxChars: UInt = 0;
	public var size(get, never): Point<Float>;

	var nextChar: Null<String> = null;
	var textBeforeChange: String = '';

	override private function handleKey(e: Event): Void {
		textBeforeChange = text;
		if (!canEdit) {
			nextChar = null;
			super.handleKey(e);
		} else if (!isNull(e.keyCode)) {
			if (onlyEn) {
				var ch: String = String.fromCharCode(e.keyCode);
				nextChar = @:nullSafety(Off) TextTools.letters['en'].indexOf(ch.toUpperCase()) == -1 ? null : ch;
			}
			super.handleKey(e);
		} else {
			var char: String = nextChar != null ? nextChar : String.fromCharCode(e.charCode);
			@:nullSafety(Off) var code: UInt = char.charCodeAt(0);
			if ((nextChar == null && e.charCode == code) || !font.hasChar(code)) {
				nextChar = null;
				super.handleKey(e);
				cancelIfBig();
				return;
			}
			nextChar = null;
			switch transform {
				case uppercase: char = char.toUpperCase();
				case lowercase: char = char.toLowerCase();
				case none:
			}
			beforeChange();
			if (selectionRange != null) cutSelection();
			text = text.substr(0, cursorIndex) + char + text.substr(cursorIndex);
			cursorIndex++;
			onChange();
		}
		cancelIfBig();
	}

	private inline function cancelIfBig(): Void {
		if (maxChars > 0 && text.length > maxChars) {
			text = textBeforeChange;
			onChange();
		}
	}

	public inline function setCursorParams(y: Float, h: Float): Void {
		cursorTile.dy = y;
		selectionTile.dy = y;
		selectionTile.setSize(0, textHeight + h);
		cursorTile.setSize(cursorTile.width, textHeight + h);
	}

	override private function draw(ctx: RenderContext): Void {
		selectionSize = 0;
		super.draw(ctx);
	}

	public inline function blur(): Void interactive.blur();
	public function wait(cb: Void -> Void): Void cb();
	private function get_size(): Point<Float> return new Point<Float>(textWidth * scaleX, textHeight * scaleY);
	public function destroyIWH(): Void {}
	private static inline function isNull(v: Int): Bool return v == #if sys 0 #else null #end;

}