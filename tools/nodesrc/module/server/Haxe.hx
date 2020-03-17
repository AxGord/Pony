package module.server;

import js.node.ChildProcess;
import js.node.child_process.ChildProcess as ChildProcessObject;
import pony.Logable;

/**
 * Haxe Server submodule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Haxe extends Logable {

	private var port: UInt;

	public function new(port: UInt) {
		super();
		this.port = port;
	}

	public function init(): Void {
		var r: String = @:nullSafety(Off) 'haxe --wait $port';
		log(r);
		var p: ChildProcessObject = ChildProcess.exec(r, execHandler);
		p.stdout.on('data', log);
		p.stderr.on('data', error);
		p.on('exit', childExitHandler);
	}

	private function execHandler(err: Null<ChildProcessExecError>, a1: String, a2: String): Void {
		error('haxe server is exec');
		init();
	}

	private function childExitHandler(code: Int): Void {
		error('Child exited with code $code');
	}

}