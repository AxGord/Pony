package pony.geom;

/**
 * IWH
 * @author AxGord <axgord@gmail.com>
 */
interface IWH {

	var size(get, never): Point<Float>;
	function wait(cb: Void -> Void): Void;
	function destroyIWH(): Void;

}