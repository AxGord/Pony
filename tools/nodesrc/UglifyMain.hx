#if nodejs
import js.Node;
import pony.Fast;
import sys.io.File;
import pony.NPM;

/**
 * Uglify
 * @author AxGord <axgord@gmail.com>
 */
class UglifyMain {

	var debug:Bool = false;
	var app:String;
	var input:Array<String> = [];
	var output:String = null;
	var mapInput:String = null;
	var mapOutput:String = null;
	var mapUrl:String = null;
	var mapSource:String = null;
	var mapOffset:Int = 0;
	var mangle:Bool = false;
	var compress:Bool = false;
	
	static function main() {
		var cfg = Utils.parseArgs(Sys.args());
		for (xml in Utils.getXml().nodes.uglify)
			new UglifyMain(xml, cfg);
	}

	function new(xml:Fast, cfg:AppCfg) {
		app = cfg.app;
		debug = cfg.debug;
		
		run(xml);
		
		if (debug && xml.has.libcache && pony.text.TextTools.isTrue(xml.att.libcache)) {
			
			var lastFile = input.pop();

			if (input.length == 0) {
				patchMapFile(lastFile + '.map', mapOffset);
				return;
			}

			var cachefile = 'libcache.js';

			var lastContent = File.getContent(lastFile);

			var libdata = '';
			if (sys.FileSystem.exists(cachefile)) {
				libdata = File.getContent(cachefile);
			} else {
				var inputContent:Dynamic<String> = {};
				for (f in input) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));
				var tries:Int = 3;
				do {
				var r = NPM.uglify_js.minify(inputContent, {
					toplevel: true,
					warnings: true,
					mangle: mangle,
					compress: untyped compress ? {} : false
				});
				libdata = r.code;
				} while (libdata == null && --tries > 0);
				if (libdata == null) throw "Can't generate lib data!";
				File.saveContent(cachefile, libdata);
			}
			File.saveContent(lastFile, libdata + '\n' + lastContent);
			patchMapFile(lastFile + '.map', 1 + mapOffset);
		} else {
			var inputContent:Dynamic<String> = {};
			for (f in input) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));

			var r = NPM.uglify_js.minify(inputContent, {
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
			if (mapOutput != null)
				File.saveContent(mapOutput, patchMap(r.map, mapOffset));
		}
	}
	
	function run(xml:Fast) {
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
					if (e.hasNode.offset)
						mapOffset = Std.parseInt(e.node.offset.innerData);
					
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

	public static function patchMapFile(file:String, offset:Int):Void {
		if (offset == 0) return;
		File.saveContent(file, patchMap(File.getContent(file), offset));
	}

	public static function patchMap(content:String, offset:Int):String {
		if (offset == 0) return content;
		Sys.println('Offset map: $offset');
		var originalMap = NPM.convert_source_map.fromJSON(content).toObject();
		var offsettedMap = NPM.offset_sourcemap_lines(originalMap, offset);
		return NPM.convert_source_map.fromObject(offsettedMap).toJSON();
	}
	
}
#end