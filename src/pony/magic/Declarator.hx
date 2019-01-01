package pony.magic;

/**
 * Use this for set args without constructor and replays set var to new or __init__ functions.
 * "@arg" or "@:arg" - for make field as argument in consructor.
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.DeclaratorBuilder.build())
#end
interface Declarator {}