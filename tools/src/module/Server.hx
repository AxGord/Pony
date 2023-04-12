package module;

import pony.Fast;
import pony.Pair;

import types.BAConfig;
import types.BASection;
import types.ProxyConfig;
import types.RemoteServerConfig;
import types.ServerConfig;
import types.SniffConfig;

using pony.text.XmlTools;

/**
 * Server module
 * @author AxGord <axgord@gmail.com>
 */
class Server extends NModule<ServerConfig> {

	private static inline var PRIORITY: Int = 0;

	public function new() super('server');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void {
		if (xml == null) return;
		initSections(PRIORITY, BASection.Server);
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ServerReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Server,
			allowCfg: true,
			port: null,
			path: null,
			proxy: [],
			haxe: null,
			remote: null,
			sniff: null,
			cordova: false
		}, configHandler);
	}

	#if (haxe_ver < 4.2) override #end
	private function writeCfg(protocol: NProtocol, cfg: Array<ServerConfig>): Void {
		protocol.serverRemote(cfg);
	}

}

private class ServerReader extends BAReader<ServerConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.port = null;
		cfg.path = null;
		cfg.proxy = [];
		cfg.haxe = null;
		cfg.remote = null;
		cfg.sniff = null;
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path':
				cfg.path = normalize(xml.innerData);
			case 'port':
				cfg.port = Std.parseInt(xml.innerData);
			case 'haxe':
				cfg.haxe = Std.parseInt(xml.innerData);
			case 'proxy':
				new ProxyReader(xml, {
					debug: cfg.debug,
					app: cfg.app,
					before: cfg.before,
					section: cfg.section,
					allowCfg: true,
					target: null,
					port: null,
					slow: null,
					cache: null,
					cordova: false
				}, proxyConfigHandler);
			case 'remote':
				new RemoteReader(xml, {
					debug: cfg.debug,
					app: cfg.app,
					before: cfg.before,
					section: cfg.section,
					allowCfg: true,
					port: null,
					key: null,
					allow: [],
					commands: new Map(),
					cordova: false
				}, remoteConfigHandler);
			case 'sniff':
				new SniffReader(xml, {
					debug: cfg.debug,
					app: cfg.app,
					before: cfg.before,
					section: cfg.section,
					allowCfg: true,
					serverPort: 0,
					clientHost: null,
					clientPort: 0,
					cordova: false
				}, sniffConfigHandler);
			case _:
				super.readNode(xml);
		}
	}

	private function proxyConfigHandler(proxy: BAProxyConfig): Void {
		cfg.proxy.push(proxy);
	}

	private function remoteConfigHandler(remote: BARemoteServerConfig): Void {
		cfg.remote = remote;
	}

	private function sniffConfigHandler(sniff: BASniffConfig): Void {
		cfg.sniff = sniff;
	}

}

typedef BAProxyConfig = {
	> BAConfig,
	> ProxyConfig,
}

private class ProxyReader extends BAReader<BAProxyConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.target = null;
		cfg.port = null;
		cfg.slow = null;
		cfg.cache = null;
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'target': cfg.target = normalize(xml.innerData);
			case 'port': cfg.port = Std.parseInt(xml.innerData);
			case _:
				super.readNode(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'slow': cfg.slow = Std.parseInt(val);
			case 'cache': cfg.cache = val;
			case _:
		}
	}

}

typedef BARemoteServerConfig = {
	> BAConfig,
	> RemoteServerConfig,
}

private class RemoteReader extends BAReader<BARemoteServerConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.port = null;
		cfg.key = null;
		cfg.allow = [];
		cfg.commands = new Map();
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'port':
				cfg.port = Std.parseInt(xml.innerData);
			case 'key':
				cfg.key = normalize(xml.innerData);
			case 'allow':
				cfg.allow.push(normalize(xml.innerData));
			case 'commands':
				for (node in xml.elements) {
					var d: Pair<Bool, String> = new Pair(!node.isFalse('zipLog'), normalize(node.innerData));
					if (!cfg.commands.exists(node.name))
						cfg.commands[node.name] = [d];
					else
						cfg.commands[node.name].push(d);
				}
			case _:
				super.readNode(xml);
		}
	}

}

typedef BASniffConfig = {
	> BAConfig,
	> SniffConfig,
}

private class SniffReader extends BAReader<BASniffConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.serverPort = 0;
		cfg.clientHost = '';
		cfg.clientPort = 0;
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'server':
				cfg.serverPort = Std.parseInt(xml.innerData);
			case 'client':
				var a: Array<String> = normalize(xml.innerData).split(':');
				if (a.length == 1) {
					cfg.clientHost = '127.0.0.1';
					cfg.clientPort = Std.parseInt(a[0]);
				} else {
					cfg.clientHost = a[0];
					cfg.clientPort = Std.parseInt(a[1]);
				}
			case _:
				super.readNode(xml);
		}
	}

}