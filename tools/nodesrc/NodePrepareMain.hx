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
#if nodejs
import sys.io.File;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;

/**
 * NodePrepare
 * @author AxGord <axgord@gmail.com>
 */
class NodePrepareMain {

	static var itetator:Iterator<Fast>;
	
	private static function main() {
		var file = 'pony.xml';
		var xml = new Fast(Xml.parse(File.getContent(file)));
		itetator = xml.node.project.elements;
		runNext();
	}
	
	static function runNext():Void {
		if (!itetator.hasNext()) {
			Sys.println('Node prepare complete');
			return;
		}
		var e = itetator.next();
		switch e.name {
			case 'poeditor':
				
				Sys.println(e.name);
				var poe = new Poeditor(e);
				poe.updateFiles(runNext);
				
			case 'download':
				
				Sys.println(e.name);
				var d = new Download(e);
				d.run(runNext);
				
			case _:
				runNext();
		}
	}
	
}
#end