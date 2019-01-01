package pony.magic;

/**
 * StaticInit
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.StaticInitBuilder.build())
#end
interface StaticInit {}