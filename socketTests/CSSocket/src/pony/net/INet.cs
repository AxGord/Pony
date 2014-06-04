
#pragma warning disable 109, 114, 219, 429, 168, 162
namespace pony.net{
	public  interface INet : global::haxe.lang.IHxObject {
		   void send(global::haxe.io.BytesOutput b);
		
		   void close();
		
	}
}


