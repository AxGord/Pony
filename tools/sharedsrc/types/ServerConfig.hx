package types;

typedef ServerConfig = {
	> BAConfig,
	port: Null<UInt>,
	path: Null<String>,
	proxy: Array<ProxyConfig>,
	haxe: Null<UInt>,
	remote: Null<RemoteServerConfig>
}