package pony.magic;

/**
 * IChain
 * @author AxGord <axgord@gmail.com>
 */
interface IChain<T> {

	public function chain(id:Int, prev:T, next:T):Void;
	
}