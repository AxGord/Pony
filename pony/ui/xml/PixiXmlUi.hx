/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.xml;

import pixi.core.display.DisplayObject;
import pixi.core.graphics.Graphics;
import pixi.core.renderers.webgl.filters.AbstractFilter;
import pixi.core.sprites.Sprite;
import pixi.extras.MovieClip;
import pixi.filters.dropshadow.DropShadowFilter;
import pony.color.UColor;
import pony.geom.Align;
import pony.geom.Border;
import pony.geom.Point;
import pony.magic.HasAbstract;
import pony.pixi.ETextStyle;
import pony.pixi.ui.AlignLayout;
import pony.pixi.ui.BText;
import pony.pixi.ui.Button;
import pony.pixi.ui.IntervalLayout;
import pony.pixi.ui.LabelButton;
import pony.pixi.ui.ProgressBar;
import pony.pixi.ui.RubberLayout;
import pony.pixi.ui.SizedSprite;
import pony.pixi.ui.TextBox;
import pony.pixi.ui.TextButton;
import pony.pixi.ui.TimeBar;
import pony.time.Time;

/**
 * PixiXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build({
	free: pixi.core.sprites.Sprite,
	layout: pony.pixi.ui.TLayout,
	image: pixi.core.sprites.Sprite,
	text: pony.pixi.ui.BText,
	progressbar: pony.pixi.ui.ProgressBar,
	timebar: pony.pixi.ui.TimeBar,
	button: pony.pixi.ui.Button,
	lbutton: pony.pixi.ui.LabelButton,
	textbox: pony.pixi.ui.TextBox,
	rect: pixi.core.graphics.Graphics,
	textbutton: pony.pixi.ui.TextButton,
	clip: pixi.extras.MovieClip
}))
#end
class PixiXmlUi extends Sprite implements HasAbstract {

	private var FILTERS:Map<String, AbstractFilter> = new Map();
	
	private function createUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic {
		var obj:DisplayObject = switch name {
			case 'free':
				var s = new SizedSprite(new Point(attrs.w != null ? Std.parseFloat(attrs.w) : 0, attrs.h != null ? Std.parseFloat(attrs.h) : 0));
				for (e in content) s.addChild(e);
				s;
			case 'rect':
				var color = UColor.fromString(attrs.color);
				var g = new Graphics();
				g.lineStyle();
				g.beginFill(color.rgb, color.invertAlpha.af);
				g.drawRect(0, 0, Std.parseFloat(attrs.w), Std.parseFloat(attrs.h));
				g.endFill();
				return g;
			case 'layout':
				var align = Align.fromString(attrs.align);
				if (attrs.iv != null) {
					var l = new IntervalLayout(Std.parseInt(attrs.iv), true, cast Border.fromString(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.ih != null) {
					var l = new IntervalLayout(Std.parseInt(attrs.ih), false, cast Border.fromString(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.w != null || attrs.h != null) {
					var r = new RubberLayout(
						Std.parseFloat(attrs.w),
						Std.parseFloat(attrs.h),
						isTrue(attrs.vert),
						cast Border.fromString(attrs.border),
						attrs.padding == null ? true : isTrue(attrs.padding),
						align
					);
					for (e in content) r.add(e);
					r;
				} else {
					var s = new AlignLayout(align);
					for (e in content) s.add(e);
					s;
				}
			case 'image':
				if (attrs.name != null)
					Sprite.fromFrame(attrs.name);
				else
					Sprite.fromImage(attrs.src);
			case 'clip':
				var data = if (attrs.name != null) {
					var a = attrs.name.split('|');
					var p = a[1].split('...');
					[for (n in new IntIterator(Std.parseInt(p[0]), Std.parseInt(p[1]))) a[0] + n + a[2]];
				} else {
					attrs.frames.split(',').map(StringTools.trim);
				}
				var m = MovieClip.fromFrames(data);
				if (attrs.speed != null) m.animationSpeed = Std.parseFloat(attrs.speed);
				m.play();
				m;
			case 'textbox':
				var font = attrs.size + 'px ' + attrs.font;
				var text = _putData(content);
				var style = ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb});
				var s = Sprite.fromImage(attrs.src);
				s.visible = !isTrue(attrs.hidebg);
				new TextBox(s, text, style, cast Border.fromString(attrs.border), isTrue(attrs.nocache));
			case 'text':
				var font = attrs.size + 'px ' + attrs.font;
				var text = _putData(content);
				var style = {font: font, tint: UColor.fromString(attrs.color).rgb};
				new BText(text, style, attrs.ansi);
			case 'lbutton':
				var b = new LabelButton(splitAttr(attrs.skin), isTrue(attrs.vert), cast Border.fromString(attrs.border), true);
				for (c in content) b.add(c);
				b;
			case 'button':
				new Button(splitAttr(attrs.skin), true);
			case 'textbutton':
				var font = attrs.size + 'px ' + attrs.font;
				var text = _putData(content);
				new TextButton(
					attrs.color.split(' ').map(function(v) return UColor.fromString(v)),
					text, font, attrs.ansi,
					attrs.line != null ? Std.parseFloat(attrs.line) : 0,
					attrs.linepos != null ? Std.parseFloat(attrs.linepos) : 0
				);
			case 'progressbar':
				var font = attrs.size + 'px ' + attrs.font;
				new ProgressBar(
					attrs.bg,
					attrs.begin,
					attrs.fill,
					attrs.anim,
					attrs.animspeed == null ? null : (attrs.animspeed:Time),
					cast Border.fromString(attrs.border),
					ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb}),
					isTrue(attrs.invert),
					attrs.src.indexOf(',') != -1,
					attrs.creep == null ? 0 : Std.parseInt(attrs.creep)
				);
			case 'timebar':
				var font = attrs.size + 'px ' + attrs.font;
				new TimeBar(
					attrs.bg,
					attrs.begin,
					attrs.fill,
					attrs.anim,
					attrs.animspeed == null ? null : (attrs.animspeed:Time),
					cast Border.fromString(attrs.border),
					ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb}),
					isTrue(attrs.invert),
					attrs.src.indexOf(',') != -1,
					attrs.creep == null ? 0 : Std.parseInt(attrs.creep)
				);
			case _:
				customUIElement(name, attrs, content);
		}
		if (isTrue(attrs.notouch)) {
			obj.interactive = false;
			obj.interactiveChildren = false;
		}
		if (attrs.r != null) {
			obj.rotation = Std.parseFloat(attrs.r) * Math.PI / 180;
		}
		if (attrs.alpha != null) {
			obj.alpha = Std.parseFloat(attrs.alpha);
		}
		if (attrs.scale != null) {
			var s = Std.parseFloat(attrs.scale);
			obj.scale = new pixi.core.math.Point(s, s);
		}
		if (attrs.filters != null) {
			obj.filters = [for (f in splitAttr(attrs.filters)) FILTERS[f]];
		}
		if (attrs.x != null) obj.x = Std.parseInt(attrs.x);
		if (attrs.y != null) obj.y = Std.parseInt(attrs.y);
		return obj;
	}
	
	private function _putData(content:Array<Dynamic>):String return putData(content.length > 0 ? content[0] : '');
	private function putData(c:String):String return c;
	private function customUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic throw 'Unknown component $name';
	
	static private function splitAttr(s:String):Array<String> {
		return s.split(',').map(StringTools.trim).map(function(v) return v == '' ? null : v);
	}
	
	inline static private function isTrue(s:String):Bool return s != null && s.toLowerCase() == 'true';
	
	@:abstract private function _createUI():DisplayObject;
	
	private function createUI():Void addChild(_createUI());
	
	private function createFilters(data:Dynamic<Dynamic<String>>):Void {
		for (name in Reflect.fields(data)) {
			var d = Reflect.field(data, name);
			var f:AbstractFilter = switch Reflect.field(d, 'extends') {
				case 'shadow':
					new DropShadowFilter();
				case _:
					throw 'Unknown filter';
			}
			for (n in Reflect.fields(d)) if (n != 'extends')
				Reflect.setProperty(f, n, Std.parseFloat(Reflect.field(d, n)));
			FILTERS[name] = f;
		}
	}
	
}