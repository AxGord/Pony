/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pixi.core.math.shapes.Rectangle;
import pixi.core.renderers.webgl.filters.Filter;
import pixi.core.sprites.Sprite;
import pixi.extras.AnimatedSprite;
import pixi.extras.TilingSprite;
import pixi.filters.extras.GlowFilter;
import pony.color.UColor;
import pony.geom.Align;
import pony.geom.Border;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasAbstract;
import pony.pixi.App;
import pony.pixi.ETextStyle;
import pony.pixi.FastMovieClip;
import pony.pixi.PixiAssets;
import pony.pixi.ui.AlignLayout;
import pony.pixi.ui.AutoButton;
import pony.pixi.ui.BGLayout;
import pony.pixi.ui.BText;
import pony.pixi.ui.Bar;
import pony.pixi.ui.Button;
import pony.pixi.ui.FSButton;
import pony.pixi.ui.IntervalLayout;
import pony.pixi.ui.LabelButton;
import pony.pixi.ui.Mask;
import pony.pixi.ui.ProgressBar;
import pony.pixi.ui.RubberLayout;
import pony.pixi.ui.SizedSprite;
import pony.pixi.ui.StepSlider;
import pony.pixi.ui.TextBox;
import pony.pixi.ui.TextButton;
import pony.pixi.ui.TimeBar;
import pony.pixi.ui.ZeroPlace;
import pony.pixi.ui.slices.SliceTools;
import pony.time.DeltaTime;
import pony.time.Time;

using pony.text.TextTools;
using pony.pixi.PixiExtends;

/**
 * PixiXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if (!macro)
@:autoBuild(pony.ui.xml.XmlUiBuilder.build({
	free: pixi.core.sprites.Sprite,
	mask: pony.pixi.ui.Mask,
	layout: pony.pixi.ui.TLayout,
	zeroplace: pony.pixi.ui.ZeroPlace,
	image: pixi.core.sprites.Sprite,
	text: pony.pixi.ui.BText,
	bar: pony.pixi.ui.Bar,
	progressbar: pony.pixi.ui.ProgressBar,
	timebar: pony.pixi.ui.TimeBar,
	button: pony.pixi.ui.Button,
	autobutton: pony.pixi.ui.AutoButton,
	fsbutton: pony.pixi.ui.FSButton,
	lbutton: pony.pixi.ui.LabelButton,
	textbox: pony.pixi.ui.TextBox,
	rect: pixi.core.graphics.Graphics,
	circle: pixi.core.graphics.Graphics,
	textbutton: pony.pixi.ui.TextButton,
	clip: pixi.extras.AnimatedSprite,
	fastclip: pixi.core.sprites.Sprite,
	slider: pony.pixi.ui.StepSlider,
	slice: pony.pixi.ui.slices.SliceSprite,
}))
#end
class PixiXmlUi extends Sprite implements HasAbstract {

	private static inline var PX:String = 'px ';
	private static inline var GLOW_FILTER_OFFSET:Int = 2;
	
	private var FILTERS:Map<String, Filter> = new Map();
	private var SCALE:Float = 1;
	
	private function createUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic {
		var obj:DisplayObject = switch name {
			case 'free':
				var s = new SizedSprite(new Point(parseAndScale(attrs.w), parseAndScale(attrs.h)));
				for (e in content) s.addChild(e);
				s;
			case 'rect':
				var color = UColor.fromString(attrs.color);
				var g = new Graphics();
				g.lineStyle();
				g.beginFill(color.rgb, color.invertAlpha.af);
				if (attrs.round == null)
					g.drawRect(0, 0, parseAndScale(attrs.w), parseAndScale(attrs.h));
				else
					g.drawRoundedRect(0, 0, parseAndScale(attrs.w), parseAndScale(attrs.h), parseAndScaleInt(attrs.round));
				g.endFill();
				g;
			case 'circle':
				var color = UColor.fromString(attrs.color);
				var g = new Graphics();
				g.lineStyle();
				g.beginFill(color.rgb, color.invertAlpha.af);
				g.drawCircle(0, 0, parseAndScale(attrs.r));
				g.endFill();
				g;
			case 'layout':
				var align = Align.fromString(attrs.align);
				if (attrs.src != null) {
					var l = new BGLayout(PixiAssets.image(attrs.src, attrs.name), attrs.vert.isTrue(), scaleBorderInt(attrs.border));
					for (e in content) l.add(e);
					l;
				} else if (attrs.iv != null) {
					var l = new IntervalLayout(parseAndScaleInt(attrs.iv), true, scaleBorderInt(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.ih != null) {
					var l = new IntervalLayout(parseAndScaleInt(attrs.ih), false, scaleBorderInt(attrs.border), align);
					for (e in content) l.add(e);
					l;
				} else if (attrs.w != null || attrs.h != null) {
					var r = new RubberLayout(
						parseAndScale(attrs.w),
						parseAndScale(attrs.h),
						attrs.vert.isTrue(),
						scaleBorderInt(attrs.border),
						attrs.padding == null ? true : attrs.padding.isTrue(),
						align
					);
					for (e in content) r.add(e);
					r;
				} else {
					var s = new AlignLayout(align);
					for (e in content) s.add(e);
					s;
				}
			case 'zeroplace':
				var s = new ZeroPlace();
				for (e in content) s.add(e);
				s;
			case 'image':
				PixiAssets.image(attrs.src, attrs.name);
			case 'tile':
				new TilingSprite(PixiAssets.texture(attrs.src, attrs.name), parseAndScale(attrs.w), parseAndScale(attrs.h));
			case 'mask':
				var o = new Mask(parseAndScaleWithoutNull(attrs.w), parseAndScaleWithoutNull(attrs.h), parseAndScaleInt(attrs.radius), content.shift());
				for (e in content) o.addChild(e);
				o;
			case 'slice':
				var s = SliceTools.getSliceSprite(attrs.name, attrs.src, parseAndScale(attrs.creep));
				if (attrs.w != null) s.sliceWidth = parseAndScale(attrs.w);
				if (attrs.h != null) s.sliceHeight = parseAndScale(attrs.h);
				s;
			case 'clip':
				var data = if (attrs.name != null) {
					var a = attrs.name.split('|');
					var p = a[1].split('...');
					[for (n in new IntIterator(Std.parseInt(p[0]), Std.parseInt(p[1]))) a[0] + n + a[2]];
				} else {
					attrs.frames.split(',').map(StringTools.trim);
				}
				var m = AnimatedSprite.fromFrames(data);
				if (attrs.speed != null) m.animationSpeed = Std.parseFloat(attrs.speed);
				m.loop = !attrs.loop.isFalse();
				if (attrs.play.isTrue()) m.play();
				m;
			case 'fastclip':
				var data = if (attrs.name != null) {
					var a = attrs.name.split('|');
					var p = a[1].split('...');
					[for (n in new IntIterator(Std.parseInt(p[0]), Std.parseInt(p[1]))) a[0] + n + a[2]];
				} else {
					attrs.frames.split(',').map(StringTools.trim);
				}
				
				var clip = FastMovieClip.fromStorage(data, Std.parseFloat(attrs.frameTime), attrs.fixedTime.isTrue());
				clip.loop = !attrs.loop.isFalse();
				if (attrs.play.isTrue()) clip.play();
				
				clip.get();
			case 'textbox':
				var font = parseAndScaleInt(attrs.size) + 'px ' + attrs.font;
				var text = textTransform(_putData(content), attrs.transform);
				var style = ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb});
				var s = PixiAssets.image(attrs.src, attrs.name);
				s.visible = !attrs.hidebg.isTrue();
				new TextBox(s, text, style, scaleBorderInt(attrs.border), attrs.nocache.isTrue(), attrs.shadow.isTrue());
			case 'text':
				var font = parseAndScaleInt(attrs.size) + 'px ' + attrs.font;
				var text = textTransform(_putData(content), attrs.transform);
				var style = {font: font, tint: UColor.fromString(attrs.color).rgb};
				new BText(text, style, attrs.ansi, attrs.shadow.isTrue());
			case 'lbutton':
				var b = new LabelButton(splitAttr(attrs.skin), attrs.vert.isTrue(), scaleBorderInt(attrs.border), attrs.src);
				for (c in content) b.add(c);
				b;
			case 'button':
				new Button(splitAttr(attrs.skin), attrs.src);
			case 'autobutton':
				new AutoButton(PixiAssets.image(attrs.src, attrs.name));
			case 'fsbutton':
				new FSButton(splitAttr(attrs.skin), attrs.src);
			case 'slider':
				var b = new StepSlider(
					new LabelButton(splitAttr(attrs.skin), attrs.vert.isTrue(), scaleBorderInt(attrs.border), attrs.src),
					parseAndScale(attrs.w),
					parseAndScale(attrs.h),
					attrs.invert.isTrue(),
					!attrs.draggable.isFalse()
				);
				if (attrs.step != null) b.sliderCore.percentStep = Std.parseFloat(attrs.step);
				for (c in content) b.add(c);
				b;
			case 'textbutton':
				var font = parseAndScaleInt(attrs.size) + PX + attrs.font;
				var text = textTransform(_putData(content), attrs.transform);
				new TextButton(
					attrs.color.split(' ').map(UColor.fromString),
					text, font, attrs.ansi,
					parseAndScale(attrs.line),
					parseAndScale(attrs.linepos)
				);
			case 'bar':
				var b = scaleBorderInt(attrs.border);
				new Bar(
					new Point(parseAndScaleInt(attrs.w), parseAndScaleInt(attrs.h)),
					attrs.begin,
					attrs.fill,
					new Point(b.left, b.top),
					attrs.invert.isTrue(),
					attrs.src != null,
					parseAndScaleInt(attrs.creep),
					attrs.smooth.isTrue()
				);
			case 'progressbar':
				var font = attrs.font == null ? null : parseAndScaleInt(attrs.size) + PX + attrs.font;
				new ProgressBar(
					attrs.bg,
					attrs.begin,
					attrs.fill,
					attrs.anim,
					attrs.animspeed == null ? null : (attrs.animspeed:Time),
					scaleBorderInt(attrs.border),
					font == null ? null : ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb}),
					attrs.shadow.isTrue(),
					attrs.invert.isTrue(),
					font == null || attrs.src.indexOf(',') != -1,
					parseAndScaleInt(attrs.creep),
					attrs.smooth.isTrue()
				);
			case 'timebar':
				var font = parseAndScaleInt(attrs.size) + PX + attrs.font;
				new TimeBar(
					attrs.bg,
					attrs.begin,
					attrs.fill,
					attrs.anim,
					attrs.animspeed == null ? null : (attrs.animspeed:Time),
					scaleBorderInt(attrs.border),
					ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb}),
					attrs.shadow.isTrue(),
					attrs.invert.isTrue(),
					attrs.src.indexOf(',') != -1,
					parseAndScaleInt(attrs.creep)
				);
			case _:
				customUIElement(name, attrs, content);
		}
		
		if (attrs.pivot != null) {
			var a = attrs.pivot.split(' ');
			var w = cast(obj, Sprite).width;
			var h = cast(obj, Sprite).height;
			if (a.length == 1)
				obj.pivot.set(Std.parseFloat(a[0]) * w, Std.parseFloat(a[0]) * h);
			else
				obj.pivot.set(Std.parseFloat(a[0]) * w, Std.parseFloat(a[1]) * h);
		}
		
		if (attrs.notouch.isTrue()) {
			obj.interactive = false;
			obj.interactiveChildren = false;
			obj.hitArea = new Rectangle(0, 0, 0, 0);
		}
		if (attrs.r != null) {
			obj.rotation = Std.parseFloat(attrs.r) * Math.PI / 180;
		}
		if (attrs.alpha != null) {
			obj.alpha = Std.parseFloat(attrs.alpha);
		}
		if (attrs.scale != null) {
			obj.scale.set(Std.parseFloat(attrs.scale));
		}
		
		if (attrs.filters != null) {
			var a = [];
			for (f in splitAttr(attrs.filters)) if (FILTERS.exists(f)) {
				a.push(FILTERS[f]);
				if (Std.is(FILTERS[f], GlowFilter)) {
					var obj:Sprite = cast obj;
					var g:GlowFilter = cast FILTERS[f];
					var s = g.outerStrength + GLOW_FILTER_OFFSET;
						var f:Void -> Void = null;
						if (Std.is(obj, IWH)) {
							f = function() {
								obj.setFilterArea(s);
								var size = cast(obj, IWH).size;
								obj.filterArea.width = size.x + s * 2;
								obj.filterArea.height = size.y + s * 2;
							}
						} else {
							f = function() {
								obj.setFilterArea(s);
							}
							
						}
						
					if (attrs.dyn.isTrue()) {
						DeltaTime.fixedUpdate << f;
					} else {
						DeltaTime.skipUpdate(f);
						App.main.onResize << f;
					}
				}
			}
			if (a.length > 0) obj.filters = a;
		}
		
		
		if (attrs.x != null) obj.x = parseAndScale(attrs.x);
		if (attrs.y != null) obj.y = parseAndScale(attrs.y);
		
		if (attrs.flipx.isTrue()) {
			PixiExtends.flipX(cast obj);
			PixiExtends.flipXpos(cast obj);
		}
		
		if (attrs.flipy.isTrue()) {
			PixiExtends.flipY(cast obj);
			PixiExtends.flipYpos(cast obj);
		}
		
		if (attrs.visible.isFalse()) {
			obj.visible = false;
		}
		
		return obj;
	}
	
	private static function textTransform(text:String, transform:String):String {
		return switch transform {
			case 'uppercase': text.toUpperCase();
			case 'lowercase': text.toLowerCase();
			case _: text;
		}
	}
	
	@:extern private inline function parseAndScaleWithoutNull(s:String):Float {
		return Std.parseFloat(s) * SCALE;
	}
	
	@:extern private inline function parseAndScale(s:String):Float {
		return s == null ? 0 : parseAndScaleWithoutNull(s);
	}
	
	@:extern inline function parseAndScaleInt(s:String):Int {
		return s == null ? 0 : Std.int(Std.parseInt(s) * SCALE);
	}
	
	@:extern private inline function scaleBorderInt(s:String):Border<Int> return cast (Border.fromString(s) * SCALE);
	
	private function _putData(content:Array<Dynamic>):String return putData(content.length > 0 ? content[0] : '');
	private function putData(c:String):String return c;
	private function customUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic throw 'Unknown component $name';
	
	private static function splitAttr(s:String):Array<String> {
		return s.split(',').map(StringTools.trim).map(function(v):String return v == '' ? null : v);
	}
	
	@:abstract private function _createUI():DisplayObject;
	
	private function createUI(scale:Float = 1):Void {
		SCALE = scale;
		addChild(_createUI());
	}
	
	private function createFilters(data:Dynamic<Dynamic<String>>):Void {
		
		for (name in Reflect.fields(data)) {
			var d:Dynamic<String> = Reflect.field(data, name);
			if (d.nomobile.isTrue() && JsTools.isMobile) continue;
			
			var f:Filter = switch Reflect.field(d, 'extends') {
				//case 'shadow':
					//new DropShadowFilter();
				case 'glow':
					new GlowFilter(
							Std.parseInt(d.distance),
							Std.parseFloat(d.outerStrength),
							Std.parseFloat(d.innerStrength),
							(d.color:UColor),
							Std.parseFloat(d.quality)
						);
				case _:
					throw 'Unknown filter';
			}
			
			//for (n in Reflect.fields(d)) if (n != 'extends')
			//	Reflect.setProperty(f, n, Std.parseFloat(Reflect.field(d, n)));
			FILTERS[name] = f;
		}
		
	}
	
}