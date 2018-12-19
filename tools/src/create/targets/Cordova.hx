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
package create.targets;

import pony.fs.Dir;
import pony.text.TextTools;

class Cordova {

	private static inline var CORDOVA:String = 'cordova';
	private static inline var DSS:String = '.DS_Store';
	private static inline var DRW:String = 'drawable-';

	public static function set(project:Project):Void {
		Pixi.set(project);
		project.cordova.active = true;
		project.build.outputPath = 'www/';
		project.server.httpPath = 'www/';

		var c = ('.':Dir).content();
		if (c.length == 1 && c[0].name == DSS) {
			Sys.println('Remove $DSS');
			c[0].delete(); // Can't create cordova if dir have .DS_Store
		}

		if (project.name == null) {
			Utils.command(CORDOVA, ['create', '.', 'org.apache.cordova.pony.App', 'App']);
		} else {
			var cl:String = TextTools.bigFirst(project.name);
			Utils.command(CORDOVA, ['create', '.', 'org.apache.cordova.pony.$cl', cl]);
		}

		Sys.println('Clean res/');
		var screenDir:Dir = 'res/screen/';
		screenDir.deleteContent();
		screenDir.delete();
		var iconDir:Dir = 'res/icon/';
		iconDir.deleteContent();

		//todo: pony prepare for add platforms
		Utils.command(CORDOVA, ['platform', 'add', 'android']);
		var resPath:Dir = 'platforms/android/app/src/main/res/';
		for (dir in resPath.dirs()) if (dir.name.substr(0, DRW.length) == DRW) dir.delete();
		Utils.command(CORDOVA, ['platform', 'add', 'ios']);
		(project.build.outputPath:Dir).deleteContent();
	}

}