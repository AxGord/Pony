package magic.di;

/** Records construction and teardown so the DI tests can assert on order. */
class Trace {

	private static var log: Array<String> = [];

	public static function add(name: String): Void log.push(name);

	public static function reset(): Void log = [];

	public static function take(): String {
		final result: String = log.join(',');
		log = [];
		return result;
	}

}
