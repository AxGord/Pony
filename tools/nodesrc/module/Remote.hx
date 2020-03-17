package module;

import types.RemoteConfig;
import remote.client.RemoteClient;

/**
 * Remote Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
class Remote extends NModule<RemoteConfig> {

	override private function run(cfg: RemoteConfig): Void {
		tasks.add();
		var remote: RemoteClient = new RemoteClient(cfg);
		remote.onError << eError;
		remote.onLog << eLog;
		remote.onComplete < tasks.end;
		remote.init();
	}

}