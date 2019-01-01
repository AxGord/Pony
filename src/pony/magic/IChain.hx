package pony.magic;

/**
 * IChain
 * @author AxGord <axgord@gmail.com>
 */
//interface IChainR<T:IChain<T, C>, C:Chain<T>> extends IChain<T, C> {}
interface IChain<T, C:Chain<T>> {

	function chain(id:Int, prev:T, next:T, controller:C):Void;
	
}