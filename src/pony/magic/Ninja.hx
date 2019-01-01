package pony.magic;

/**
 * Ninja
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.NinjaBuilder.build())
#end
interface Ninja {}