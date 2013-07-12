package ;
import pony.DeltaTime;

/**
 * ...
 * @author AxGord
 */
class DeltaTester {

	public static function run(sec:Float = 60):Void {
		var d = if (sec < 100) 10 else if (sec < 1000) 50 else 100;//d > 100 sec - not normal lag
		while (sec > 0) {
			var r = Math.random() * d;
			if (sec >= r)
				sec -= r;
			else {
				r = sec;
				sec = 0;
			}
			DeltaTime.update.dispatch(r);
		}
	}
	
}