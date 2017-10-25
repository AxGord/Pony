package create.section;
import pony.text.XmlTools;

class Section {

	public var active:Bool = false;
	private var xml:Xml;
	private var name:String;

	public function new(name:String) {
		this.name = name;
	}

	private function init():Void {
		if (xml == null)
			xml = Xml.createElement(name);
	}

	private function add(name:String, value:String):Void {
		xml.addChild(XmlTools.node(name, value));
	}

	private function set(att:String, value:String):Void {
		xml.set(att, value);
	}

}