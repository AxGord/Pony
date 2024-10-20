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
import pony.pixi.ui.ScrollBox;
import pony.pixi.ui.Button;
import pony.pixi.ui.RectButton;
import pony.pixi.ui.FSButton;
import pony.pixi.ui.IntervalLayout;
import pony.pixi.ui.LabelButton;
import pony.pixi.ui.Mask;
import pony.pixi.ui.DrawShapeView;
#if pixi_particles
import pony.pixi.ui.Particles;
#end
import pony.pixi.ui.ProgressBar;
import pony.pixi.ui.RubberLayout;
import pony.pixi.ui.SizedSprite;
import pony.pixi.ui.StepSlider;
import pony.pixi.ui.TextBox;
import pony.pixi.ui.TextButton;
import pony.pixi.ui.TimeBar;
import pony.pixi.ui.ZeroPlace;
import pony.pixi.ui.HtmlVideoUI;
import pony.pixi.ui.HtmlVideoUIFS;
import pony.pixi.ui.HtmlContainer;
import pony.pixi.ui.SubApp;
import pony.geom.Rect;
import pony.pixi.ui.RenderBox;
import pony.pixi.ui.LogableSprite;
import pony.pixi.ui.Gradient;
import pony.pixi.ui.SpinLoader;
import pony.pixi.ui.slices.SliceTools;
import pony.time.DeltaTime;
import pony.time.Time;

using pony.text.TextTools;
using pony.pixi.PixiExtends;

/**
 * PixiXmlUi
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.ui.xml.XmlUiBuilder.build(pony.ui.AssetManager, {
	free: pixi.core.sprites.Sprite,
	mask: pony.pixi.ui.Mask,
	vgrad: pony.pixi.ui.Gradient,
	hgrad: pony.pixi.ui.Gradient,
	spinloader: pony.pixi.ui.SpinLoader,
	layout: pony.pixi.ui.TLayout,
	zeroplace: pony.pixi.ui.ZeroPlace,
	image: pixi.core.sprites.Sprite,
	tile: pixi.extras.TilingSprite,
	text: pony.pixi.ui.BText,
	bar: pony.pixi.ui.Bar,
	vscroll: pony.pixi.ui.ScrollBox,
	progressbar: pony.pixi.ui.ProgressBar,
	timebar: pony.pixi.ui.TimeBar,
	button: pony.pixi.ui.Button,
	rectbutton: pony.pixi.ui.RectButton,
	autobutton: pony.pixi.ui.AutoButton,
	fsbutton: pony.pixi.ui.FSButton,
	lbutton: pony.pixi.ui.LabelButton,
	textbox: pony.pixi.ui.TextBox,
	rect: pixi.core.graphics.Graphics,
	line: pixi.core.graphics.Graphics,
	circle: pixi.core.graphics.Graphics,
	textbutton: pony.pixi.ui.TextButton,
	clip: pixi.extras.AnimatedSprite,
	fastclip: pixi.core.sprites.Sprite,
	slider: pony.pixi.ui.StepSlider,
	slice: pony.pixi.ui.slices.SliceSprite,
	video: pony.pixi.ui.HtmlVideoUI,
	fsvideo: pony.pixi.ui.HtmlVideoUIFS,
	html: pony.pixi.ui.HtmlContainer,
	subapp: pony.pixi.ui.SubApp,
	render: pony.pixi.ui.RenderBox,
	drawshape: pony.pixi.ui.DrawShapeView,
	#if pixi_particles
	particles: pony.pixi.ui.Particles
	#end
}))
#end
#if (haxe_ver >= 4.2) abstract #end
class PixiXmlUi extends LogableSprite implements HasAbstract {

	private static inline var PX: String = 'px ';
	private static inline var GLOW_FILTER_OFFSET: Int = 2;

	private var FILTERS: Map<String, Filter> = new Map();
	private var SCALE: Float = 1;
	public var app(default, null): App;
	private var tweens: TweenMap<Dynamic> = [];

	private function createUIElement(name: String, attrs: Dynamic<String>, content: Array<Dynamic>, textContent: String):Dynamic {
		if (attrs.reverse.isTrue()) content.reverse();
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
			case 'line':
				var color = UColor.fromString(attrs.color);
				var g = new Graphics(true);
				g.lineStyle(parseAndScale(attrs.size), color.rgb, color.invertAlpha.af);
				g.moveTo(0, 0);
				g.lineTo(parseAndScale(attrs.w), parseAndScale(attrs.h));
				g;
			case 'circle':
				var g = new Graphics();
				if (attrs.line != null) {
					var a = attrs.line.split(' ');
					if (a[0].charAt(0) == '#') a.unshift(a.pop());
					var lsize:Float = parseAndScale(a[0]);
					var lcolor = UColor.fromString(a[1]);
					g.lineStyle(lsize, lcolor.rgb, lcolor.invertAlpha.af);
				} else {
					g.lineStyle();
				}
				if (attrs.color != null) {
					var color = UColor.fromString(attrs.color);
					g.beginFill(color.rgb, color.invertAlpha.af);
				}
				g.drawCircle(0, 0, parseAndScale(attrs.r));
				g.endFill();
				g;
			case 'hgrad':
				new Gradient(parseSizePointFloat(attrs), attrs.colors, false, app);
			case 'vgrad':
				new Gradient(parseSizePointFloat(attrs), attrs.colors, true, app);
			case 'spinloader':
				new SpinLoader(parseAndScaleInt(attrs.trackRadius), parseAndScaleInt(attrs.circleRadius), attrs.color, parseFloat(attrs.spin), app);
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
					var s = new AlignLayout(align, scaleBorderInt(attrs.border));
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
					[for (n in new IntIterator(Std.parseInt(p[0]), Std.parseInt(p[1]))) a[0] + Tools.FloatTools._toFixed(n, 0, p[0].length) + a[2]];
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
					[for (n in new IntIterator(Std.parseInt(p[0]), Std.parseInt(p[1]))) a[0] + Tools.FloatTools._toFixed(n, 0, p[0].length) + a[2]];
				} else {
					attrs.frames.split(',').map(StringTools.trim);
				}

				var clip = FastMovieClip.fromStorage(data, Std.parseFloat(attrs.frameTime), attrs.fixedTime.isTrue(), attrs.smoothAnim, attrs.src.charCount(','));
				clip.loop = !attrs.loop.isFalse();
				if (attrs.play.isTrue()) clip.play();

				clip.get();
			case 'textbox':
				var font = {
					name: attrs.font,
					size: parseAndScaleInt(attrs.size)
				};
				var text = textTransform(putData(textContent), attrs.transform);
				var style = ETextStyle.BITMAP_TEXT_STYLE({font: font, tint: UColor.fromString(attrs.color).rgb});
				var s = PixiAssets.image(attrs.src, attrs.name);
				s.visible = !attrs.hidebg.isTrue();
				new TextBox(s, text, style, scaleBorderInt(attrs.border), attrs.nocache.isTrue(), attrs.shadow.isTrue());
			case 'text':
				// var font = parseAndScaleInt(attrs.size) + 'px ' + attrs.font;
				var font = {
					name: attrs.font,
					size: parseAndScaleInt(attrs.size)
				};
				var text = textTransform(putData(textContent), attrs.transform);
				var style = {font: font, tint: UColor.fromString(attrs.color).rgb, align: cast attrs.align};
				new BText(text, style, attrs.ansi, attrs.shadow.isTrue(), app);
			case 'lbutton':
				var b = new LabelButton(
					splitAttr(attrs.skin),
					attrs.vert.isTrue(),
					scaleBorderInt(attrs.border),
					!attrs.padding.isFalse(),
					attrs.src, attrs.dac == null ? null : Std.parseFloat(attrs.dac)
				);
				for (c in content) b.add(c);
				if (attrs.w != null)
					b.button.setWidth(parseAndScaleInt(attrs.w));
				if (attrs.h != null)
					b.button.setHeight(parseAndScaleInt(attrs.h));
				b;
			case 'button':
				var b = new Button(splitAttr(attrs.skin), attrs.src);
				if (attrs.w != null)
					b.setWidth(parseAndScaleInt(attrs.w));
				if (attrs.h != null)
					b.setHeight(parseAndScaleInt(attrs.h));
				b;
			case 'rectbutton':
				var b = new RectButton(
					new Point(parseAndScaleInt(attrs.w), parseAndScaleInt(attrs.h)),
					attrs.color.split(' ').map(UColor.fromString),
					attrs.vert.isTrue(),
					scaleBorderInt(attrs.border)
				);
				for (c in content) b.add(c);
				b;
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
				var text = textTransform(putData(textContent), attrs.transform);
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
			case 'vscroll':
				var b = new ScrollBox(
					parseAndScale(attrs.w),
					parseAndScale(attrs.h),
					true,
					false,
					attrs.color != null ? UColor.fromString(attrs.color) : 0,
					attrs.bar != null ? parseAndScale(attrs.bar) : 8,
					attrs.wheel != null ? parseAndScale(attrs.wheel) : 1
				);
				for (c in content) b.add(c);
				b;
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
			case 'video':
				var video = new HtmlVideoUI({
					x: parseAndScale(attrs.x),
					y: parseAndScale(attrs.y),
					width: parseAndScale(attrs.w),
					height: parseAndScale(attrs.h)
				}, attrs.css, app, attrs.ceil.isTrue(), attrs.fixed.isTrue());
				var src = attrs.src;
				if (src != null)
					video.video.loadVideo(src);
				video;

			case 'fsvideo':
				var fspos:Point<Float> = null;
				if (attrs.fspos != null) {
					var a = attrs.fspos.split(' ').map(Std.parseFloat);
					if (a.length == 1) {
						fspos = new Point<Float>(a[0], a[0]);
					} else {
						fspos = new Point<Float>(a[0], a[1]);
					}
				}
				var video = new HtmlVideoUIFS(
					{
						x: parseAndScale(attrs.x),
						y: parseAndScale(attrs.y),
						width: parseAndScale(attrs.w),
						height: parseAndScale(attrs.h)
					},
					attrs.fsborder != null ? (attrs.fsborder:Border<Float>) : null,
					fspos,
					attrs.css,
					attrs.fscss,
					attrs.transition,
					app,
					attrs.clicktimeout,
					attrs.ceil.isTrue(),
					attrs.fixed.isTrue()
				);
				var src = attrs.src;
				if (src != null)
					video.video.loadVideo(src);
				video;

			case 'html':
				var c = new HtmlContainer({
					x: parseAndScale(attrs.x),
					y: parseAndScale(attrs.y),
					width: parseAndScale(attrs.w),
					height: parseAndScale(attrs.h)
				}, app, attrs.ceil.isTrue(), attrs.fixed.isTrue());
				if (attrs.div.isTrue()) {
					var div = js.Browser.document.createDivElement();
					if (attrs.src != null) {
						div.innerHTML = pony.pixi.PixiAssets.text(attrs.src);
					}
					if (attrs.color != null)
						div.style.backgroundColor = attrs.color;
					app.element.appendChild(div);
					c.targetStyle = div.style;
					c.element = div;
				}
				c;

			case 'subapp':
				var c = new SubApp({
					x: parseAndScaleInt(attrs.x),
					y: parseAndScaleInt(attrs.y),
					width: parseAndScaleInt(attrs.w),
					height: parseAndScaleInt(attrs.h)
				}, app, !attrs.ceil.isFalse(), attrs.fixed.isTrue());
				if (!attrs.div.isFalse()) {
					var div = js.Browser.document.createDivElement();
					if (attrs.color != null)
						div.style.backgroundColor = attrs.color;
					app.element.appendChild(div);
					c.targetStyle = div.style;
					c.element = div;
				}
				c.init();
				c;

			case 'render':
				var r = new RenderBox(parseAndScale(attrs.w), parseAndScale(attrs.h), attrs.canvas.isTrue());
				for (c in content) r.addElement(c);
				r.update();
				r;

			case 'drawshape':
				var ds = new DrawShapeView(new Point<Int>(parseAndScaleInt(attrs.w), parseAndScaleInt(attrs.h)));
				if (attrs.enabled.isTrue()) ds.enable();
				ds.onLog << log;
				ds.onError << error;
				ds;
			#if pixi_particles
			case 'particles':
				var src = attrs.src.split(',').map(StringTools.trim);
				if (attrs.img != null) {
					new Particles(src[0], attrs.img.split(',').map(StringTools.trim), src[1]);
				} else {
					var cfg = src.shift();
					new Particles(cfg, src);
				}
			#end

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
			var a = attrs.scale.split(' ');
			if (a.length == 1)
				obj.scale.set(Std.parseFloat(a[0]));
			else
				obj.scale.set(Std.parseFloat(a[0]), Std.parseFloat(a[1]));
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
								if (obj.parent == null) {
									DeltaTime.fixedUpdate >> f;
									app.onResize >> f;
								} else {
									obj.setFilterArea(s);
									var size = cast(obj, IWH).size;
									obj.filterArea.width = size.x + s * 2;
									obj.filterArea.height = size.y + s * 2;
								}
							}
						} else {
							f = function() {
								if (obj.parent == null) {
									DeltaTime.fixedUpdate >> f;
									app.onResize >> f;
								} else {
									obj.setFilterArea(s);
								}
							}

						}

					if (attrs.dyn.isTrue()) {
						DeltaTime.fixedUpdate << f;
					} else {
						DeltaTime.skipUpdate(f);
						app.onResize << f;
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

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseSizePointFloat(a:Dynamic<String>):Point<Float> {
		return new Point<Float>(parseAndScale(a.w), parseAndScale(a.h));
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseFloat(s:String):Float {
		return s == null ? 0 : Std.parseFloat(s);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScaleWithoutNull(s:String):Float {
		return Std.parseFloat(s) * SCALE;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScale(s:String):Float {
		return s == null ? 0 : parseAndScaleWithoutNull(s);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function parseAndScaleInt(s:String):Int {
		return s == null ? 0 : Std.int(Std.parseInt(s) * SCALE);
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function scaleBorderInt(s:String):Border<Int> return cast (Border.fromString(s) * SCALE);

	private function putData(c:String):String return c;
	private function customUIElement(name:String, attrs:Dynamic<String>, content:Array<Dynamic>):Dynamic throw 'Unknown component $name';

	private static function splitAttr(s:String):Array<String> {
		return s.split(',').map(StringTools.trim).map(function(v):String return v == '' ? null : v);
	}

	@:abstract private function _createUI():DisplayObject;

	private function createUI(?app:App, scale:Float = 1):Void {
		if (this.app == null)
			this.app = app == null ? App.main : app;
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