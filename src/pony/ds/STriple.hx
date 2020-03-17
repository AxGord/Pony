package pony.ds;

/**
 * STriple
 * @author AxGord <axgord@gmail.com>
 */
@:forward(a, b, c, array, toString)
abstract STriple<T>(Triple<T, T>) to Triple<T, T> from Triple<T, T> {

    public inline function new(a: T, b: T, c: T) this = new Triple(a, b, c);

    public inline function iterator(): Iterator<T> {
        var i: UInt = 3;
        return {
        hasNext: function(): Bool return i > 0,
        next: function(): T return switch i-- {
            case 3: this.a;
            case 2: this.b;
            case 1: this.c;
        }
        };
    }

}
