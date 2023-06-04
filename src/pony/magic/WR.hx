package pony.magic;

import pony.events.WaitReady;

/**
 * WR
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.WRBuilder.build())
#end
interface WR {

	private var _waitReady: WaitReady;

	public function waitReady(cb: () -> Void): Void;
	private function ready(): Void;

}