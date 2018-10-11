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
package create.ides;

import sys.FileSystem;

class VSCode {

	private static inline var PRELAUNCH_TASK:String = 'default';

	public static var allowCreate(get, never):Bool;

	private static function get_allowCreate():Bool return !FileSystem.exists('.vscode');

	public static function createDir():Void FileSystem.createDirectory('.vscode');

	public static function create(ponycmd:String, auto:Bool = false):Void {
		var tasks:Array<Any> = [];

		if (ponycmd != null)
			tasks.push({
				auto: auto,
				identifier: PRELAUNCH_TASK,
				label: 'pony $ponycmd debug',
				type: 'shell',
				command: 'pony $ponycmd debug',
				group: {
					kind: 'build',
					isDefault: true
				},
				problemMatcher: ["$haxe"]
			});
		tasks.push({
			label: 'server',
			type: 'shell',
			command: 'pony server',
			isBackground: true,
			auto: true,
			presentation: {
				echo: false,
				reveal: 'silent',
				focus: false,
				panel: 'dedicated'
			}
		});

		var data = {
			version: '2.0.0',
			tasks: tasks
		};
		Utils.saveJson('.vscode/tasks.json', data);
	}

	public static function createNode(output:String, app:String):Void {
		var data = {
			version: '0.2.0',
			configurations: [
				{
					type: 'node',
					request: 'launch',
					name: 'Launch Program',
					program: "${workspaceFolder}/" + output + '/' + app,
					cwd: "${workspaceFolder}/" + output,
					preLaunchTask: PRELAUNCH_TASK,
					console: 'internalConsole',
					internalConsoleOptions: 'openOnSessionStart'
				}
			]
		};
		Utils.saveJson('.vscode/launch.json', data);
	}

	public static function createChrome(httpPort:Int):Void {
		var launch:String = 'Launch Chrome';
		var configurations:Array<Any> = [
			{
				type: 'chrome',
				request: 'launch',
				name: launch,
				url: 'http://localhost:$httpPort',
				webRoot: "${workspaceRoot}",
				preLaunchTask: PRELAUNCH_TASK,
				internalConsoleOptions: 'openOnSessionStart',
				breakOnLoad: true
			}
		];
		
		var data = {
			version: '0.2.0',
			configurations: configurations
		};
		Utils.saveJson('.vscode/launch.json', data);
	}

	public static function createElectron(output:String):Void {
		var confNamePrefix:String = 'Electron: ';
		var mainConfName:String = confNamePrefix + 'Main';
		var renderConfName:String = confNamePrefix + 'Renderer';
		var resultDir:String = "${workspaceFolder}/" + output;
		var electronExecutable:String = resultDir + 'node_modules/.bin/electron';
		var port:Int = 9222;
		var data = {
			version: '0.2.0',
			configurations: [
				({
					type: 'node',
					request: 'launch',
					name: mainConfName,
					protocol: 'inspector',
					runtimeExecutable: electronExecutable,
					runtimeArgs: [
						output,
						'--remote-debugging-port=$port'
					],
					windows: {
						runtimeExecutable: electronExecutable + '.cmd'
					},
					preLaunchTask: PRELAUNCH_TASK,
					internalConsoleOptions: 'openOnSessionStart'
				}:Dynamic),
				({
					name: renderConfName,
					type: 'chrome',
					request: 'attach',
					port: port,
					webRoot: resultDir,
					timeout: 20000,
					internalConsoleOptions: 'openOnSessionStart'
				}:Dynamic)
			],
			compounds: [
				{
					name: confNamePrefix + 'All',
					configurations: [mainConfName, renderConfName]
				}
			]
		};
		Utils.saveJson('.vscode/launch.json', data);
	}

}