package pony.ds;

import pony.events.Signal0;
import pony.events.Signal1;

/**
 * ReadStream
 * @author AxGord <axgord@gmail.com>
 */
class ReadStream<T> implements pony.magic.HasLink {

	public var onData(link, never):Signal1<T> = base.onData;
	public var onEnd(link, never):Signal1<T> = base.onEnd;
	public var onError(link, never):Signal0 = base.onError;

	public var next(link, never):Void -> Void = base.next;
	public var cancel(link, never):Void -> Void = base.cancel;
	public var complete(link, never):Void -> Void = base.complete;

	private var base:BaseStream<T>;

	public function new(base:BaseStream<T>) this.base = base;

}