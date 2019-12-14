package pony.events;

private enum PairType {
	S0(p: Pair<Signal0, Listener0>);
	S1<T1>(p: Pair<Signal1<T1>, Listener1<T1>>);
	S2<T1, T2>(p: Pair<Signal2<T1, T2>, Listener2<T1, T2>>);
}

/**
 * SignalAndListener
 * @author AxGord <axgord@gmail.com>
 */
private abstract SignalAndListener(PairType) {

	@:extern private inline function new(p: PairType) this = p;

	@:from @:extern static inline function s0(p: Pair<Signal0, Listener0>): SignalAndListener {
		return new SignalAndListener(S0(p));
	}

	@:from @:extern static inline function s0f(p: Pair<Signal0, Void -> Void>): SignalAndListener {
		return s0(new Pair(p.a, (p.b: Listener0)));
	}

	@:from @:extern static inline function s0e(p: Pair<Signal0, Event0>): SignalAndListener {
		return s0(new Pair(p.a, (p.b: Listener0)));
	}

	@:from @:extern static inline function s1<T1>(p: Pair<Signal1<T1>, Listener1<T1>>): SignalAndListener {
		return new SignalAndListener(S1(p));
	}

	@:from @:extern static inline function s1f<T1>(p: Pair<Signal1<T1>, T1 -> Void>): SignalAndListener {
		return s1(new Pair(p.a, (p.b: Listener1<T1>)));
	}

	@:from @:extern static inline function s1e<T1>(p: Pair<Signal1<T1>, Event1<T1>>): SignalAndListener {
		return s1(new Pair(p.a, (p.b: Listener1<T1>)));
	}

	@:from @:extern static inline function s2<T1, T2>(p: Pair<Signal2<T1, T2>, Listener2<T1, T2>>): SignalAndListener {
		return new SignalAndListener(S2(p));
	}

	@:from @:extern static inline function s2f<T1, T2>(p: Pair<Signal2<T1, T2>, T1 -> T2 -> Void>): SignalAndListener {
		return s2(new Pair(p.a, (p.b: Listener2<T1, T2>)));
	}

	@:from @:extern static inline function s2e<T1, T2>(p: Pair<Signal2<T1, T2>, Event2<T1, T2>>): SignalAndListener {
		return s2(new Pair(p.a, (p.b: Listener2<T1, T2>)));
	}

	@:extern public inline function enable(): Void {
		switch this {
			case S0(p): p.a << p.b;
			case S1(p): p.a << p.b;
			case S2(p): p.a << p.b;
		}
	}

	@:extern public inline function disable(): Void {
		switch this {
			case S0(p): p.a >> p.b;
			case S1(p): p.a >> p.b;
			case S2(p): p.a >> p.b;
		}
	}

	@:extern public inline function once(): Void {
		switch this {
			case S0(p): p.a < p.b;
			case S1(p): p.a < p.b;
			case S2(p): p.a < p.b;
		}
	}

}

/**
 * Roll
 * @author AxGord <axgord@gmail.com>
 */
abstract Roll(Array<SignalAndListener>) from Array<SignalAndListener> {

	@:extern public inline function new(p:Array<SignalAndListener>) this = p;

	public function enable(): Void for (e in this) e.enable();
	public function once(): Void for (e in this) e.once();
	public function disable(): Void for (e in this) e.disable();

}