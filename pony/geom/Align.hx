package pony.geom;

/**
 * Align
 * @author AxGord <axgord@gmail.com>
 */
abstract Align(AlignType) from AlignType to AlignType {
	
	public var vertical(get, never):VAlign;
	public var horizontal(get, never):HAlign;
	
	@:extern inline public function new(v:AlignType) this = v;
	
	@:from @:extern inline public static function fromV(v:VAlign):Align {
		return new Pair(v, HAlign.Center);
	}
	
	@:from @:extern inline public static function fromH(v:HAlign):Align {
		return new Pair(VAlign.Middle, v);
	}
	
	@:to @:extern inline private function toV():VAlign return this.a;
	@:to @:extern inline private function toH():HAlign return this.b;
	
	@:extern inline private function get_vertical():VAlign return this.a;
	@:extern inline private function get_horizontal():HAlign return this.b;

	inline public static function fromString(s:String):Align {
		if (s == null) return null;
		var hor:HAlign = null;
		var vert:VAlign = null;
		for (v in s.split(' ')) if (v != '') {
			switch v.toLowerCase() {
				case 'left':
					hor = HAlign.Left;
				case 'center':
					hor = HAlign.Center;
				case 'right':
					hor = HAlign.Right;
				case 'top':
					vert = VAlign.Top;
				case 'middle':
					vert = VAlign.Middle;
				case 'bottom':
					vert = VAlign.Bottom;
				case _:
					throw 'error';
			}
		}
		return new Pair(vert, hor);
	}

	@:to @:extern public inline function toInt():Int return vertical.getIndex() + (1 + horizontal.getIndex()) * 3;
	
	@:from @:extern public static inline function fromInt(v:Int):Align {
		return new Pair(VAlign.createByIndex(v % 3), HAlign.createByIndex(Std.int(v / 3) - 1));
	}
	
}
 
typedef AlignType = Pair<VAlign, HAlign>;

enum VAlign {
	Top; Middle; Bottom;
}

enum HAlign {
	Left; Center; Right;
}