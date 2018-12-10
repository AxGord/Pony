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
import js.node.Https;
import pony.NPM;
import pony.fs.Dir;
import pony.fs.File;
import types.PoeditorConfig;

using pony.text.TextTools;

class Poeditor extends NModule<PoeditorConfig> {

	override private function run(cfg:PoeditorConfig):Void {
		tasks.add();
		var client:Dynamic = Type.createInstance(NPM.poeditor_client, [cfg.token]);
		client.projects.get(cfg.id).then(function(project){
			project.languages.list().then(function(languages:Array<{name:String, code:String, percentage:Int, export:Dynamic}>){
				for (i in 0...languages.length) {
					var lang = languages[i];
					log('Check lang: ' + lang.name);
					if (lang.percentage == 100 && cfg.list.exists(lang.code)) {
						tasks.add();
						try {
							lang.export({type: 'key_value_json'}).then(function(v) {
								var file:String = cfg.path + cfg.list[lang.code] + '.json';
								log('Update lang file: ' + file);
								var f = Fs.createWriteStream(file);
								Https.get(v, function(response:IncomingMessage) {
									response.once('end', tasks.end);
									response.pipe(f); 
								});
							});
						} catch (e:Any) error(e);
					}
				}
				tasks.end();
			});
		});
	}

}