/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package;
import haxe.xml.Fast;
import sys.io.File;

/**
 * Wrapper
 * @author AxGord <axgord@gmail.com>
 */
class Wrapper {
	
	private var debug:Bool;
	private var app:String;
	private var pre:String;
	private var post:String;
	private var file:String;

	public function new(xml:Fast, app:String, debug:Bool) {
		//Sys.println('Wrapper');
		this.app = app;
		this.debug = debug;
		
		if (app == null && xml.hasNode.apps) throw 'Please type app name';
		
		pushCommands(xml);
		
		if (file == null) throw 'File not set';
		if (pre == null && post == null) {
			//Sys.println('Nothing');
			return;
		}
		
		var data = File.getContent(file);
		
		if (pre != null) data = pre + data;
		if (post != null) data = data + post;
		
		Sys.println('Apply wrapper to ' + file);
		
		File.saveContent(file, data);
	}
	
	private function pushCommands(xml:Fast):Void {
		for (e in xml.elements) {
			switch e.name {
				case 'apps':
					pushCommands(e.node.resolve(app));
				case 'debug': if (debug) pushCommands(e);
				case 'release': if (!debug) pushCommands(e);
				case 'pre':
					pre = e.innerData;
				case 'post':
					post = e.innerData;
				case 'file':
					file = e.innerData;
			}
		}
		
	}
	
}