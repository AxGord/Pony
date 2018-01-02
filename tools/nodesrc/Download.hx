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
import pony.Tasks;
import js.node.Http;
import js.node.Https;
import js.node.Fs;
import js.Node;
import sys.FileSystem;
import haxe.xml.Fast;
import pony.Pair;

/**
 * Donwload
 * @author AxGord <axgord@gmail.com>
 */
class Download {
	
	private var path:String;
	private var units:Array<Pair<String, String>>;
	
	public function new(xml:Fast) {
		try {
			path = xml.att.path;
			FileSystem.createDirectory(path);
			units = [for (e in xml.nodes.unit) {
				if (e.has.v) {
					var v = e.att.v;
					new Pair(StringTools.replace(e.att.url, '{v}', v), e.has.check ? StringTools.replace(e.att.check, '{v}', v) : null);
				} else {
					new Pair(e.att.url, e.has.check ? e.att.check : null);
				}
			}];
		} catch (e:Dynamic) {
			trace(e);
			Sys.println('Configuration error');
			return;
		}
	}
	
	public function run(cb:Void -> Void):Void {
		var tasks = new Tasks(cb);
		var downloadList = [];
		
		for (unit in units) {
			
			var file = path + unit.a.split('/').pop();
			var needDownload = false;
			
			if (unit.b != null && FileSystem.exists(file)) {
				if (unit.b != null) {
					Sys.println('Check ' + file);
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
		tasks.add();
		for (file in downloadList) {
			Sys.println('Download ' + file.b);
			tasks.add();
			var protocol = file.b.substr(0, 7);
			if (protocol == 'https:/') {
				//Sys.println('https download');
				Https.get(file.b, function(response:IncomingMessage) {
					response.once('end', tasks.end);
					response.pipe(Fs.createWriteStream(file.a)); 
				});
			} else if (protocol ==  'http://') {
				//Sys.println('http download');
				Http.get(file.b, function(response:IncomingMessage) {
					response.once('end', tasks.end);
					response.pipe(Fs.createWriteStream(file.a)); 
				});
			} else {
				Sys.println('Unsupported protocol: $protocol');
				tasks.end();
			}
		}
		tasks.end();
		
	}
	
}
#end