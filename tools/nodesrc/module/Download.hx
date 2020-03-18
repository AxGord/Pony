package module;

import js.lib.Error;
import js.node.http.IncomingMessage;
import js.node.Fs;
import js.node.Http;
import js.node.Https;
import sys.FileSystem;
import sys.io.File;
import pony.Pair;
import types.DownloadConfig;

using pony.text.TextTools;

/**
 * Download Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Download extends NModule<DownloadConfig> {

	override private function run(cfg: DownloadConfig): Void {
		var downloadList: Array<Pair<String, String>> = [];

		for (unit in cfg.units) {
			var file: String = cfg.path + unit.a.split('/').pop();
			var needDownload: Bool = false;
			if (unit.b != null && FileSystem.exists(file)) {
				needDownload = sys.io.File.getContent(file).indexOf(unit.b) == -1;
			} else {
				needDownload = unit.c || !FileSystem.exists(file);
			}
			if (needDownload) downloadList.push(new Pair(file, unit.a));
		}
		for (file in downloadList) {
			log('Download ' + file.b);
			tasks.add();
			var protocol: String = file.b.substr(0, 7);
			switch protocol {
				case 'https:/':
					Https.get(file.b, { timeout: 7000 }, function(response: IncomingMessage): Void {
						response.once('end', tasks.end);
						response.pipe(Fs.createWriteStream(file.a));
					}).on('error', function(e: Error) {
						error('problem with request: ' + e.message);
					});
				case 'http://':
					Http.get(file.b, { timeout: 7000 }, function(response: IncomingMessage): Void {
						response.once('end', tasks.end);
						response.pipe(Fs.createWriteStream(file.a));
					}).on('error', function(e: Error) {
						error('problem with request: ' + e.message);
					});
				case _:
					error('Unsupported protocol: $protocol');
			}
		}
	}

}