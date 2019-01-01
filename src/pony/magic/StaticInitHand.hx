package pony.magic;

/**
 * StaticInit hand mode
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.StaticInitHandBuilder.build())
#end
interface StaticInitHand {}