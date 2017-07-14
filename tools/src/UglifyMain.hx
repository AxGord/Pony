
#if nodejs
import js.Node;
import haxe.xml.Fast;
import sys.io.File;

/**
 * Uglify
 * @author AxGord <axgord@gmail.com>
 */
class UglifyMain {

	static var debug:Bool = false;
	static var app:String;
	static var input:Array<String> = [];
	static var output:String = null;
	static var mapInput:String = null;
	static var mapOutput:String = null;
	static var mapUrl:String = null;
	static var mapSource:String = null;
	static var mangle:Bool = false;
	static var compress:Bool = false;
	
	static function main() {
		var UglifyJS = Node.require("uglify-js");
		
		var xml = Utils.getXml().node.uglify;

		var cfg = Utils.parseArgs(Sys.args());
		
		app = cfg.app;
		debug = cfg.debug;
		
		run(xml);
		
		var inputContent:Dynamic<String> = {};
		for (f in input) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));

		var r = UglifyJS.minify(inputContent, {
			toplevel: true,
			warnings: true,
			sourceMap: mapInput == null ? null : {
				content: File.getContent(mapInput),
				filename: mapSource,
				url: mapUrl
			},
			mangle: mangle,
			compress: untyped compress ? {} : false
		});
		
		File.saveContent(output, r.code);
		if (mapOutput != null) File.saveContent(mapOutput, r.map);
	}
	
	static function run(xml:Fast) {
		for (e in xml.elements) {
			switch e.name {
				case 'input':
					input.push(e.innerData);
				case 'output':
					output = e.innerData;
				case 'sourcemap':
					
					mapInput = e.node.input.innerData;
					mapOutput = e.node.output.innerData;
					mapUrl = e.node.url.innerData;
					mapSource = e.node.source.innerData;
					
				case 'debug': if (debug) run(e);
				case 'release': if (!debug) run(e);
				
				case 'm': mangle = true;
				case 'c': compress = true;
				
				case 'apps': if (app != null && e.hasNode.resolve(app)) {
					run(e.node.resolve(app));
				}
			}
		}
	}
	
}
#end