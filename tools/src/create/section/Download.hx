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
package create.section;

class Download extends Section {

	public static var LIBS:Map<String, Library> = [
		'stacktrace' => new Library('https://raw.githubusercontent.com/stacktracejs/stacktrace.js/v{v}/dist/stacktrace.min.js', '1.3.1'),
		'pixijs' => new Library('https://pixijs.download/v{v}/pixi.min.js', '4.7.0', 'pixi.js - v{v}'),
		'docready' => new Library('https://raw.githubusercontent.com/jfriend00/docReady/master/docready.js'),
	];

	public var list:Array<Library> = [];
	public var path:String = 'jslib/';

	public function new() super('download');

	public function addLib(name:String):Void list.push(LIBS[name]);

	public function result():Xml {
		init();
		set('path', path);
		for (lib in list) {
			xml.addChild(lib.xml());
		}
		return xml;
	}

	public function getLibFinal(name:String):String return path + LIBS[name].getFinal();

}

private class Library {

	var url:String;
	var verison:String;
	var check:String;

	public function new(url:String, ?verison:String, ?check:String) {
		this.url = url;
		this.verison = verison;
		this.check = check;
	}

	public function xml():Xml {
		var unit = Xml.createElement('unit');
		unit.set('url', url);
		if (verison != null)
			unit.set('v', verison);
		if (check != null)
			unit.set('check', check);
		return unit;
	}

	public function getFinal():String return url.substr(url.lastIndexOf('/') + 1);

}