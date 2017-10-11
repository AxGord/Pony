import haxe.xml.Fast;

/**
 * ZipMain
 * @author AxGord <axgord@gmail.com>
 */
class Zip {

	private var input:Array<String> = [];
	private var output:String = 'app.zip';
	private var prefix:String = 'bin/';
	private var debug:Bool;
	private var app:String;
	private var compressLvl:Int = 9;
	
	public function new(xml:Fast, app:String, debug:Bool) {
		Sys.println('Zip files');
		
		this.app = app;
		this.debug = debug;
		getData(xml);
		
		var zip = new pony.ZipTool(output, prefix, compressLvl);
		zip.onLog << Sys.println;
		zip.onError << function(err:String) throw err;
		zip.writeList(input).end();
	}
	
	
	private function getData(xml:Fast):Void {
		for (node in xml.elements) {
			switch node.name {
				case 'input': input.push(node.innerData);
				case 'output': output = node.innerData;
				case 'apps': getData(node.node.resolve(app));
				case 'debug': if (debug) getData(node);
				case 'release': if (!debug) getData(node);
				case 'prefix': prefix = node.innerData;
				case 'compress': compressLvl = Std.parseInt(node.innerData);
				case _: throw 'Wrong zip tag';
			}
		}
	}
	
}