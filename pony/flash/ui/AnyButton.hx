package pony.flash.ui;
import com.eclecticdesignstudio.control.KeyBinding;
import pony.events.Signal;
import flash.events.MouseEvent;

/**
 * ...
 * @author AxGord
 */

enum ButtonType { flcontrol; qlex; simple; }

class AnyButton {
	
	public var enabled(get, set):Bool;
	public var click:Signal;
	
	private var button:Dynamic;
	private var type:ButtonType;
	
	public var shift(get,set):Bool;
	//@bind public var shift:Bool = untyped button.shift;
	
	public function new(button:Dynamic) {
		this.button = button;
		if (Reflect.hasField(button, 'disabled'))
			type = ButtonType.qlex;
		else if (Reflect.hasField(button, 'label'))
			type = ButtonType.flcontrol;
		else
			type = ButtonType.simple;
			
		click = new Signal();
		
		switch (type) {
			case ButtonType.qlex: button.addEventListener('butclick', onClick);
		default: 
			button.addEventListener(MouseEvent.CLICK, onClick);
		}
	}
	
	private function onClick(?_):Void if (enabled) click.dispatch();
	
	private function get_enabled():Bool {
		return switch (type) {
			case ButtonType.flcontrol, ButtonType.simple: button.enabled;
			case ButtonType.qlex: !button.disabled;
		}
	}
	
	private function set_enabled(b:Bool):Bool {
		switch (type) {
			case ButtonType.qlex: button.disabled = !b;
			default: button.enabled = b;
		}
		return b;
	}
	
	public function bind(k:Dynamic):Void {
		
		if (type == ButtonType.qlex) button.bind(k);
		switch (type) {
			case qlex: button.bind(k);
			default: 
				button.tabEnabled = false;
				KeyBinding.addOnPress(k, onClick);
		}
	}
	
	private function get_shift():Bool return untyped button.shift;
	private function set_shift(state:Bool):Bool return untyped button.shift = state;
	
}