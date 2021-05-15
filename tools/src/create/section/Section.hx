package create.section;

import pony.magic.HasAbstract;
import pony.text.XmlTools;

/**
 * Section
 * @author AxGord <axgord@gmail.com>
 */
class Section implements HasAbstract {

	public var appNode:String = null;
	public var active: Bool = false;

	private var xml: Xml;
	private var root: Xml;
	private var apps: Xml;
	private var name: String;

	public function new(name: String) {
		this.name = name;
	}

	private function init(): Void {
		if (root == null) {
			root = Xml.createElement(name);
			if (appNode != null) {
				apps = Xml.createElement('apps');
				root.addChild(apps);
				xml = Xml.createElement(appNode);
				apps.addChild(xml);
			} else {
				xml = root;
			}
		}
	}

	@:abstract public function result(): Xml;

	public function addTo(s: Section): Void {
		result();
		s.apps.addChild(xml);
	}

	private function add(name: String, ?value: String): Xml {
		var node: Xml = XmlTools.node(name, value);
		xml.addChild(node);
		return node;
	}

	private function set(att: String, value: String): Void {
		xml.set(att, value);
	}

}