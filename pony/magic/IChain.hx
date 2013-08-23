package pony.magic;

/**
 * IChain
 * @author AxGord <axgord@gmail.com>
 */
interface IChain {

	public function chain(id:Int, prev:Unit, next:Unit):Void;
	
}