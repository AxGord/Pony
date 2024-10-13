package pony.pixi.ui;

import haxe.extern.EitherType;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.math.shapes.Rectangle;
import pony.ds.ROArray;
import pony.geom.Border;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.RubberLayoutCore;

using pony.pixi.PixiExtends;

/**
 * LabelButton
 * @author AxGord <axgord@gmail.com>
 */
class LabelButton extends BaseLayout<RubberLayoutCore<Container>> {

	public var core(get, never): ButtonCore;
	public var button(default, null): Button;

	private var dac: Float;

	public function new(
		imgs: ROArray<String>,
		vert: Bool = false,
		?border: Border<Int>,
		padding: Bool = true,
		?offset: Point<Float>,
		?useSpriteSheet: String,
		?dac: Float
	) {
		layout = new RubberLayoutCore<Container>(vert, border, padding);
		layout.tasks.add();
		super();
		button = new Button(imgs, offset, useSpriteSheet);
		addChild(button);
		button.wait(function() {
			layout.width = button.size.x;
			layout.height = button.size.y;
			layout.tasks.end();
		});
		if (dac != null) {
			this.dac = dac;
			core.onDisable << disableHandler;
			core.onEnable << enableHandler;
		}
	}

	private function disableHandler(): Void for (o in layout.objects) o.alpha = dac;

	private function enableHandler(): Void for (o in layout.objects) o.alpha = 1;

	override public function add(obj: Container): Void {
		obj.interactive = false;
		obj.interactiveChildren = false;
		obj.hitArea = new Rectangle(0, 0, 0, 0);
		super.add(obj);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_core(): ButtonCore return button.core;

	override function destroy(?options: EitherType<Bool, DestroyOptions>): Void {
		removeChild(button);
		button.destroy();
		button = null;
		super.destroy(options);
	}

}