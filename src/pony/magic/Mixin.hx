package pony.magic;

/**
 * Mixin
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.MixinBuilder.builder.build())
#end
interface Mixin<T> {}