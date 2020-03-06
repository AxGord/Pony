package module;

import pony.magic.HasAbstract;
import pony.Logable;
import pony.Tasks;
import pony.events.Signal0;

/**
 * NModule
 * @author AxGord <axgord@gmail.com>
 */
class NModule<T> extends Logable implements HasAbstract {

	@:auto public var onFinish:Signal0;

	private var config:Array<T>;
	private var tasks:Tasks;

	public function new(cfg:Array<T>) {
		if (cfg == null) return;
		super();
		config = cfg;
		tasks = new Tasks(finishTasksHandler);
	}

	public function start():Void {
		log('Start ' + Type.getClassName(Type.getClass(this)));
		if (config != null) {
			tasks.add();
			for (e in config) run(e);
			tasks.end();
		}
	}

	private function finishTasksHandler():Void eFinish.dispatch();

	@:abstract private function run(cfg:T):Void;

}