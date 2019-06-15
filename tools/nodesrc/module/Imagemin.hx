package module;

import haxe.io.Bytes;
import haxe.io.BytesData;
import pony.NPM;
import pony.fs.Dir;
import pony.fs.File;
import types.ImageminConfig;

using pony.text.TextTools;

/**
 * Imagemin module
 * @author AxGord <axgord@gmail.com>
 */
class Imagemin extends NModule<ImageminConfig> {

	override private function run(cfg:ImageminConfig):Void {
		var from:Array<String> = cfg.from.split(',').map(StringTools.trim).addToStringsEnd('*.');
		log('From: ' + from);
		var formats:Array<String> = cfg.format == null ? ['jpg', 'png', 'webp'] : cfg.format.split(',').map(StringTools.trim);
		log('Formats: ' + formats.join(', '));
		if (formats.indexOf('jpg') != -1 || (cfg.jpgfrompng && formats.indexOf('png') != -1)) {
			var dir:Dir = cfg.from;
			var filter:String = '.jpg';
			if (cfg.jpgfrompng) filter += ' .png';
			var files:Array<File> = cfg.recursive ? dir.contentRecursiveFiles(filter) : dir.files(filter);
			for (file in files) {
				tasks.add();
				NPM.imagemin([file.first], {
					plugins: [
						// NPM.imagemin_jpegtran(),
						// NPM.imagemin_jpeg_recompress(),
						// NPM.imagemin_jpegoptim(),
						NPM.imagemin_guetzli({nomemlimit: true, quality: cfg.jpgq})
					]
				}).then(function(r:Array<{data:BytesData, path:String}>):Void {
					var p:String = file.first.substr(cfg.from.length);
					p = p.substr(0, -4);
					var n:String = cfg.to + p + '.jpg';
					Utils.createPath(n);
					var b:Bytes =  Bytes.ofData(r[0].data);
					sys.io.File.saveBytes(n, b);
					log(n);
					tasks.end();
				});
			}
		}
		if (formats.indexOf('png') != -1) {
			tasks.add();
			if (cfg.pngq == null)
				pngpack(from.addToStringsEnd('png'), cfg.to);
			else
				NPM.imagemin(from.addToStringsEnd('png'), cfg.to, {
					plugins: [
						NPM.imagemin_pngquant({quality: cfg.pngq, speed: 1})
					]
				}).then(_pngpack.bind(cfg.to));
		}
		if (formats.indexOf('webp') != -1 || (cfg.webpfrompng && formats.indexOf('png') != -1)) {
			tasks.add();
			var cformats:Array<String> = [];
			if (cfg.webpfrompng) {
				cformats.push('png');
				//Fnt helper
				var ext:String = '.fnt';
				for (file in from) {
					var d:Dir = file.substr(0, -2);
					for (f in d.files(ext)) {
						var ef:File = (f.fullDir + f.shortName).first + '.png';
						if (!ef.exists) continue;
						var nf:File = cfg.to + f.shortName + '_webp' + ext;
						nf.createWays();
						var shn:String = f.shortName + '.webp';
						log(f.name + ': ' + ef.name + ' -> ' + shn);
						nf.content = f.content.replaceInQuote(ef.name, shn).replaceInSingleQuote(ef.name, shn);
					}
				}
			}
			// if (cfg.webpfromjpg) formats.push('jpg');
			for (e in cformats) {
				//json helper
				var ext:String = '.json';
				for (file in from) {
					var d:Dir = file.substr(0, -2);
					for (f in d.files(ext)) {
						var ef:File = (f.fullDir + f.shortName).first + '.$e';
						if (!ef.exists) continue;
						var nf:File = cfg.to + f.shortName + '_webp' + ext;
						nf.createWays();
						nf.content = StringTools.replace(f.content, '"' + ef.name + '"', '"' + f.shortName + '.webp"');
					}
				}
			}
			cformats.push('webp');
			NPM.imagemin(from.addToStringsEnd('{' + cformats.join(',') + '}'), cfg.to, {
				plugins: [
					NPM.imagemin_webp({
						nearLossless: cfg.webpq
					})
				]
			}).then(completeHandler);
		}
	}

	private function completeHandler(r:Array<{data:BytesData, path:String}>):Void {
		for (e in r) log(e.path);
		tasks.end();
	}

	private function pngpack(a:Array<String>, to:String):Void {
		NPM.imagemin(a, to, {
			plugins: [
				NPM.imagemin_zopfli({more: true})
			]
		}).then(completeHandler);
		// NPM.imagemin_pngcrush({reduce: true})
		// NPM.imagemin_pngout({strategy: 0})
		// NPM.imagemin_optipng({optimizationLevel: 7})
	}

	private function _pngpack(to:String, r:Array<{data:Dynamic, path:String}>):Void pngpack(r.map(getPath), to);

	private static function getPath(e:{data:Dynamic, path:String}):String return e.path;

}