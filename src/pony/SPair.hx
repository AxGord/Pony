package pony;

/**
 * SPair
 * @author AxGord <axgord@gmail.com>
 */
@:forward(a, b, array, toString)
abstract SPair<T>(Pair<T, T>) to Pair<T, T> from Pair<T, T> {

	public inline function new(a:T, b:T) this = new Pair(a, b);
	
}