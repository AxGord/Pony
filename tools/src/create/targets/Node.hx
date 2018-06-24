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

import types.NpmPackage;

using pony.Tools;
using Reflect;

class Node {

	public static var NPM_PACKAGE_FILE:String = 'package.json';

	public static function set(project:Project):Void {
		project.server.active = true;
		project.server.haxe = true;
		project.haxelib.active = true;
		project.haxelib.addLib('pony', Utils.ponyHaxelibVersion);
		project.haxelib.addLib('hxnodejs', '4.0.9');
		project.build.active = true;
		project.build.target = types.HaxeTargets.JS;
		project.build.esVersion = 6;
		//project.setRun('node');
		project.uglify.active = true;
	}

	public static function createNpmPackage(project:Project, ?dependencies:Map<String, String>, ?devDependencies:Map<String, String>):NpmPackage {
		var r:NpmPackage = {
			name: project.rname,
			version: '0.0.1',
			main: project.build.getOutputFile(),
			build: {
				productName: project.rname
			}
		}
		if (dependencies != null)
			r.setField('dependencies', dependencies.toDynamic());
		if (devDependencies != null)
			r.setField('devDependencies', devDependencies.toDynamic());
		return r;
	}

	public static function createAndSaveNpmPackageToOutputDir(project:Project, ?dependencies:Map<String, String>, ?devDependencies:Map<String, String>):Void {
		Utils.saveJson(project.build.outputPath + NPM_PACKAGE_FILE, createNpmPackage(project, dependencies, devDependencies));
	}

}