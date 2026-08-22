package magic;

import massive.munit.Assert;
import pony.events.Event0;
import pony.events.Event1;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasListener;
import pony.magic.HasSignal;

enum abstract Phase(Int) {

	final Idle;
	final Ground;
	final Air;

}

class HasListenerTest {

	@Test
	public function testListenAndUnlisten(): Void {
		final clock: Event0 = new Event0();
		final keys: Event1<Int> = new Event1<Int>();
		final target: Plain = new Plain(clock, keys);
		clock.dispatch();
		keys.dispatch(1);
		keys.dispatch(2);
		Assert.areEqual('tick,key,key', target.log.join(','));
		target.destroy();
		clock.dispatch();
		keys.dispatch(1);
		Assert.areEqual('tick,key,key', target.log.join(','));
	}

	@Test
	public function testConditionFollowsState(): Void {
		final clock: Event0 = new Event0();
		final target: Machine = new Machine(clock);
		clock.dispatch();
		Assert.areEqual('', target.log.join(','));
		target.phase = Phase.Air;
		clock.dispatch();
		clock.dispatch();
		// `cut` shares the Air phase and is spent on the first dispatch of the visit.
		Assert.areEqual('fly,cut,fly', target.log.join(','));
		target.phase = Phase.Ground;
		clock.dispatch();
		Assert.areEqual('fly,cut,fly,run', target.log.join(','));
	}

	/**
	 * A conditional `@:listenOnce` re-arms on every entry into the state, so it fires once per
	 * visit rather than once per lifetime.
	 */
	@Test
	public function testListenOnceReArmsPerVisit(): Void {
		final clock: Event0 = new Event0();
		final target: Machine = new Machine(clock);
		target.phase = Phase.Air;
		clock.dispatch();
		clock.dispatch();
		Assert.areEqual('fly,cut,fly', target.log.join(','));
		target.phase = Phase.Ground;
		clock.dispatch();
		target.phase = Phase.Air;
		clock.dispatch();
		Assert.areEqual('fly,cut,fly,run,fly,cut', target.log.join(','));
	}

	/** Every bindable in the condition drives the re-check, not just the first one. */
	@Test
	public function testCompoundCondition(): Void {
		final clock: Event0 = new Event0();
		final target: Compound = new Compound(clock);
		clock.dispatch();
		Assert.areEqual('air', target.take());
		target.running = true;
		clock.dispatch();
		Assert.areEqual('air', target.take());
		target.grounded = true;
		clock.dispatch();
		Assert.areEqual('both', target.take());
		target.running = false;
		clock.dispatch();
		Assert.areEqual('', target.take());
		target.running = true;
		clock.dispatch();
		Assert.areEqual('both', target.take());
		target.grounded = false;
		clock.dispatch();
		Assert.areEqual('air', target.take());
	}

	/** A constant in the condition is not a bindable and must not be tracked. */
	@Test
	public function testConditionWithConstant(): Void {
		final clock: Event0 = new Event0();
		final target: Compound = new Compound(clock);
		target.running = true;
		target.count = Compound.LIMIT;
		clock.dispatch();
		Assert.areEqual('air', target.take());
		target.count = Compound.LIMIT + 1;
		clock.dispatch();
		Assert.areEqual('air,over', target.take());
		target.running = false;
		clock.dispatch();
		Assert.areEqual('air', target.take());
	}

	/** The condition may read a bindable of another object through a field. */
	@Test
	public function testConditionThroughField(): Void {
		final clock: Event0 = new Event0();
		final horse: Horse = new Horse();
		final target: Rider = new Rider(clock, horse);
		clock.dispatch();
		Assert.areEqual('', target.log.join(','));
		horse.phase = Phase.Ground;
		clock.dispatch();
		Assert.areEqual('ride', target.log.join(','));
		horse.phase = Phase.Idle;
		clock.dispatch();
		Assert.areEqual('ride', target.log.join(','));
	}

	/** Lower priority runs earlier, whatever the declaration order. */
	@Test
	public function testPriorityOrdersHandlers(): Void {
		final clock: Event0 = new Event0();
		final target: Ordered = new Ordered(clock);
		clock.dispatch();
		Assert.areEqual('early,mid,late', target.log.join(','));
	}

}

/** One handler over several signals, and `unlisten` through the generated `destroy`. */
private class Plain implements HasListener {

	public final log: Array<String> = [];

	private var clock: Signal0;
	private var keys: Signal1<Int>;

	public function new(clock: Event0, keys: Event1<Int>) {
		this.clock = clock;
		this.keys = keys;
	}

	@:listen(clock) private function tick(): Void log.push('tick');

	@:listen(keys - 1)
	@:listen(keys - 2)
	private function key(): Void log.push('key');

}

/** `phase` is the whole state machine: each handler exists only while its phase is current. */
private class Machine implements HasSignal implements HasListener {

	public final log: Array<String> = [];

	@:bindable public var phase: Phase = Phase.Idle;

	private var clock: Signal0;

	public function new(clock: Event0) this.clock = clock;

	@:listen(clock, phase == Phase.Air) private function fly(): Void log.push('fly');

	@:listen(clock, phase == Phase.Ground) private function run(): Void log.push('run');

	@:listenOnce(clock, phase == Phase.Air) private function cut(): Void log.push('cut');

}

private class Compound implements HasSignal implements HasListener {

	public static inline final LIMIT: Int = 3;

	@:bindable public var running: Bool = false;
	@:bindable public var grounded: Bool = false;
	@:bindable public var count: Int = 0;

	private final log: Array<String> = [];

	private var clock: Signal0;

	public function new(clock: Event0) this.clock = clock;

	/** Reads the log and empties it, so every assertion covers exactly one dispatch. */
	public function take(): String {
		final result: String = log.join(',');
		log.resize(0);
		return result;
	}

	@:listen(clock, running && grounded) private function both(): Void log.push('both');

	@:listen(clock, !grounded) private function air(): Void log.push('air');

	@:listen(clock, running && count > LIMIT) private function over(): Void log.push('over');

}

private class Horse implements HasSignal implements HasListener {

	@:bindable public var phase: Phase = Phase.Idle;

	public function new() {}

}

private class Rider implements HasSignal implements HasListener {

	public final log: Array<String> = [];

	private var clock: Signal0;
	private var horse: Horse;

	public function new(clock: Event0, horse: Horse) {
		this.clock = clock;
		this.horse = horse;
	}

	@:listen(clock, horse.phase != Phase.Idle) private function ride(): Void log.push('ride');

}

/** Declared late to early on purpose — priority, not declaration order, decides. */
private class Ordered implements HasListener {

	public final log: Array<String> = [];

	private var clock: Signal0;

	public function new(clock: Event0) this.clock = clock;

	@:listen(clock, priority = 10) private function late(): Void log.push('late');

	@:listen(clock) private function mid(): Void log.push('mid');

	@:listen(clock, priority = -10) private function early(): Void log.push('early');

}
