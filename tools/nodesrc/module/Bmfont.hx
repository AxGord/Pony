package module;

import pony.fs.File;
import pony.text.TextTools;
import types.BmfontConfig;
import haxe.xml.Fast;

/**
 * Bmfont module
 * @author AxGord <axgord@gmail.com>
 */
class Bmfont extends NModule<BmfontConfig> {

	private var to:String;

	override private function run(cfg:BmfontConfig):Void {
		to = cfg.to;
		Utils.createPath(to);
		for (font in cfg.font)
			packFont(cfg.from + font.file, font.size, font.face, cfg.type, font.charset, font.output, cfg.format, font.lineHeight);
	}

	private function packFont(font:File, size:Int, face:String, type:String, charset:String, output:String, format:String, lineHeight:Null<Int>):Void {
		tasks.add();
		var short = font.shortName;
		var ofn = output != null ? output : short + '_' + size;
		var fntFile:String = to + ofn + '.fnt';
		var convertToFnt:Bool = format == 'fnt';
		if (convertToFnt) format = 'xml';
		// if (sys.FileSystem.exists(fntFile)) return; //todo check xml
		log('Begin generation: ' + output);
		pony.NPM.msdf_bmfont_xml(font.fullPath.first, {
			filename: ofn,
			charset: charset,
			smartSize: true,
			pot: false,
			square: true,
			fontSize: size,
			fieldType: type,
			outputType: format,
			distanceRange: 2,
			textureSize: [2048, 2048]
		}, function(err:Any, textures:Array<{filename:String, texture:Dynamic}>, font:{filename:String, data:String, options:Dynamic}) {
			log('End generation: ' + output);
			if (err != null) {
				error(err);
				tasks.end();
				return;
			}
			for (t in textures) {
				js.node.Fs.writeFileSync(to + ofn + '.png', t.texture);
			}
			var f:String = face == null ? ofn : face;
			var data = StringTools.replace(font.data, '<info face="$short"', '<info face="$f"');
			if (lineHeight != null) data = TextTools.replaceXmlAttr(data, 'lineHeight', Std.string(lineHeight));
			if (convertToFnt) data = xmlToFnt(data);
			sys.io.File.saveContent(fntFile, data);
			log('');
			log(to + ofn + '.fnt');
			tasks.end();
		});
	}

	private static function xmlToFnt(s:String):String {
		var xml = new Fast(Xml.parse(s)).node.font;
		return [
			printNodes(xml, 'info'),
			printNodes(xml, 'common'),
			printNodes(xml.node.pages, 'page'),
			printNodes(xml, 'chars'),
			printNodes(xml.node.chars, 'char')
		].join('\n');
	}

	private static function printNodes(x:Fast, name:String):String {
		return [for (n in x.nodes.resolve(name)) name + ' ' + printAttrs(n)].join('\n');
	}

	private static function printAttrs(x:Fast):String {
		return [for (a in x.x.attributes()) if (a != 'charset' && a != 'char') a + '=' + x.att.resolve(a)].join(' ');
	}

}