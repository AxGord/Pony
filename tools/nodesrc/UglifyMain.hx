/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
#if nodejs
import js.Node;
import haxe.xml.Fast;
import sys.io.File;
import pony.NPM;

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
		
		var xml = Utils.getXml().node.uglify;

		var cfg = Utils.parseArgs(Sys.args());
		
		app = cfg.app;
		debug = cfg.debug;
		
		run(xml);
		
		if (debug && xml.has.libcache && pony.text.TextTools.isTrue(xml.att.libcache)) {
			
			if (input.length == 1) return;

			var cachefile = 'libcache.js';

			var lastFile = input.pop();
			var lastContent = File.getContent(lastFile);

			var libdata = '';
			if (sys.FileSystem.exists(cachefile)) {
				libdata = File.getContent(cachefile);
			} else {
				var inputContent:Dynamic<String> = {};
				for (f in input) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));

				var r = NPM.uglify_js.minify(inputContent, {
					toplevel: true,
					warnings: true,
					mangle: mangle,
					compress: untyped compress ? {} : false
				});
				libdata = r.code;
				File.saveContent(cachefile, libdata);
			}
			File.saveContent(lastFile, libdata + '\n' + lastContent);
			var mapFile = lastFile + '.map';
			var convert = Node.require('convert-source-map');
			var offset = Node.require('offset-sourcemap-lines');
			var originalMap = convert.fromJSON(File.getContent(mapFile)).toObject();
			var offsettedMap = offset(originalMap, 1);
			var newMapData = convert.fromObject(offsettedMap).toJSON();
			File.saveContent(mapFile, newMapData);
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
			if (mapOutput != null) File.saveContent(mapOutput, r.map);
		}
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