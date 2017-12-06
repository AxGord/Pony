import haxe.xml.Fast;
import module.Module;

class Modules extends pony.Logable {

	public var xml(get, null):Fast;
	private var _xml:Fast;
	public var commands(default, null):Commands;
	public var list:Array<Module> = [];

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

	public function register<T:Module>(module:T):Void {
		module.modules = this;
		module.onError << error;
		module.onLog << log;
		list.push(module);
	}

	public function init():Void {
		for (m in list) m.init();
	}

}