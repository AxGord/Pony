package create.section;

class Download extends Section {

	public static var LIBS:Map<String, Library> = [
		'stacktrace' => new Library('https://raw.githubusercontent.com/stacktracejs/stacktrace.js/v{v}/dist/stacktrace.min.js', '1.3.0'),
		'pixijs' => new Library('https://pixijs.download/v{v}/pixi.min.js', '4.5.3', 'pixi.js - v{v}'),
	];

	public var list:Array<Library> = [];
	public var path:String = 'jslib/';

	public function new() super('download');

	public function addLib(name:String):Void {
		list.push(LIBS[name]);
	}

	public function result():Xml {
		init();
		set('path', path);
		for (lib in list) {
			xml.addChild(lib.xml());
		}
		return xml;
	}

}

private class Library {

	var url:String;
	var verison:String;
	var check:String;

	public function new(url:String, ?verison:String, ?check:String) {
		this.url = url;
		this.verison = verison;
		this.check = check;
	}

	public function xml():Xml {
		var unit = Xml.createElement('unit');
		unit.set('url', url);
		if (verison != null)
			unit.set('v', verison);
		if (check != null)
			unit.set('check', check);
		return unit;
	}

}