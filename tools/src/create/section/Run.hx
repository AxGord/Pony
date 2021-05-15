package create.section;

import pony.text.XmlTools;

/**
 * Run
 * @author AxGord <axgord@gmail.com>
 */
class Run extends Section {

	public var path:String = 'bin/';
	public var command:String = '';

	public function new() super('run');

	override public function result():Xml {
		init();
		if (path != null) set('path', path);
		xml.addChild(XmlTools.data(command));
		return xml;
	}
}