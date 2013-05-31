package pony.ui;
import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class SwitchableList {

	private var list:Array<ButtonCore>;
	public var state:Int;
	public var select:Signal;
	
	public function new(a:Array<ButtonCore>, def:Int = 0) {
		state = def;
		select = new Signal();
		list = a;
		for (i in 0...a.length) {
			if (i == def) a[i].mode = 2;
			select.listen(a[i].click.sub([0], [i]));
		}
		select.add(setState, -1);
	}
	
	public function setState(n:Int):Void {
		list[state].mode = 0;
		list[n].mode = 2;
		state = n;
	}
	
}