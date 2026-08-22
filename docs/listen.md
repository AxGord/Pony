# Declarative listeners

`pony.magic.HasListener` moves subscriptions from imperative code onto the handler that
serves them. The builder collects every `@:listen` in the class and generates one pair of
methods:

```haxe
public function listen(): Void      // appended to the end of the constructor
public function unlisten(): Void    // called from destroy()
```

So a handler is never subscribed in one place and forgotten in another — the two halves are
generated from the same declaration and cannot drift apart.

```haxe
import pony.magic.HasListener;

class Player implements HasListener {
    @:listen(Keyboard.down - Key.Space) private function jump(): Void ...
    @:listen(world.onHit) private function hit(damage: Int): Void ...
}
```

A class without `implements HasListener` in its own declaration list — one that inherits it
— gets `override` versions that chain into `super.listen()` / `super.unlisten()`. A DI class
does not get a `destroy()` from this builder: `DIBuilder` owns the teardown chain and calls
`unlisten()` from there.

## Several signals, one handler

Every `@:listen` on a field takes effect, which is how one handler serves several sources:

```haxe
@:listen(world.onPress)
@:listen(Keyboard.down - Key.Space)
@:listen(Keyboard.down - Key.Up)
@:listen(Keyboard.down - Key.W)
private function pressHandler(): Void horse.press();
```

`Signal1`'s `-` operator caches, so `Keyboard.down - Key.Space` yields the same `Signal0`
object every time it is evaluated — which is what lets `listen()` and `unlisten()` address
one subscription from two separate evaluations of the expression.

## Conditional listeners

A second parameter makes the subscription itself stateful: the handler is added while the
condition holds and removed as soon as it stops holding.

```haxe
enum abstract Phase(Int) { final Idle; final Ground; final Air; }

@:bindable('private') private var phase: Phase = Phase.Idle;

@:listen(DeltaTime.update, phase == Phase.Air)  private function fly(dt: DT): Void ...
@:listen(onPress, phase == Phase.Ground)        private function jump(): Void ...
@:listenOnce(onRelease, phase == Phase.Air)     private function cut(): Void ...
```

Assigning `phase` **is** the transition; there is no dispatch on a state flag and no manual
`<<` / `>>` anywhere. `@:listenOnce` with a condition re-arms on every entry into the state,
which gives "once per visit" for free.

### What a condition may read

Any expression over one or more bindables, whether they belong to this class or are reached
through one of its fields:

```haxe
@:listen(onTick, running)
@:listen(onTick, !grounded)
@:listen(onTick, phase != Phase.Idle)               // enum abstract
@:listen(onTick, running && grounded)               // re-checked on both
@:listen(onTick, running && count > LIMIT)          // bindable + plain constant
@:listen(onTick, running && horse.phase != Phase.Idle)   // own + through a field
```

Every bindable that appears gets its own change handler, and each one re-evaluates the whole
condition. That is exact rather than approximate: a dispatch carries one field, so inside its
handler the other fields still hold the value the condition last saw — swapping just this
field back to its previous value tells you whether the condition itself flipped.

What counts as a bindable is decided syntactically. An identifier starting with an upper case
letter is a type or an enum constructor, never a field, so `Phase.Air`, `LIMIT` and
`Assets.HORSE` are left alone; a field declared in this class without `@:bindable` is left
alone too. Everything else is taken to be a bindable, and a wrong guess fails loudly on the
missing `changeX` rather than silently. A condition that reads no bindable at all is a
compile error pointing at the condition — it could never be re-checked.

Method calls are not tracked: `@:listen(onTick, isReady())` reads a value the builder cannot
subscribe to, so the call is invisible to the re-check. Put the state in a `@:bindable` field.

## Priority

`priority = N` orders a handler against the other listeners of the same signal. Lower runs
earlier, the default is `0`, and listeners sharing a number keep their subscription order —
the same convention as `pony.Priority` itself, which backs every signal.

```haxe
// integrate the height before anything reads it
@:listen(DeltaTime.update, phase == Phase.Air, priority = -10)
private function fly(dt: DT): Void ...
```

It is a named parameter, so it works with or without a condition and is set per
subscription:

```haxe
@:listen(DeltaTime.update, priority = -10) private function early(dt: DT): Void ...

@:listen(world.onPress, priority = -10)
@:listen(Keyboard.down - Key.Space)
private function pressHandler(): Void ...
```

Reach for it when the order of two handlers on one signal is load-bearing — without it the
order is subscription order, which for conditional listeners depends on when each condition
first became true and is not obvious from reading the code.
