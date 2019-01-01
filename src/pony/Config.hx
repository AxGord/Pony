package pony;

/**
 * Pony Config
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:build(pony.magic.builder.ConfigBuilder.build())
#end
class Config {}