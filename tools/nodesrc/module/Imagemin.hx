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

class Imagemin {

	public function new(cfg:ImageminConfig) {
		if (cfg == null) return;
		var from:Array<String> = cfg.from.split(',').map(StringTools.trim).addToStringsEnd('*.');
		Sys.println('From: ' + from);
		var formats:Array<String> = cfg.format == null ? ['jpg', 'png', 'webp'] : cfg.format.split(',').map(StringTools.trim);
		Sys.println('Formats: ' + formats.join(', '));
		if (formats.indexOf('jpg') != -1) {
			NPM.imagemin(from.addToStringsEnd('jpg'), cfg.to, {
				plugins: [
					NPM.imagemin_jpegtran()
				]
			}).then(completeHandler);
		}
		if (formats.indexOf('png') != -1) {
			NPM.imagemin(from.addToStringsEnd('png'), cfg.to, {
				plugins: [
					NPM.imagemin_pngquant(cfg.pngq != null ? {quality: cfg.pngq} : {})
				]
			}).then(completeHandler);
		}
		if (formats.indexOf('webp') != -1 || (cfg.webpfrompng && formats.indexOf('png') != -1)) {
			if (cfg.webpfrompng) {
				//Fnt helper
				var ext:String = '.fnt';
				for (file in from) {
					var d:Dir = file.substr(0, -2);
					for (u in d.content(ext)) {
						var f:File = u.file;
						var nf:File = cfg.to + f.shortName + '_webp' + ext;
						nf.createWays();
						nf.content = StringTools.replace(f.content, '"' + f.shortName + '.png"', '"' + f.shortName + '.webp"');
					}
				}
				//json helper
				var ext:String = '.json';
				for (file in from) {
					var d:Dir = file.substr(0, -2);
					for (u in d.content(ext)) {
						var f:File = u.file;
						var nf:File = cfg.to + f.shortName + '_webp' + ext;
						nf.createWays();
						nf.content = StringTools.replace(f.content, '"' + f.shortName + '.png"', '"' + f.shortName + '.webp"');
					}
				}
			}
			NPM.imagemin(from.addToStringsEnd(cfg.webpfrompng ? '{png,webp}' : 'webp'), cfg.to, {
				plugins: [
					NPM.imagemin_webp({
						nearLossless: cfg.webpq
					})
				]
			}).then(completeHandler);
		}
	}

	private function completeHandler(r:Array<{data:Dynamic, path:String}>):Void {
		for (e in r) Sys.println(e.path);
	}

}