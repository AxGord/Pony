package magic;

import magic.di.Db;
import magic.di.OrderRoot;
import magic.di.Root;
import magic.di.Settings;
import magic.di.ShareRoot;
import magic.di.Sized;
import magic.di.Trace;
import massive.munit.Assert;

class DITest {

	@Test
	public function testOwnFeedsUse(): Void {
		Trace.reset();
		var root: Null<Root> = null;
		Root.create(null, r -> root = r);
		Assert.isNotNull(root);
		// One instance per type per scope: the consumer got the very object the root owns.
		Assert.isTrue(root.db.settings == root.settings);
	}

	/** `@:use` fields are assigned at the top of the constructor, so the body may read them. */
	@Test
	public function testUseIsReadableInConstructor(): Void {
		Trace.reset();
		var root: Null<Root> = null;
		Root.create(null, r -> root = r);
		Assert.areEqual(Settings.PATH, root.db.path);
	}

	@Test
	public function testOwnedServicesAreBuiltBeforeTheOwner(): Void {
		Trace.reset();
		Root.create(null, r -> {});
		Assert.areEqual('Settings,Db,Root', Trace.take());
	}

	/** `@:share` lifts a service to the parent scope, where a sibling can reach it. */
	@Test
	public function testShareReachesSibling(): Void {
		Trace.reset();
		var root: Null<ShareRoot> = null;
		ShareRoot.create(null, r -> root = r);
		Assert.isNotNull(root.sibling.shared);
		Assert.isTrue(root.producer.shared == root.sibling.shared);
	}

	/** Constructor arguments of the created class are appended to `create`. */
	@Test
	public function testCreateForwardsConstructorArguments(): Void {
		Trace.reset();
		var root: Null<Sized> = null;
		Sized.create(null, r -> root = r, 42);
		Assert.areEqual(42, root.size);
	}

	/** Destroying the root tears down what it owns, and a declared destroy still runs. */
	@Test
	public function testDestroyTearsDownOwnedServices(): Void {
		Trace.reset();
		var root: Null<Root> = null;
		Root.create(null, r -> root = r);
		Trace.take();
		root.destroy();
		final destroyed: String = Trace.take();
		Assert.isTrue(destroyed.indexOf('~Db') != -1);
		Assert.isTrue(destroyed.indexOf('~Settings') != -1);
	}

	/**
	 * docs/DI.md: "Construction order follows dependencies, not declaration order — a service
	 * written last is built first if something above it needs it."
	 *
	 * `OrderRoot` declares `db` before the `settings` it needs; `load()` must still build
	 * `settings` first, or `Db.createFast` is handed a load-local var that is still null.
	 */
	@Test
	public function testDependencyOrderBeatsDeclarationOrder(): Void {
		Trace.reset();
		OrderRoot.create(null, r -> {});
		Assert.areEqual('Settings,Db,OrderRoot', Trace.take());
	}

}
