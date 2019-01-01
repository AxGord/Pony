package pony.pixi.ui;

/**
 * LogableSprite
 * @author AxGord <axgord@gmail.com>
 */
class LogableSprite extends pixi.core.sprites.Sprite implements pony.ILogable implements pony.magic.HasSignal {

	@:lazy public var onLog:pony.events.Signal2<String, haxe.PosInfos>;
	@:lazy public var onError:pony.events.Signal2<String, haxe.PosInfos>;

	public inline function error(s:String, ?p:haxe.PosInfos):Void eError.dispatch(s, p);
	public inline function log(s:String, ?p:haxe.PosInfos):Void eLog.dispatch(s, p);

}