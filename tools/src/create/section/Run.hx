package create.section;
import pony.text.XmlTools;

class Run extends Section {

	public var path:String = 'bin/';
	public var command:String = '';

	public function new() super('run');


	public function result():Xml {
		init();
		if (path != null) set('path', path);
		xml.addChild(XmlTools.data(command));
		return xml;
	}
}