package module;

import js.node.Fs;
import pony.fs.File;
import pony.text.TextTools;
import pony.Fast;
import pony.NPM;
import types.BmfontConfig;

/**
 * Bmfont Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Bmfont extends NModule<BmfontConfig> {

	@:nullSafety(Off) private var to: String;

	override private function run(cfg: BmfontConfig): Void {
		to = cfg.to;
		Utils.createPath(to);
		for (font in cfg.font)
			packFont(
				cfg.from + font.file,
				font.size,
				font.face,
				cfg.type,
				font.charset,
				font.output,
				cfg.format,
				font.lineHeight,
				cfg.distance,
				cfg.padding
			);
	}

	private function packFont(
		font: File,
		size: Int,
		face: String,
		type: String,
		charset: String,
		output: String,
		format: String,
		lineHeight: Null<Int>,
		distance: Int,
		padding: Int
	): Void {
		if (padding == -1) padding = 0;
		tasks.add();
		@:nullSafety(Off) var short: String = font.shortName;
		var ofn: String = output != null ? output : short + '_' + size;
		var fntFile: File = to + ofn + '.fnt';
		var convertToFnt: Bool = format == 'fnt';
		if (convertToFnt) format = 'xml';
		// if (sys.FileSystem.exists(fntFile)) return; //todo check xml
		log('Begin generation: ' + output);
		NPM.msdf_bmfont_xml(font.fullPath.first, {
			filename: ofn,
			charset: charset,
			smartSize: true,
			pot: false,
			square: true,
			fontSize: size,
			fieldType: type,
			outputType: format,
			distanceRange: distance,
			texturePadding: padding,
			textureSize: [2048, 2048]
		}, function(
			err: Any,
			textures: Array<{filename: String, texture: Dynamic}>,
			font: {filename: String, data: String, options: Dynamic}
		): Void {
			log('End generation: ' + output);
			if (err != null) {
				error(err);
				tasks.end();
				return;
			}
			for (t in textures) Fs.writeFileSync(to + ofn + '.png', t.texture);
			var f: String = face == null ? ofn : face;
			var data: String = StringTools.replace(font.data, '<info face="$short"', '<info face="$f"');
			if (lineHeight != null) data = TextTools.replaceXmlAttr(data, 'lineHeight', @:nullSafety(Off) Std.string(lineHeight));
			if (convertToFnt) data = xmlToFnt(data);
			fntFile.content = data;
			log('');
			log(to + ofn + '.fnt');
			tasks.end();
		});
	}

	private static function xmlToFnt(s: String): String {
		var xml: Fast = new Fast(Xml.parse(s)).node.font;
		return [
			printNodes(xml, 'info'),
			printNodes(xml, 'common'),
			printNodes(xml.node.pages, 'page'),
			printNodes(xml, 'distanceField'),
			printNodes(xml, 'chars'),
			printNodes(xml.node.chars, 'char')
		].join('\n');
	}

	private static function printNodes(x: Fast, name: String): String {
		return [ for (n in x.nodes.resolve(name)) name + ' ' + printAttrs(n) ].join('\n');
	}

	private static function printAttrs(x: Fast): String {
		return [ for (a in x.x.attributes()) if (a != 'charset' && a != 'char') a + '=' + x.att.resolve(a) ].join(' ');
	}

}