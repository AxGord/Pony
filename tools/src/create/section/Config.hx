package create.section;

class Config extends Section {

	public var options:Map<String, String> = new Map();

	public function new() super('config');

	public function result():Xml {
		init();
		for (k in options.keys()) add(k, options[k]);
		return xml;
	}

}