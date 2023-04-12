package module;

import types.RemoteConfig;
import remote.client.RemoteClient;

/**
 * Remote Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Remote extends NModule<RemoteConfig> {

	#if (haxe_ver < 4.2) override #end
	private function run(cfg: RemoteConfig): Void {
		tasks.add();
		var remote: RemoteClient = new RemoteClient(cfg);
		remote.onError << eError;
		remote.onLog << eLog;
		remote.onComplete < tasks.end;
		remote.init();
	}

}