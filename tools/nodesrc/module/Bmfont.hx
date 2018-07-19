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

import pony.fs.File;
import types.BmfontConfig;

class Bmfont {

	private var to:String;

	public function new(cfg:BmfontConfig) {
		to = cfg.to;
		Utils.createPath(to);
		for (font in cfg.font)
			packFont(cfg.from + font.file, font.size, font.charset, font.output);
	}

	private function packFont(font:File, size:Int, ?charset:String, ?output:String):Void {
		var short = font.shortName;
		var ofn = output != null ? output : short + '_' + size;
		var fntFile:String = to + ofn + '.fnt';
		if (sys.FileSystem.exists(fntFile)) return;
		pony.NPM.msdf_bmfont_xml(font.fullPath.first, {
			filename: ofn,
			charset: charset,
			smartSize: true,
			pot: false,
			square: true,
			fontSize: size,
			fieldType: 'sdf',
			distanceRange: 2,
			textureSize: [2048, 2048]
		}, function(error:Any, textures:Array<{filename:String, texture:Dynamic}>, font:{filename:String, data:String, options:Dynamic}){
			if (error != null) throw error;
			for (t in textures) {
				js.node.Fs.writeFileSync(to + ofn + '.png', t.texture);
			}
			var data = StringTools.replace(font.data, '<info face="$short"', '<info face="$ofn"');
			sys.io.File.saveContent(fntFile, data);
			Sys.println('');
			Sys.println(to + ofn + '.fnt');
		});
	}

}