import haxe.xml.Fast;
import XmlConfigReader;

private typedef TPConfig = { > BaseConfig, > TPUnit,
	from:String,
	to:String
}

private typedef TPUnit = {
	format: String,
	scale: Float,
	?datascale: Float,
	quality: Float,
	input: Array<String>,
	output: String
}

class Texturepacker {

	private var units:Array<TPUnit> = [];

	public function new(xml:Fast, app:String, debug:Bool) {
		if (app == null && xml.hasNode.apps) throw 'Please type app name';
		new Path(xml, {
			app: app,
			debug: debug,
			format: 'json png',
			scale: 1,
			quality: 1,
			from: '',
			to: '',
			input: [],
			output: null
		}, configHandler);

		for (unit in units) {
			var command = unit.input.copy();
			var format = unit.format.split(' ');
			command.push('--format');
			command.push(format[0]);
			
			var outExt = switch format[0] {
				case 'phaser-json-array', 'phaser-json-hash', 'pixijs': 'json';
				case f: f;
			}

			var datafile = unit.output + '.' + outExt;
			command.push('--data');
			command.push(datafile);

			command.push('--sheet');
			command.push(unit.output + '.' + format[1]);

			command.push('--scale');
			command.push(Std.string(unit.scale));

			switch format[1] {
				case 'png':
					//command.push('--png-opt-level');
					//command.push('7');
				case 'jpg':
					command.push('--jpg-quality');
					command.push(Std.string(Std.int(unit.quality * 100)));
				case _:
			}

			command.push('--force-squared');

			command.push('--pack-mode');
			command.push('Best');

			Utils.command('TexturePacker', command);

			if (unit.datascale != null) {
				switch outExt {
					case 'json':
						pony.text.TextTools.betweenReplaceFile(datafile, '"scale": "', '",', Std.string(unit.datascale));
					case _:
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
			output: cfg.to + cfg.output
		});
	}
	
}

private class Path extends XmlConfigReader<TPConfig> {

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'format': cfg.format = val;
			case 'scale': cfg.scale = Std.parseFloat(val);
			case 'datascale': cfg.datascale = Std.parseFloat(val);
			case 'quality': cfg.quality = Std.parseFloat(val);
			case 'from': cfg.from += val;
			case 'to': cfg.to += val;
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'unit': new Unit(xml, copyCfg(), onConfig);
			case _: throw 'Unknown tag';
		}
	}

}

private class Unit extends Path {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'input': cfg.input.push(normalize(xml.innerData));
			case 'output': cfg.output = normalize(xml.innerData);
			case _: throw 'Unknown tag';
		}
	}

	override private function end():Void onConfig(cfg);

}