package pony.magic;

/**
 * Chain
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.ChainBuilder.build())
#end
interface Chain<T> {

	var list:Array<T>;
	function createChain():Void;
	
}