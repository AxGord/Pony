package types;

import pony.Pair;

typedef RemoteServerConfig = {
	port: Null<UInt>,
	key: Null<String>,
	allow: Array<String>,
	commands: Map<String, Array<Pair<Bool, String>>>
}