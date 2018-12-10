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
package module;

import pony.NPM;
import pony.fs.Dir;
import pony.fs.File;
import types.ImageminConfig;

using pony.text.TextTools;

class Imagemin extends NModule<ImageminConfig> {

	override private function run(cfg:ImageminConfig) {
		var from:Array<String> = cfg.from.split(',').map(StringTools.trim).addToStringsEnd('*.');
		log('From: ' + from);
		var formats:Array<String> = cfg.format == null ? ['jpg', 'png', 'webp'] : cfg.format.split(',').map(StringTools.trim);
		log('Formats: ' + formats.join(', '));
		if (formats.indexOf('jpg') != -1) {
			tasks.add();
			NPM.imagemin(from.addToStringsEnd('jpg'), cfg.to, {
				plugins: [
					// NPM.imagemin_jpegtran(),
					// NPM.imagemin_jpeg_recompress(),
					// NPM.imagemin_jpegoptim(),
					NPM.imagemin_guetzli({nomemlimit: true, quality: cfg.jpgq})
				]
			}).then(completeHandler);
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

	private function completeHandler(r:Array<{data:Dynamic, path:String}>):Void {
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