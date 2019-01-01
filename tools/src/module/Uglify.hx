package module;

/**
 * Uglify module
 * @author AxGord <axgord@gmail.com>
 */
class Uglify extends Module {

	private static inline var PRIORITY:Int = 3;

	public function new() super('uglify');

	override public function init():Void {
		if (xml == null) return;
		modules.commands.onBuild.add(run, PRIORITY);
		modules.commands.onPrepare.add(removeCache, -120);
	}

	private function removeCache():Void {
		if (sys.FileSystem.exists('libcache.js'))
			sys.FileSystem.deleteFile('libcache.js');
	}

	private function run(a:String, b:String):Void {
		addToRun(function(){
			Utils.runNode('ponyUglify', b != null ? [a, b] : (a != null ? [a] : []));
			finishCurrentRun();
		});
	}

}