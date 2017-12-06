import haxe.xml.Fast;

/**
 * Remote
 * @author AxGord <axgord@gmail.com>
 */
class Remote {

	public function new(cmd:String, args:Array<String>, xml:Fast) {
		var xr:Fast = xml.node.remote;
		switch cmd {
			case 'prepare':

				if (xr.hasNode.externs) {
					
				}

			case _:
				Utils.error('Unknown command');
		}

	}

}