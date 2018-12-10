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

import js.node.http.IncomingMessage;
import js.node.Fs;
import js.node.Http;
import js.node.Https;
import sys.FileSystem;
import pony.Pair;
import types.DownloadConfig;

using pony.text.TextTools;

class Download extends NModule<DownloadConfig> {

	override private function run(cfg:DownloadConfig):Void {
		var downloadList:Array<Pair<String, String>> = [];
		
		for (unit in cfg.units) {
			
			var file:String = cfg.path + unit.a.split('/').pop();
			var needDownload:Bool = false;
			
			if (unit.b != null && FileSystem.exists(file)) {
				if (unit.b != null) {
					log('Check ' + file);
					needDownload = sys.io.File.getContent(file).indexOf(unit.b) == -1;
				} else {
					needDownload = false;
				}
			} else {
				needDownload = true;
			}
			
			if (needDownload) {
				downloadList.push(new Pair(file, unit.a));
			}
			
		}
		for (file in downloadList) {
			log('Download ' + file.b);
			tasks.add();
			var protocol:String = file.b.substr(0, 7);
			switch protocol {
				case 'https:/':
					Https.get(file.b, function(response:IncomingMessage) {
						response.once('end', tasks.end);
						response.pipe(Fs.createWriteStream(file.a)); 
					});
				case 'http://':
					Http.get(file.b, function(response:IncomingMessage) {
						response.once('end', tasks.end);
						response.pipe(Fs.createWriteStream(file.a)); 
					});
				case _:
					error('Unsupported protocol: $protocol');
			}
		}
	}

}