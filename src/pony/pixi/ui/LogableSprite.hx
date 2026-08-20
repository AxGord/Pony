package pony.pixi.ui;

import haxe.PosInfos;
import pony.events.Signal2;

/**
 * LogableSprite
 * @author AxGord <axgord@gmail.com>
 */
class LogableSprite extends pixi.core.sprites.Sprite implements pony.ILogable implements pony.magic.HasSignal {

	@:lazy public var onLog: Signal2<String, PosInfos>;
	@:lazy public var onError: Signal2<String, PosInfos>;

	public inline function error(s: String, ?p: PosInfos): Void eError.dispatch(s, p);

	public inline function log(s: String, ?p: PosInfos): Void eLog.dispatch(s, p);

}
