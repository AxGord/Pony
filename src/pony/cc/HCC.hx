package pony.cc;

import cc.Cc;
import pony.time.DeltaTime;

/**
 * Cocos Creator Helper
 * @author AxGord <axgord@gmail.com>
 */
@:keep class HCC {

	private var node: Node;

	public function new(node: Node) {
		this.node = node;
		load();
	}

	public function update(dt: Float): Void {
		DeltaTime.fixedValue = dt;
		DeltaTime.fixedDispatch();
	}

	public function load(): Void {}
	public function start(): Void {}

}