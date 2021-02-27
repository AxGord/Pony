package pony.heaps.ui.gui;

import pony.ui.xml.HeapsXmlUi;
import pony.ui.xml.RepeatObject;
import pony.heaps.ui.gui.layout.AlignLayout;
import pony.heaps.ui.gui.layout.BGLayout;
import pony.heaps.ui.gui.layout.IntervalLayout;
import pony.heaps.ui.gui.layout.RubberLayout;
import h2d.Object;

/**
 * Repeat
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Repeat extends Object {

	public var count(get, set): UInt;
	public var created(default, null): Array<Object> = [];

	private var ui: HeapsXmlUi;
	private var ro: RepeatObject;
	private var targetCount: UInt = 0;

	public function new(ui: HeapsXmlUi, ro: RepeatObject, count: UInt = 0) {
		super();
		this.ui = ui;
		this.ro = ro;
		@:nullSafety(Off) this.count = count;
	}

	private function create(o: RepeatObject): Object {
		return @:privateAccess ui.createUIElement(o.name, o.attrs, [ for (c in o.content)
			#if (haxe_ver >= 4.00)
			Std.isOfType(c, String)
			#else
			Std.is(c, String)
			#end
		? c : create(cast c) ]);
	}

	private inline function get_count(): UInt return created.length;

	public inline function set_count(v: UInt): UInt {
		if (v != count) {
			targetCount = v;
			update();
		}
		return v;
	}

	override private function onAdd(): Void {
		super.onAdd();
		targetCount = count;
		update();
	}

	override private function onRemove(): Void {
		super.onRemove();
		while (count > 0) rm();
	}

	private function update(): Void {
		if (parent != null) {
			if (count < targetCount)
				while (count < targetCount) add();
			else
				while (count > targetCount) rm();
		}
	}

	public function add(): Object {
		final obj: Object = create(ro);
		switch Type.typeof(parent) {
			case TClass(AlignLayout):
				cast(parent, AlignLayout).add(obj);
			case TClass(BGLayout):
				cast(parent, BGLayout).add(obj);
			case TClass(IntervalLayout):
				cast(parent, IntervalLayout).add(obj);
			case TClass(RubberLayout):
				cast(parent, RubberLayout).add(obj);
			case TClass(Object):
				parent.addChild(obj);
			case _:
				throw 'Wrong parent';
		}
		created.push(obj);
		return obj;
	}

	public function rm(): Null<Object> {
		final obj: Null<Object> = created.pop();
		if (obj == null) return null;
		switch Type.typeof(parent) {
			case TClass(AlignLayout):
				cast(parent, AlignLayout).rm(obj);
			case TClass(BGLayout):
				cast(parent, BGLayout).rm(obj);
			case TClass(IntervalLayout):
				cast(parent, IntervalLayout).rm(obj);
			case TClass(RubberLayout):
				cast(parent, RubberLayout).rm(obj);
			case TClass(Object):
				parent.removeChild(obj);
			case _:
				throw 'Wrong parent';
		}
		return obj;
	}

}