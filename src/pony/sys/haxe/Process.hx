package pony.sys.haxe;

/**
 * Process
 * @author AxGord <axgord@gmail.com>
 */
class Process extends pony.Logable implements pony.sys.IProcess {

	public var runned(default, null):Bool = false;

	private var runCmd:String;

	public function new(runCmd:String) {
		super();
		this.runCmd = runCmd;
	}

	//todo
	public function run(): Bool return false;
	public function kill(): Bool return false;

}