package pony.magic;

/**
 * Commander
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.magic.builder.CommanderBuilder.build())
#end
class Commander extends pony.Logable {

	public function runArgs(args:Array<String>):Void {
		if (args.length == 0) {
			runCommand(null);
		} else {
			var cmd:String = args.shift();
			runCommand(cmd, args);
		}
	}

	public function runCommand(cmd:String, ?args:Array<String>):Void {}

}