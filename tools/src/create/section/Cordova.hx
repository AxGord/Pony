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
import types.*;

class Cordova extends Section {

	public var title:String = null;
	public var versionBuildDate:Bool = true;
	public var androidVersionIncrement:Bool = true;

	public function new() super('cordova');

	public function result():Xml {
		init();

		if (title != null) add('id', 'org.apache.cordova.pony.' + StringTools.replace(title, ' ', ''));

		if (versionBuildDate) {
			var version = Xml.createElement('version');
			version.set('buildDate', 'true');
			xml.addChild(version);
		}

		if (title != null || androidVersionIncrement) {
			var release = Xml.createElement('release');
			if (title != null) release.addChild(XmlTools.node('name', title));
			if (androidVersionIncrement) {
				var av = Xml.createElement('androidVersionCode');
				av.set('increment', 'true');
				release.addChild(av);
			}
			xml.addChild(release);
		}

		if (title != null) {
			var debug = Xml.createElement('debug');
			debug.addChild(XmlTools.node('name', title + ' Debug'));
			xml.addChild(debug);
		}

		return xml;
	}

}