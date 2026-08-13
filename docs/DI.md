# Dependency injection

`pony.magic.DI` is a type-based service graph built at compile time. A class declares
what it produces and what it needs; the builder generates the construction order, and
the verifier refuses to compile a graph with an unsatisfied dependency — there is no
runtime "service not found".

```haxe
import pony.magic.DI;

class Db implements DI {
    @:use private var settings: Settings;   // resolved from the scope chain
    public final handle: Connection;
    public function new() handle = connect(settings.path);
}

class App implements DI {
    @:own private var settings: Settings = new Settings();
    @:own private var db: Db = new Db();
    public function new() {}
    public function run(): Void trace(db.handle);
}

App.create(null, app -> app.run());
```

## Attributes

One per field; using two is a compile error.

| Attribute | Initializer | Meaning |
|-----------|-------------|---------|
| `@:own`   | required    | Creates the service and registers it in this class's own scope. |
| `@:share` | required    | Creates it and publishes it to the parent scope, so siblings can use it. |
| `@:use`   | forbidden   | Consumes a service, resolved by walking the scope chain upward. |

`@:service` is the retired spelling and reports an error naming the replacement.

Lookup is by the field's declared type. Within a scope, a single instance of that type
is returned regardless of field name; when several are registered, the field name
disambiguates.

## Construction

The builder adds two statics to every DI class:

```haxe
public static function create(?provider: ServiceProvider, cb: T -> Void, ...ctorArgs): Void
public static function load(provider: ServiceProvider, cb: () -> Void): Void
```

`create` is the entry point: it derives a sub-scope from the provider you pass (or opens
a fresh root when you pass none), loads the graph, then hands you the instance. It is
asynchronous because a service may implement `WR` and finish initialising after its
constructor returns.

Construction order follows dependencies, not declaration order — a service written last
is built first if something above it needs it.

## Two rules that are easy to trip over

**Initializers run in a static context.** `@:own` and `@:share` initializers are spliced
into the generated static `load()`, which exists before any instance does. They cannot
touch `this`, instance fields, or constructor arguments:

```haxe
public function new(path: String) this.path = path;
@:own private var db: Db = new Db(path);   // error: names the offending identifier
```

Take the value from another service instead — `Db` declaring `@:use settings` is the
normal shape — or from a static, a constant or a literal. `@:use` fields are assigned at
the top of the constructor, so they are available throughout its body.

**The graph must be statically provable.** Every `@:use` needs a reachable `@:own` or
`@:share` producer somewhere in the compiled program. Registering an instance into a
`ServiceProvider` at runtime does not satisfy the verifier — it reports
`no producer for type "X" reachable from field "y"` at compile time. Values known only
at runtime therefore enter through a service that obtains them itself (reading argv, a
file, the environment) rather than being handed in from outside.

## Scopes

Each `create` opens a sub-scope of the provider it is given, and lookup walks upward.
So an `@:own` service is private to the class that owns it and to everything it builds,
while `@:share` lifts a service far enough up to be reachable by siblings. Asking a
sibling for an owned service is a compile error, not a runtime surprise.

## Related

- `pony.ServiceProvider` — the container itself; usable directly when a class needs the
  provider rather than a specific service.
- `pony.magic.WR` — for services whose initialisation completes after the constructor.
- `pony.magic.AsyncDestroy` — asynchronous teardown; a sync child of an async parent is
  promoted automatically.
