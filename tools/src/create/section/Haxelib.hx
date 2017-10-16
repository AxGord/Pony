package create.section;

class Haxelib extends Section {

	public var libs:Map<String, String> = new Map<String, String>();

	public function new() super('haxelib');

	public function addLib(name:String, ?version:String):Void {
		libs[name] = version;
	}

	public function result():Xml {
		init();
		for (name in libs.keys()) {
			var v = libs[name];
			if (v == null)
				add('lib', name);
			else
				add('lib', '$name $v');
		}
		return xml;
	}

}