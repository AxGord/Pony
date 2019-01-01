package pony.pixi.ui;

import pixi.core.display.DisplayObject.DestroyOptions;
import pony.geom.Border;
import pony.geom.Point;
import pony.pixi.ui.TextSizedBox;

/**
 * LabelBar
 * @author AxGord <axgord@gmail.com>
 */
class LabelBar extends AnimBar {

	public var text(get, set):String;
	
	private var label:TextSizedBox;
	private var style:ETextStyle;
	private var shadow:Bool;
	private var labelInitVisible:Bool = true;
	private var border:Border<Int>;
	
	public function new(
		bg:String,
		fillBegin:String,
		fill:String,
		?animation:String,
		animationSpeed:Int = 2000,
		?border:Border<Int>,
		?style:ETextStyle,
		shadow:Bool = false,
		invert:Bool = false,
		useSpriteSheet:Bool = false,
		creep:Float = 0,
		smooth:Bool = false
	) {
		this.style = style;
		this.shadow = shadow;
		this.border = border;
		super(bg, fillBegin, fill, animation, animationSpeed, border == null ? null : new Point(border.left, border.top), invert, useSpriteSheet, creep, smooth);
		if (style != null) onReady < labelInit;
	}
	
	private function labelInit(p:Point<Int>):Void {
		label = new TextSizedBox(p.x, p.y, '', style, border, true, shadow);
		label.visible = labelInitVisible;
		addChild(label);
		style = null;
	}
	
	@:extern inline function get_text():String return label == null ? null : label.text;
	@:extern inline function set_text(s:String):String return label == null ? null : label.text = s;

	override public function startAnimation():Void {
		if (label == null)
			labelInitVisible = false;
		else
			label.visible = false;
		super.startAnimation();
	}
	
	override public function stopAnimation():Void {
		if (label == null)
			labelInitVisible = true;
		else
			label.visible = true;
		super.stopAnimation();
	}
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		border = null;
		style = null;
		if (label != null) {
			label.destroy();
			label = null;
		}
		super.destroy(options);
	}
	
	override public function destroyIWH():Void destroy();
	
}