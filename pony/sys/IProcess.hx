package pony.sys;

/**
 * IProcess
 * @author AxGord <axgord@gmail.com>
 */
interface IProcess extends pony.ILogable  {

	public var runned(default, null):Bool;

	public function run():Bool;
	public function kill():Bool;

}