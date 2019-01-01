package pony.ds;

import pony.events.Signal0;

/**
 * WriteStream
 * @author AxGord <axgord@gmail.com>
 */
class WriteStream<T> implements pony.magic.HasLink {

	public var readStream:ReadStream<T>;

	public var onGetData(link, never):Signal0 = base.onGetData;
	public var onCancel(link, never):Signal0 = base.onCancel;
	public var onComplete(link, never):Signal0 = base.onComplete;

	public var data(link, never):T -> Void = base.data;
	public var end(link, never):T -> Void = base.end;
	public var error(link, never):Void -> Void = base.error;

	public var base(default, null):BaseStream<T> = new BaseStream<T>();

	public function new() {
		readStream = new ReadStream<T>(base);
	}

	public inline function start():Void readStream.next();

	public function pipe(rs:ReadStream<T>):Void {
		rs.onData << data;
		rs.onEnd << end;
		rs.onError << error;
		onGetData << rs.next;
		onCancel << rs.cancel;
		onComplete << rs.complete;
		start();
	}

}