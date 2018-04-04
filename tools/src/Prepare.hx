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
package;
import haxe.xml.Fast;

/**
 * Prepare
 * @author AxGord <axgord@gmail.com>
 */
class Prepare {

	public function new(xml:Fast, app:String, debug:Bool) {
		if (sys.FileSystem.exists('libcache.js')) sys.FileSystem.deleteFile('libcache.js');
		if (xml.hasNode.haxelib) {
			Sys.println('update haxelib');
			for (node in xml.node.haxelib.nodes.lib) {
				var args = ['install'];
				args = args.concat(node.innerData.split(' '));
				args.push('--always');
				Sys.command('haxelib', args);
			}
		}

		if (xml.hasNode.npm) {
			var cwd = new Cwd(xml.node.npm.has.path ? xml.node.npm.att.path : null);
			Sys.println('install npm');
			cwd.sw();
			for (module in xml.node.npm.nodes.module) {
				Sys.command('npm', ['install', module.innerData, '--prefix', './']);
			}
			cwd.sw();
		}

		if (!Flags.NOTP && xml.hasNode.texturepacker)
			new Texturepacker(xml.node.texturepacker, app, debug);
			
		//if (xml.hasNode.build) try {
		//	new Build(xml, app, debug).writeConfigIfNeed();
		//} catch (e:String) {
		//	Sys.println(e);
		//}
	}
	
}