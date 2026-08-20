package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import haxe.io.BytesInput;
import pony.net.SocketClient;

using pony.Tools;

/**
 * ...
 * @author AxGord
 */

class Main {

	private static function main(): Void {
		final stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point

		final cl: SocketClient = new SocketClient(13579, 300);
		cl.onConnect << function() {
			trace('Connected');
		};
		cl.onData << function(data: BytesInput): Void {
			trace(data.readStr());
		}
	}

}
