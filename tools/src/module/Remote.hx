package module;

import pony.Fast;

import types.BASection;
import types.RemoteConfig;

/**
 * Remote module
 * @author AxGord <axgord@gmail.com>
 */
class Remote extends NModule<RemoteConfig> {

	private static inline var PRIORITY: Int = 0;

	public function new() super('remote');

	override public function init():Void {
		if (xml == null) return;
		initSections(PRIORITY, BASection.Remote);
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new RemoteConfigReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Remote,
			allowCfg: true,
			host: null,
			port: null,
			key: null,
			commands: [],
			cordova: false
		}, configHandler);
	}

	override private function writeCfg(protocol: NProtocol, cfg: Array<RemoteConfig>): Void {
		protocol.remoteRemote(cfg);
	}

}

private class RemoteConfigReader extends BAReader<RemoteConfig> {

	override private function clean(): Void {
		cfg.host = null;
		cfg.port = null;
		cfg.key = null;
		cfg.commands = [];
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'host': cfg.host = normalize(xml.innerData);
			case 'port': cfg.port = Std.parseInt(xml.innerData);
			case 'key': cfg.key = normalize(xml.innerData);

			case 'get': cfg.commands.push(Get(normalize(xml.innerData)));
			case 'send': cfg.commands.push(Send(normalize(xml.innerData)));
			case 'exec': cfg.commands.push(Exec(normalize(xml.innerData)));
			case 'command': cfg.commands.push(Command(normalize(xml.innerData)));

			case _: super.readNode(xml);
		}
	}

}