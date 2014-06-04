
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  interface ISocketClient : global::haxe.lang.IHxObject, global::pony.net.INet {
		   void open();
		
		   void reconnect();
		
		   void send2other(global::haxe.io.BytesOutput data);
		
	}
}


