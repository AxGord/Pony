/**
 * Commands
 * @author AxGord <axgord@gmail.com>
 */
class Commands extends pony.magic.Commander {

	private static inline var MINIMAL_PRIORITY:Int = -200;

	public function new() {
		super();
		onZip << eBuild;
		onFtp << eBuild;
		onCordova.add(eBuild, MINIMAL_PRIORITY);
		onAndroid.add(eCordova, MINIMAL_PRIORITY);
		onIphone.add(eCordova, MINIMAL_PRIORITY);
		onRun << eBuild;
	}

}