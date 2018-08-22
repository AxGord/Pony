/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import haxe.xml.Fast;
import pony.text.XmlConfigReader;
import pony.text.TextTools;
import pony.fs.File;
import pony.fs.Dir;

private typedef TPConfig = { > BaseConfig, > TPUnit,
	from: String,
	to: String,
	?clean: Bool
}

private typedef TPUnit = {
	format: String,
	scale: Float,
	?datascale: Float,
	quality: Float,
	input: Array<String>,
	output: String,
	rotation: Bool,
	?trim: String
}

class Texturepacker {

	private var units:Array<TPUnit> = [];
	private var clean:Bool;

	public function new(xml:Fast, app:String, debug:Bool) {
		if (pony.text.XmlTools.isTrue(xml, 'disabled')) return;
		new Path(xml, {
			app: app,
			debug: debug,
			format: 'json png',
			scale: 1,
			quality: 1,
			from: '',
			to: '',
			rotation: true,
			input: [],
			output: null
		}, configHandler);

		var ignoreList:Array<String> = [];
		var toList:Array<String> = [];

		for (unit in units) {

			var format = unit.format.split(' ');
			var f:String = format.shift();

			var first:Bool = true;
			for (s in format) {
				var command = unit.input.copy();

				command.push('--format');
				command.push(f);
				
				var outExt = switch f {
					case 'phaser-json-array', 'phaser-json-hash', 'pixijs': 'json';
					case f: f;
				}

				var datafile = unit.output + (first ? '' : '_$s') + '.' + outExt;
				command.push('--data');
				command.push(datafile);
				
				var sheetfile = unit.output + '.' + s;
				command.push('--sheet');
				command.push(sheetfile);

				if (clean) {
					ignoreList.push(datafile);
					ignoreList.push(sheetfile);
					toList.push((datafile:File).fullDir);
				}

				command.push('--scale');
				command.push(Std.string(unit.scale));

				command.push('--scale-mode');
				command.push('Smooth');

				command.push(unit.rotation ? '--enable-rotation' : '--disable-rotation');

				switch format[1] {
					case 'png':
						command.push('--png-opt-level');
						command.push('7');
					case 'jpg':
						command.push('--jpg-quality');
						command.push(Std.string(Std.int(unit.quality * 100)));
					case _:
				}

				command.push('--force-squared');

				command.push('--pack-mode');
				command.push('Best');

				command.push('--algorithm');
				command.push('MaxRects');

				command.push('--maxrects-heuristics');
				command.push('Best');

				if (unit.trim != null) {
					var a:Array<String> = unit.trim.split(' ');
					if (a.length == 2) {
						var v:Int = Std.parseInt(a[0]);
						if (Std.string(v) == a[0]) {
							command.push('--trim-mode');
							command.push(a[1]);
							command.push('--trim-threshold');
							command.push(Std.string(v));
						} else {
							var v:Int = Std.parseInt(a[1]);
							command.push('--trim-mode');
							command.push(a[0]);
							command.push('--trim-threshold');
							command.push(Std.string(v));
						}
					} else if (a.length == 1) {
						var v:Int = Std.parseInt(a[0]);
						if (Std.string(v) == a[0]) {
							command.push('--trim-mode');
							command.push('Trim');
							command.push('--trim-threshold');
							command.push(Std.string(v));
						} else {
							command.push('--trim-mode');
							command.push(a[0]);
						}
					}
				}

				Utils.command('TexturePacker', command);

				if (unit.datascale != null) {
					switch outExt {
						case 'json':
							pony.text.TextTools.betweenReplaceFile(datafile, '"scale": "', '",', Std.string(unit.datascale));
						case _:
					}
				}
				
				first = false;
			}

		}

		if (clean) {
			var remList:Array<String> = toList.copy();
			for (a in toList) {
				for (b in toList) {
					if (a.length > b.length) {
						if (a.indexOf(b) == 0) remList.remove(a);
					} 
				}
			}

			Sys.println('Clean pathes: ' + remList.join(', '));
			Sys.println('Ignores: ' + ignoreList.join(', '));

			for (p in remList) {
				var d:Dir = p;
				for (f in d.contentRecursiveFiles()) {
					if (ignoreList.indexOf(f.first) == -1) {
						Sys.println('Delete file: ' + f.first);
						f.delete();
					}
				}
			}

		}

	}

	private function configHandler(cfg:TPConfig):Void {
		units.push({
			format: cfg.format,
			scale: cfg.scale,
			datascale: cfg.datascale,
			quality: cfg.quality,
			input: [for (e in cfg.input) cfg.from + e],
			output: cfg.to + cfg.output,
			rotation: cfg.rotation,
			trim: cfg.trim
		});
		clean = cfg.clean;
	}
	
}

private class Path extends XmlConfigReader<TPConfig> {

	override private function readXml(xml:Fast):Void {
		var variants:Array<TPConfig> = [for (node in xml.nodes.variant) cast (selfCreate(node), Path).cfg];
		if (variants.length > 0) {
			for (v in variants) {
				cfg = v;
				super.readXml(xml);
			}
		} else {
			super.readXml(xml);
		}
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'format': cfg.format = val;
			case 'scale': cfg.scale = Std.parseFloat(val);
			case 'datascale': cfg.datascale = Std.parseFloat(val);
			case 'quality': cfg.quality = Std.parseFloat(val);
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case 'rotation': cfg.rotation = !TextTools.isFalse(val);
			case 'trim': cfg.trim = StringTools.trim(val);
			case 'clean': cfg.clean = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'unit': new Unit(xml, copyCfg(), onConfig);
			case 'variant':
			case _: throw 'Unknown tag';
		}
	}

}

private class Unit extends Path {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'path':
				var from = normalize(xml.att.from);
				for (node in xml.nodes.input) {
					cfg.input.push(from + normalize(node.innerData));
				}
			case 'input': cfg.input.push(normalize(xml.innerData));
			case 'output': cfg.output = normalize(xml.innerData);
			case _: throw 'Unknown tag';
		}
	}

	override private function end():Void onConfig(cfg);

}