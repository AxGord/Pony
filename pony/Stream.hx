package pony;

/**
 * Stream
 * Use listeners for events
 * @author AxGord <axgord@gmail.com>
 */
class Stream<T> {
	
	private var result(default, null):List<T>;
	private var complite(default, null):Bool = false;
	private var fail(default, null):Dynamic = null;

	inline public function new() result = new List<T>();
	
	dynamic private function data(v:T):Void result.push(v);
	dynamic private function end():Void {
		complite = true;
		destroy();
	}
	dynamic private function error(v:Dynamic):Void fail = v;
	
	inline public function dataListener(v:T):Void data(v);
	inline public function endListener():Void end();
	inline public function errorListener(v:Dynamic):Void error(v);
	
	public function map<R>(f:T->R):Stream<R> {
		var s = new Stream<R>();
		take(function(v:T)s.dataListener(f(v)), s.endListener, s.errorListener);
		return s;
	}
	
	dynamic public function take(d:T->Void, ?compl:Void->Void, ?err:Dynamic->Void):Void {
		if (err == null) err = Tools.errorFunction;
		if (compl == null) compl = Tools.nullFunction0;
		if (fail != null) {
			err(fail);
		}
		for (e in result) d(e);
		if (complite) {
			compl();
			result = null;
			destroy();
		} else {
			result = null;
			data = d;
			end = function() {
				compl();
				result = null;
				end = Tools.nullFunction0;
				destroy();
			}
			error = function(e) {
				err(e);
				result = null;
				destroy();
			}
		}
		take = locked;
	}
	
	public function atake(d:T->Void, ?compl:Dynamic->Void):Void take(d, function() { compl(null); compl = Tools.nullFunction1; }, function(e:Dynamic) { compl(e); compl = Tools.nullFunction1; } );
	
	private function locked(d:T->Void, ?compl:Void->Void, ?err:Dynamic->Void):Void throw 'Stream locked';
	
	inline private function destroy():Void {
		fail = null;
		data = Tools.nullFunction1;
		error = Tools.errorFunction;
	}
	
	public function putIterable(a:Iterable<T>):Stream<T> {
		for (e in a) dataListener(e);
		endListener();
		return this;
	}
	
	inline static public function fromArray<T>(a:Array<T>):Stream<T> return new Stream().putIterable(a);
	
}