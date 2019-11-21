package create.ides;

import sys.FileSystem;

/**
 * VSCode
 * @author AxGord <axgord@gmail.com>
 */
class VSCode {

	private static inline var PRELAUNCH_TASK:String = 'default';
	private static inline var ANDROID_TASK:String = 'pony android';
	private static inline var IPHONE_TASK:String = 'pony iphone';

	public static var allowCreate(get, never):Bool;

	private static var cordova:Bool = false;

	private static function get_allowCreate():Bool return !FileSystem.exists('.vscode');

	public static function createDir():Void FileSystem.createDirectory('.vscode');

	public static function create(ponycmd:String, auto:Bool = false):Void {
		var tasks:Array<Any> = [];
		var matcher: Array<String> = ["$haxe-absolute", "$haxe", "$haxe-error", "$haxe-trace"];

		if (ponycmd != null)
			tasks.push({
				runOptions: {runOn: auto ? 'folderOpen' : 'default'},
				label: PRELAUNCH_TASK,
				type: 'shell',
				command: 'pony $ponycmd debug',
				group: {
					kind: 'build',
					isDefault: true
				},
				problemMatcher: matcher
			});

		if (cordova) {
			tasks.push({
				label: ANDROID_TASK,
				type: 'shell',
				command: 'pony android debug',
				problemMatcher: matcher
			});
			tasks.push({
				label: IPHONE_TASK,
				type: 'shell',
				command: 'pony iphone debug',
				problemMatcher: matcher
			});
		}

		tasks.push({
			label: 'server',
			type: 'shell',
			command: 'pony server',
			isBackground: true,
			runOptions: {runOn: 'folderOpen'},
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

	public static function createExtensions(chrome: Bool): Void {
		var data: Array<String> = [
			'nadako.vshaxe',
			'vshaxe.haxe-checkstyle',
			'wiggin77.codedox'
		];
		if (cordova)
			data.push('msjsdiag.cordova-tools');
		if (chrome)
			data.push('msjsdiag.debugger-for-chrome');
		Utils.saveJson('.vscode/extensions.json', { recommendations: data });
	}

	public static function createNode(output:String, app:String):Void {
		saveConfig([
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
		]);
		createExtensions(false);
	}

	public static function createChrome(httpPort:Int):Void {
		saveConfig(chromeConfig(httpPort));
		createExtensions(true);
	}

	public static function createCordova(httpPort:Int):Void {
		cordova = true;
		saveConfig(chromeConfig(httpPort).concat([
			{
				"name": "Run Android on device",
				"preLaunchTask": "pony android",
				"type": "cordova",
				"request": "launch",
				"platform": "android",
				"target": "device",
				"port": 9222,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}",
				"ionicLiveReload": false
			},
			{
				"name": "Run iOS on device",
				"preLaunchTask": "pony iphone",
				"type": "cordova",
				"request": "launch",
				"platform": "ios",
				"target": "device",
				"port": 9220,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}",
				"ionicLiveReload": false
			},
			{
				"name": "Attach to running android on device",
				"type": "cordova",
				"request": "attach",
				"platform": "android",
				"target": "device",
				"port": 9222,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}"
			},
			{
				"name": "Attach to running iOS on device",
				"type": "cordova",
				"request": "attach",
				"platform": "ios",
				"target": "device",
				"port": 9220,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}"
			},
			{
				"name": "Run Android on emulator",
				"type": "cordova",
				"request": "launch",
				"preLaunchTask": "pony android",
				"platform": "android",
				"target": "emulator",
				"port": 9223,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}",
				"ionicLiveReload": false
			},
			{
				"name": "Run iOS on simulator",
				"type": "cordova",
				"request": "launch",
				"preLaunchTask": "pony iphone",
				"platform": "ios",
				"target": "emulator",
				"port": 9220,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}",
				"ionicLiveReload": false,
				"runArguments": ["--target=iPhone-6"]
			},
			{
				"name": "Attach to running android on emulator",
				"type": "cordova",
				"request": "attach",
				"platform": "android",
				"target": "emulator",
				"port": 9222,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}"
			},
			{
				"name": "Attach to running iOS on simulator",
				"type": "cordova",
				"request": "attach",
				"platform": "ios",
				"target": "emulator",
				"port": 9220,
				"sourceMaps": true,
				"cwd": "${workspaceFolder}"
			}
		]));
		createExtensions(true);
	}

	private static function chromeConfig(httpPort:Int):Array<Any> {
		var launch:String = 'Launch Chrome';
		return [
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
	}

	private static function saveConfig(configurations:Array<Any>):Void {
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
					internalConsoleOptions: 'neverOpen'
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
		createExtensions(true);
	}

}