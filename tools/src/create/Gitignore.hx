package create;

import sys.io.File;
import types.ProjectType;
import types.HaxeTargets;

class Gitignore {

	private static var OS: Array<String> = [
		'# OS generated files',
		'.DS_Store',
		'.DS_Store?',
		'._*',
		'.Spotlight-V100',
		'.Trashes',
		'ehthumbs.db',
		'Thumbs.db'
	];

	private static var GITIGNORE: String = '.gitignore';
	private static var HXML: String = '.hxml';
	private static var NODE_MODULES: String = 'node_modules/';
	private static var PACKAGE_LOCK: String = 'package-lock.json';
	private static var LIBCACHE: String = 'libcache.js';
	private static var ROOT: String = '/';
	private static var MAP: String = '.map';
	private static var NEWLINE: String = '\n';

	public static function create(project: Project, type: ProjectType): Void {
		var result: Array<String> = OS.copy();
		result.push('# Project files');
		if (project.build.active && project.build.hxml)
			result.push(ROOT + project.build.outputFile + HXML);
		if (project.secondbuild.active && project.secondbuild.hxml)
			result.push(ROOT + project.secondbuild.outputFile + HXML);
		if (project.build.active) {
			var output: String = project.build.output();
			result.push(ROOT + output);
			if (project.build.target == HaxeTargets.JS)
				result.push(ROOT + output + MAP);
		}
		if (project.secondbuild.active) {
			var output: String = project.secondbuild.output();
			result.push(ROOT + output);
			if (project.secondbuild.target == HaxeTargets.JS)
				result.push(ROOT + output + MAP);
		}
		if (project.download.active && project.download.list.length > 0)
			result.push(ROOT + project.download.path);
		if ((project.uglify.active && project.uglify.libcache) || (project.seconduglify.active && project.seconduglify.libcache))
			result.push(ROOT + LIBCACHE);
		switch type {
			case ProjectType.Pixielectron, ProjectType.Electron, ProjectType.Monacoelectron:
				result.push(ROOT + project.build.outputPath + NODE_MODULES);
				result.push(ROOT + project.build.outputPath + PACKAGE_LOCK);
			case ProjectType.Server: return;
			case ProjectType.Air:
				result.push(project.build.outputPath + project.build.outputFile + '.app'); // macos
				result.push(project.build.outputPath + project.build.outputFile + '/'); // windows
			case _:
		}
		Sys.println('Save gitignore file');
		File.saveContent(GITIGNORE, result.join(NEWLINE));
	}

}