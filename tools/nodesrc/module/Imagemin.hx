package module;

import haxe.io.Bytes;
import haxe.io.BytesData;
import pony.NPM;
import pony.fs.Dir;
import pony.fs.File;
import types.ImageminConfig;
import types.ImgFormat;

using pony.text.TextTools;

private typedef ImageminResultEntry = {
	data: BytesData,
	sourcePath: String,
	destinationPath: String
}

private typedef ImageminResult = Array<ImageminResultEntry>;

/**
 * Imagemin Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Imagemin extends NModule<ImageminConfig> {

	override private function run(cfg: ImageminConfig): Void {
		var from: Array<String> = cfg.from.split(',').map(StringTools.trim).addToStringsEnd('*.');
		log('From: ' + from);
		var formats: Array<String> = cfg.format == null ?
			[JPG, PNG, WEBP] : @:nullSafety(Off) cfg.format.split(',').map(StringTools.trim);
		log('Formats: ' + formats.join(', '));
		if (formats.indexOf(JPG) != -1 || (cfg.jpgfrompng && formats.indexOf(PNG) != -1)) {
			var dir: Dir = cfg.from;
			var filter: String = '.$JPG';
			if (cfg.jpgfrompng) filter += ' .$JPG';
			var files: Array<File> = cfg.recursive ? dir.contentRecursiveFiles(filter) : dir.files(filter);
			for (file in files) {
				tasks.add();
				NPM.imagemin([file.first], {
					plugins: [
						// NPM.imagemin_jpegtran(),
						// NPM.imagemin_jpeg_recompress(),
						cfg.fast ? NPM.imagemin_jpegoptim({progressive: true}) : NPM.imagemin_guetzli({nomemlimit: true, quality: cfg.jpgq})
					]
				}).then(function(r: ImageminResult): Void {
					var p: String = file.first.substr(cfg.from.length);
					p = p.substr(0, -4);
					var n: String = cfg.to + p + '.$JPG';
					Utils.createPath(n);
					var b: Bytes = Bytes.ofData(r[0].data);
					sys.io.File.saveBytes(n, b);
					log(n);
					tasks.end();
				});
			}
		}
		if (formats.indexOf(PNG) != -1) {
			tasks.add();
			if (cfg.pngq == null) {
				pngpack(from.addToStringsEnd(PNG), cfg.to);
			} else {
				var q: Float = @:nullSafety(Off) (cfg.pngq / 100);
				NPM.imagemin(from.addToStringsEnd(PNG), {
					destination: cfg.to,
					plugins: [ NPM.imagemin_pngquant({quality: [Math.max(0, q - 0.1), Math.min(q + 0.1, 1)], speed: 1}) ]
				}).then(_pngpack.bind(cfg.to));
			}
		}
		if (formats.indexOf(WEBP) != -1 || (cfg.webpfrompng && formats.indexOf(PNG) != -1)) {
			tasks.add();
			var cformats: Array<String> = [];
			if (cfg.webpfrompng) {
				cformats.push(PNG);
				// Fnt helper
				var ext: String = '.fnt';
				for (file in from) {
					var d: Dir = file.substr(0, -2);
					for (f in d.files(ext)) {
						var ef: File = (f.fullDir + f.shortName).first + '.$PNG';
						if (!ef.exists) continue;
						var nf: File = cfg.to + f.shortName + '_$WEBP' + ext;
						nf.createWays();
						var shn: String = f.shortName + '.$WEBP';
						log(f.name + ': ' + ef.name + ' -> ' + shn);
						nf.content = (@:nullSafety(Off) (f.content:String)).replaceInQuote(ef.name, shn).replaceInSingleQuote(ef.name, shn);
					}
				}
			}
			// if (cfg.webpfromjpg) formats.push('jpg');
			for (e in cformats) {
				// json helper
				var ext: String = '.json';
				for (file in from) {
					var d: Dir = file.substr(0, -2);
					for (f in d.files(ext)) {
						var ef: File = (f.fullDir + f.shortName).first + '.$e';
						log('Generate $WEBP json, check file: $f, $ef');
						if (!ef.exists) continue;
						var nf: File = cfg.to + f.shortName + '_$WEBP' + ext;
						log(nf);
						nf.createWays();
						nf.content = StringTools.replace(
							(@:nullSafety(Off) (f.content: String)),
							'"' + ef.name + '"',
							'"' + f.shortName + '.$WEBP"'
						);
					}
				}
			}
			cformats.push(WEBP);
			NPM.imagemin(from.addToStringsEnd('{' + cformats.join(',') + '}'), {
				destination: cfg.to,
				plugins: [
					NPM.imagemin_webp({
						nearLossless: cfg.webpq,
						quality: cfg.webpq,
						method: 6
					})
				]
			}).then(completeHandler);
		}
	}

	private function completeHandler(r: ImageminResult): Void {
		for (e in r) log('${e.sourcePath} => ${e.destinationPath}');
		tasks.end();
	}

	private inline function pngpack(a: Array<String>, to: String): Void {
		NPM.imagemin(a, {
			destination: to,
			plugins: [ NPM.imagemin_zopfli({more: true}) ]
		}).then(completeHandler);
		// NPM.imagemin_pngcrush({reduce: true})
		// NPM.imagemin_pngout({strategy: 0})
		// NPM.imagemin_optipng({optimizationLevel: 7})
	}

	private inline function _pngpack(to: String, r: ImageminResult): Void {
		for (e in r) log('${e.sourcePath} => ${e.destinationPath}');
		pngpack(r.map(getPath), to);
	}

	private static inline function getPath(e: ImageminResultEntry): String return e.destinationPath;

}