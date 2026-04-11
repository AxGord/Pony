package pony.magic;

/**
 * AsyncDestroy
 *
 * Marker interface for classes whose destruction involves async work (flushing buffers,
 * closing connections, waiting for in-flight operations). Implementations call `cb` when
 * teardown is fully complete.
 *
 * When combined with `DI`, the class's subtree auto-propagates async: any DI parent of an
 * AsyncDestroy child must also implement AsyncDestroy. DIBuilder enforces this at compile
 * time and generates the destroyAsync coordination via `pony.Tasks`.
 *
 * Leaf classes (AsyncDestroy with no @:service children) own their destroyAsync body
 * completely — framework does not inject teardown or cb-firing code.
 *
 * @author AxGord <axgord@gmail.com>
 */
interface AsyncDestroy {

	public function destroyAsync(cb: () -> Void): Void;

}
