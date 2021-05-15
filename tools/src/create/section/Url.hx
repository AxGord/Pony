package create.section;

/**
 * Url
 * @author AxGord <axgord@gmail.com>
 */
class Url extends Section {

	public var list:Array<String> = [];

	public function new() super('url');

	override public function result():Xml {
		init();
		for (url in list) add('url', url);
		return xml;
	}

}