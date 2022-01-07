package module;

import pony.Fast;

import types.BASection;
import types.FtpConfig;

/**
 * Ftp module
 * @author AxGord <axgord@gmail.com>
 */
class Ftp extends NModule<FtpConfig> {

	private static inline var PRIORITY: Int = 34;

	public function new() super('ftp');

	override public function init(): Void initSections(PRIORITY, BASection.Ftp);

	override private function readNodeConfig(xml: Fast, ac: AppCfg):Void {
		new FtpReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Ftp,
			path: '',
			user: 'anonymous',
			pass: 'anonymous@',
			host: 'host',
			port: 21,
			output: '',
			input: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function writeCfg(protocol: NProtocol, cfg: Array<FtpConfig>): Void {
		protocol.ftpRemote(cfg);
	}

}

private class FtpReader extends BAReader<FtpConfig> {

	override private function clean(): Void {
		cfg.path = '';
		cfg.user = 'anonymous';
		cfg.pass = 'anonymous@';
		cfg.host = 'localhost';
		cfg.port = 21;
		cfg.output = '';
		cfg.input = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = val;
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': cfg.path = normalize(xml.innerData);
			case 'user': cfg.user = normalize(xml.innerData);
			case 'pass': cfg.pass = normalize(xml.innerData);
			case 'host':
				var a: Array<String> = normalize(xml.innerData).split(':');
				cfg.host = a[0];
				if (a.length > 1)
					cfg.port = Std.parseInt(a[1]);
			case 'port': cfg.port = Std.parseInt(xml.innerData);
			case 'output': cfg.output = normalize(xml.innerData);
			case 'input': cfg.input.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

}