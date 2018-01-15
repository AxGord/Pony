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
import haxe.xml.Fast;
import pony.text.XmlConfigReader;
import types.BAConfig;
import types.BASection;

class BAReader<T:BAConfig> extends XmlConfigReader<T> implements pony.magic.HasAbstract {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'before':
				var cfg = copyCfg();
				cfg.before = true;
				_selfCreate(xml, cfg);
			case 'after':
				var cfg = copyCfg();
				cfg.before = false;
				_selfCreate(xml, cfg);
			case 'server': createSection(xml, Server);
			case 'prepare': createSection(xml, Prepare);
			case 'build': createSection(xml, Build);
			case 'run': createSection(xml, Run);
			case 'zip': createSection(xml, Zip);
			case 'hash': createSection(xml, Hash);

			case _: throw 'Unknown tag';
		}
	}

	private function createSection(xml:Fast, section:BASection):Void {
		var cfg = copyCfg();
		clean();
		cfg.section = section;
		_selfCreate(xml, cfg);
	}

	@:abstract private function clean():Void;

	override private function end():Void onConfig(cfg);

}