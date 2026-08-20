package pony.net.http.platform.nodejs;

import haxe.DynamicAccess;
import js.node.http.ServerResponse;
import pony.events.Signal0;
import pony.magic.HasSignal;

/**
 * One open Server-Sent Events connection.
 *
 * SSE is a response that is deliberately never finished: the headers go out immediately
 * and frames are appended as they happen, so a browser's `EventSource` — or any client
 * reading the body — receives them without asking. Every other send on a connection ends
 * the response, which is why this cannot be expressed with them.
 *
 * The client reconnects on its own after a drop, so a stream is cheap to lose and there
 * is nothing to retry from this side. What matters is noticing: `onClose` fires when the
 * far end goes away, and a server holding a list of streams has to drop it there or it
 * writes into a dead socket forever.
 *
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class EventStream implements HasSignal {

	private static inline final OK: Int = 200;

	/** Fires when the client disconnects; the stream is unusable afterwards. */
	@:auto public var onClose: Signal0;

	public var closed(default, null): Bool = false;

	private var res: Null<ServerResponse>;

	public function new(res: ServerResponse) {
		this.res = res;

		final headers: DynamicAccess<String> = {};
		headers['Content-Type'] = 'text/event-stream';
		// A proxy that buffers or compresses this stream would hold frames back until it
		// had "enough" of them, which for an event stream is indistinguishable from silence.
		headers['Cache-Control'] = 'no-cache, no-transform';
		headers['Connection'] = 'keep-alive';
		res.writeHead(OK, headers);

		untyped res.on('close', clientGone);
	}

	/** Sends one named event. `data` is written as a single line, so it must not contain newlines. */
	public function send(event: String, data: String): Void {
		final target: Null<ServerResponse> = res;
		if (target != null) target.write('event: $event\ndata: $data\n\n');
	}

	/**
	 * Sends a comment frame, which carries no event. Clients ignore it, which is what
	 * makes it the way to keep an idle connection from being reaped by an intermediary.
	 */
	public function comment(text: String): Void {
		final target: Null<ServerResponse> = res;
		if (target != null) target.write(': $text\n\n');
	}

	public function close(): Void {
		final target: Null<ServerResponse> = res;
		if (target == null) return;

		res = null;
		closed = true;
		target.end();
		eClose.dispatch();
	}

	private function clientGone(): Void {
		if (closed) return;

		res = null;
		closed = true;
		eClose.dispatch();
	}

}
