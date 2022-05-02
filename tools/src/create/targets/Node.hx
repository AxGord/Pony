package create.targets;

import types.NpmPackage;

using pony.Tools;
using Reflect;

/**
 * Node
 * @author AxGord <axgord@gmail.com>
 */
class Node {

	public static var NPM_PACKAGE_FILE:String = 'package.json';

	public static function set(project:Project):Void {
		project.server.active = true;
		project.server.haxe = true;
		project.haxelib.active = true;
		project.haxelib.addLib({name: 'pony', version: Utils.ponyHaxelibVersion});
		project.haxelib.addLib({name: 'hxnodejs', version: '12.1.0'});
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