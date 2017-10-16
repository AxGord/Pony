package create.section;

class Server extends Section {

	public var httpPort:Int = 2000;
	public var httpPath:String = 'bin/';
	public var http:Bool = false;
	public var haxePort:Int = 6001;
	public var haxe:Bool = false;

	public function new() super('server');

	public function result():Xml {
		init();
		if (http) {
			add('path', httpPath);
			add('port', Std.string(httpPort));
		}
		if (haxe) {
			add('haxe', Std.string(haxePort));
		}
		return xml;
	}

}