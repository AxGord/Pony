import haxe.xml.Fast;
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

}