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
#if nodejs
import js.node.http.IncomingMessage;
import js.node.Fs;
import js.node.Https;
import sys.FileSystem;
import sys.io.File;
import pony.Tasks;
import pony.NPM;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;

/**
 * Poeditor
 * @author AxGord <axgord@gmail.com>
 */
class Poeditor {
	
	private var id:Int;
	private var path:String;
	private var client:Dynamic;
	private var files:Map<String, String>;
	
	public function new(xml:Fast) {
		var token:String = null;
		try {
			token = xml.node.token.innerData;
			id = Std.parseInt(xml.node.id.innerData);
			path = xml.node.path.innerData;
			FileSystem.createDirectory(path);
			files = [for (e in xml.node.list.elements) e.innerData => e.name];
		} catch (_:Dynamic) {
			Sys.println('Configuration error');
			return;
		}
		
		client = Type.createInstance(NPM.poeditor_client, [token]);
	}
	
	public function updateFiles(cb:Void -> Void):Void {
		var tasks = new Tasks(cb);
		client.projects.get(id).then(function(project){
			project.languages.list().then(function(languages:Array<{name:String, code:String, percentage:Int, export:Dynamic}>){
				tasks.add();
				for (i in 0...languages.length) {
					var lang = languages[i];
					Sys.println('Check lang: ' + lang.name);
					if (lang.percentage == 100 && files.exists(lang.code)) {
						tasks.add();
						try {
							lang.export({type: 'key_value_json'}).then(function(v) {
								var file = path + files[lang.code] + '.json';
								Sys.println('Update lang file: ' + file);
								var f = Fs.createWriteStream(file);
								Https.get(v, function(response:IncomingMessage) {
									response.once('end', tasks.end);
									response.pipe(f); 
								});
							});
						} catch (e:Dynamic) trace(e);
					}
				}
				tasks.end();
			});
		});
	}
	
}
#end