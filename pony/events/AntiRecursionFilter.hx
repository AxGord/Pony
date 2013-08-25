package pony.events;

/**
 * AntiRecursionFilter
 * @author AxGord <axgord@gmail.com>
 */
class AntiRecursionFilter {

	public var local:Signal;
	public var global:Signal;
	public var send:Signal;
	
	public function new(?local:Signal, ?global:Signal) {
		this.local = local == null ? new Signal() : local;
		this.global = global == null ? new Signal() : global;
		send = new Signal();
		this.global.add(disableSend);
		this.global.add(local.dispatchEvent);
		this.global.add(enableSend);
		enableSend();
	}
	
	private function disableSend():Void {
		local.remove(send.dispatchEvent);
	}
	
	private function enableSend():Void {
		local.add(send.dispatchEvent);
	}
	
}