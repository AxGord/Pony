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
import haxe.xml.Fast;

/**
 * ZipMain
 * @author AxGord <axgord@gmail.com>
 */
class Zip {

	private var input:Array<String> = [];
	private var output:String = 'app.zip';
	private var prefix:String = 'bin/';
	private var debug:Bool;
	private var app:String;
	private var compressLvl:Int = 9;
	
	public function new(xml:Fast, app:String, debug:Bool) {
		Sys.println('Zip files');
		
		this.app = app;
		this.debug = debug;
		getData(xml);
		
		var zip = new pony.ZipTool(output, prefix, compressLvl);
		zip.onLog << Sys.println;
		zip.onError << function(err:String) throw err;
		zip.writeList(input).end();
	}
	
	
	private function getData(xml:Fast):Void {
		for (node in xml.elements) {
			switch node.name {
				case 'input': input.push(node.innerData);
				case 'output': output = node.innerData;
				case 'apps': getData(node.node.resolve(app));
				case 'debug': if (debug) getData(node);
				case 'release': if (!debug) getData(node);
				case 'prefix': prefix = node.innerData;
				case 'compress': compressLvl = Std.parseInt(node.innerData);
				case _: throw 'Wrong zip tag';
			}
		}
	}
	
}