package pony.pixi.ui;

import pixi.core.math.shapes.Rectangle;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pony.ui.gui.RubberLayoutCore;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.Touchable;
import pony.geom.Border;
import pony.geom.Point;
import pony.color.UColor;

/**
 * RectButton
 * @author AxGord <axgord@gmail.com>
 */
class RectButton extends BaseLayout<RubberLayoutCore<Container>> {

	public var core(default, null):ButtonImgN;
	public var touchActive(get, set):Bool;
	public var cursor(get, set):Bool;

	private var g:Graphics = new Graphics();
	private var colors:Array<UColor>;

	public function new(size:Point<Int>, colors:Array<UColor>, vert:Bool = false, ?border:Border<Int>, ?offset:Point<Float>) {
		this.colors = colors;
		layout = new RubberLayoutCore<Container>(vert, border);
		layout.width = size.x;
		layout.height = size.y;
		super();
		core = new ButtonImgN(new Touchable(g));
		core.onImg << imgHandler;
		core.onDisable << disableHandler;
		core.onEnable << enableHandler;
		addChild(g);
		imgHandler(1);
		cursor = true;
	}

	private function imgHandler(n:Int):Void {
		if (n == 4) {
			visible = false;
			return;
		} else {
			visible = true;
			g.clear();
			if (n > colors.length) n = colors.length;
			g.beginFill(colors[n - 1].rgb, colors[n - 1].invertAlpha.af);
			g.drawRect(0, 0, layout.size.x, layout.size.y);
		}
	}
	
	override public function add(obj:Container):Void {
		obj.interactive = false;
		obj.interactiveChildren = false;
		obj.hitArea = new Rectangle(0, 0, 0, 0);
		super.add(obj);
	}
	
	private function disableHandler():Void cursor = false;
	private function enableHandler():Void cursor = true;
	inline private function get_cursor():Bool return g.buttonMode;
	inline private function set_cursor(v:Bool):Bool return g.buttonMode = v;
	inline private function get_touchActive():Bool return g.interactive;
	inline private function set_touchActive(v:Bool):Bool return g.interactive = v;

	override function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		core.destroy();
		core = null;
		removeChild(g);
		g.destroy();
		g = null;
		layout.destroy();
		layout = null;
		super.destroy(options);
	}

}