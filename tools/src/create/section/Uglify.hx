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
import pony.text.XmlTools;

class Uglify extends Section {

	public var outputPath:String;
	public var outputFile:String;

	public var debugLibs:Array<String> = [];
	public var releaseLibs:Array<String> = [];
	public var libs:Array<String> = [];

	public function new() super('uglify');

	public function result():Xml {
		init();
		set('libcache', 'true');

		var release = Xml.createElement('release');
		release.addChild(Xml.createElement('c'));
		release.addChild(Xml.createElement('m'));
		for (lib in releaseLibs) release.addChild(XmlTools.node('input', lib));
		xml.addChild(release);

		var debug = Xml.createElement('debug');
		for (lib in debugLibs) debug.addChild(XmlTools.node('input', lib));

		var sm = Xml.createElement('sourcemap');
		sm.addChild(XmlTools.node('input', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('output', '$outputPath$outputFile.map'));
		sm.addChild(XmlTools.node('url', '$outputFile.map'));
		sm.addChild(XmlTools.node('source', outputFile));
		debug.addChild(sm);

		xml.addChild(debug);

		for (lib in libs) xml.addChild(XmlTools.node('input', lib));

		xml.addChild(XmlTools.node('input', outputPath + outputFile));
		xml.addChild(XmlTools.node('output', outputPath + outputFile));

		return xml;
	}

}