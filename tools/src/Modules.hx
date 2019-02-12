import pony.Fast;
import pony.text.XmlTools;
import module.Build;
import module.Module;

/**
 * Modules
 * @author AxGord <axgord@gmail.com>
 */
class Modules extends pony.Logable {

	public var xml(get, null):Fast;
	private var _xml:Fast;
	public var commands(default, null):Commands;
	public var deny(default, set):Array<String>;
	public var allow(default, set):Array<String>;
	public var list:Array<Module> = [];
	public var build:Build;

	public function new(commands:Commands) {
		super();
		this.commands = commands;
		onError << commands.error;
		onLog << commands.log;
	}

	private function get_xml():Fast {
		if (_xml == null)
			_xml = Utils.getXml();
		return _xml;
	}

	public function checkXml():Void {
		if (xml == null)
			error(Utils.MAIN_FILE + ' not exists');
	}

	public function register<T:Module>(module:T):Void {
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

	public function init():Void {
		for (m in list) m.init();
	}

	@:extern public inline function getNode(name:String):Fast {
		return XmlTools.getNode(xml, name);
	}

	public function set_deny(list:Array<String>):Array<String> {
		if (list.length > 0) deny = list;
		return deny;
	}

	public function set_allow(list:Array<String>):Array<String> {
		if (list.length > 0) allow = list;
		return allow;
	}

	public function checkAllowGroups(groups:Array<String>):Bool {
		if (groups != null) {
			if (deny != null) for (group in groups) {
				if (deny.indexOf(group) != -1) return false;
			}
			if (allow != null) for (group in groups) {
				if (allow.indexOf(group) != -1) return true;
			}
		}
		return allow == null;
	}

}