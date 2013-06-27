package pony.magic;
import hxunion.UnionSupport;
import pony.events.Signal;
import pony.magic.ArgsArray;
import pony.magic.Binder;
import pony.magic.Declarator;
import pony.magic.Listen;
import pony.magic.MultyExtends;
import pony.magic.Polymorph;
import pony.magic.Spi;

/**
 * ...
 * @author AxGord
 */
@:autoBuild(com.dongxiguo.hoo.OperatorOverloading.enableAll())
@:autoBuild(com.dongxiguo.continuation.Continuation.cpsByMeta("cps"))
interface FullPower
implements Polymorph,
//implements MultyExtends,
implements ArgsArray,
implements Binder,
implements UnionSupport,
implements Listen,
implements Spi,
implements Declarator
{}