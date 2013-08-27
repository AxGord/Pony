package pony.magic;

/**
 * ChainUnit
 * @author AxGord <axgord@gmail.com>
 */
class ChainUnit < T, C:Chain<T> > implements IChain < T, C > {
	
	public var id(default,null):Int;
	public var nextUnit(default,null):T;
	public var prevUnit(default,null):T;
	public var controller(default,null):C;

	public function chain(id:Int, prevUnit:T, nextUnit:T, controller:C):Void {
		this.id = id;
		this.prevUnit = prevUnit;
		this.nextUnit = nextUnit;
		this.controller = controller;
	}
	
}