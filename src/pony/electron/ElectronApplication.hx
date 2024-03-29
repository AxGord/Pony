package pony.electron;

import electron.main.App;
import electron.main.BrowserWindow;

import js.Node;

import pony.Tools;
import pony.magic.HasAbstract;
import pony.text.TextTools;

/**
 * ElectronApplication
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) abstract #end
class ElectronApplication extends VSTraceHelper implements HasAbstract {

	public var windows(default, null): Map<String, BrowserWindow> = new Map<String, BrowserWindow>();

	private var windowsPath: String;
	private var windowsExt: String;
	private var macnoexit: Bool;

	private function new(
		windowsPath: String = '', windowsExt: String = '.html', macnoexit: Bool = false, disableHardwareAcceleration: Bool = false
	) {
		super();
		this.windowsPath = windowsPath;
		this.windowsExt = windowsExt;
		this.macnoexit = macnoexit && Node.process.platform == 'darwin';
		Node.process.env['ELECTRON_DISABLE_SECURITY_WARNINGS'] = 'true';
		log('Build date: ' + Tools.getBuildDate());
		log('Platform: ' + Node.process.platform);
		if (this.macnoexit) log('Mac OS keep opened');
		App.on('ready', readyHandler);
		if (!this.macnoexit) {
			App.on('window-all-closed', closeAllHandler);
		} else {
			App.on('window-all-closed', Tools.nullFunction1);
			App.on('activate', activateHandler);
		}
		if (disableHardwareAcceleration) {
			log('Disable Hardware Acceleration');
			App.disableHardwareAcceleration();
			App.commandLine.appendSwitch('disable-software-rasterizer');
		}
	}

	private function readyHandler(_): Void init();
	private function init(): Void createMainWindow();
	@:abstract private function createMainWindow(): Void;

	public function createWindow(url: String, ?id: String, ?opt): BrowserWindow {
		if (id == null) id = url;
		if (windows.exists(id)) {
			error('Windows already created, ignore create again');
			return windows[id];
		}
		var win: BrowserWindow = new BrowserWindow(opt);
		windows[id] = win;
		log('Create window: $id ($url)');
		win.on(closed, function() {
			windows.remove(id);
			log('Close window: $id ($url)');
		});
		var path: String = js.Node.__dirname + '/' + windowsPath + url + windowsExt;
		path = sys.FileSystem.absolutePath(path);
		win.loadURL('file://' + path);
		// win.webContents.openDevTools();
		return win;
	}

	public function closeWindow(id: String): Void {
		if (!windows.exists(id)) return;
		windows[id].close();
		windows.remove(id);
	}

	private function closeAllHandler(_): Void {
		log('All windows closed, exit');
		App.quit();
	}

	private function activateHandler(_): Void {
		log('Activate');
		if (Lambda.count(windows) == 0) createMainWindow();
	}

	public function mapCreateWindow(map: Map<String, String>, ?id: String): BrowserWindow {
		var frame: Bool = !TextTools.isFalse(map['frame']);
		return createWindow(map['name'], id, {
			width: Std.parseInt(map['width']),
			height: Std.parseInt(map['height']),
			frame: frame,
			titleBarStyle: frame ? null : 'hiddenInset',
			fullscreen: map.exists('fullscreen') ? TextTools.isTrue(map['fullscreen']) : null,
			fullscreenable: true,
			resizable: !TextTools.isFalse(map['resizable']),
			minWidth: Std.parseInt(map['minWidth']),
			minHeight: Std.parseInt(map['minHeight']),
			backgroundColor: map['background'],
			webPreferences: {
				nodeIntegration: true,
				contextIsolation: false
			}
		});
	}

	public inline function mapCloseWindow(map: Map<String, String>): Void return closeWindow(map['name']);

}