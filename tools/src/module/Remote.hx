package module;

import sys.io.File;
import sys.FileSystem;

/**
 * Remote module
 * @author AxGord <axgord@gmail.com>
 */
class Remote extends Module {

	public function new() super('remote');

	override public function init():Void {
		if (xml == null) return;
		modules.commands.onRemote << run;
	}

	private function run(a:String, b:String):Void {
		var log = 'log.txt';
		if (FileSystem.exists(log))
			FileSystem.deleteFile(log);
		var code = Utils.runNode('ponyRemote', b != null ? [a, b] : (a != null ? [a] : []));
		if (code > 0) {
			if (FileSystem.exists(log)) {
				Sys.println(File.getContent(log));
			}
			Utils.error('Server build error', code);
		}
	}

}