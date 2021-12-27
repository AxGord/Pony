import module.Build;
import module.Module;

import pony.Fast;
import pony.Logable;
import pony.text.XmlTools;

using Lambda;

/**
 * Modules
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Modules extends Logable {

	public var xml(get, never): Null<Fast>;
	public var commands(default, null): Commands;
	public var deny(default, set): Array<String> = [];
	public var allow(default, set): Array<String> = [];
	public var list: Array<Module> = [];
	public var build: Null<Build>;

	private var _xml: Null<Fast>;

	public function new(commands: Commands) {
		super();
		this.commands = commands;
		onError << commands.error;
		onLog << commands.log;
	}

	private function get_xml(): Null<Fast> {
		if (_xml == null) _xml = Utils.getXml();
		return _xml;
	}

	public function checkXml(): Void {
		if (xml == null) error(Utils.MAIN_FILE + ' not exists');
	}

	public function register<T: Module>(module: T): Void {
		module.modules = this;
		module.onError << error;
		module.onLog << log;
		list.push(module);
		switch Type.getClass(module) {
			case Build:
				build = cast module;
			case _:
		}
	}

	public function init(): Void {
		for (m in list) m.init();
	}

	@:extern public inline function getNode(name: String): Fast {
		return @:nullSafety(Off) XmlTools.getNode(xml, name);
	}

	public function set_deny(list: Array<String>): Array<String> {
		if (list.length > 0) deny = list;
		return deny;
	}

	public function set_allow(list: Array<String>): Array<String> {
		if (list.length > 0) allow = list;
		return allow;
	}

	public function checkAllowGroups(groups: Null<Array<String>>): Bool {
		if (groups != null) {
			if (deny.length > 0) for (group in groups) if (deny.indexOf(group) != -1) return false;
			if (allow.length > 0) for (group in groups) if (allow.indexOf(group) != -1) return true;
		}
		return allow.length == 0;
	}

	public function getModule<T: Module>(cls: Class<T>): Null<T> {
		return cast list.find( function(m: Module): Bool return #if (haxe_ver >= 4.100) Std.isOfType(m, cls) #else Std.is(m, cls) #end );
	}

}