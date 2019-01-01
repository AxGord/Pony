/**
 * Commands
 * @author AxGord <axgord@gmail.com>
 */
class Commands extends pony.magic.Commander {

	public function new() {
		super();
		onZip << eBuild;
		onFtp << eBuild;
		onCordova.add(eBuild, -200);
		onAndroid.add(eCordova, -200);
		onIphone.add(eIphone, -200);
		onRun << eBuild;
	}

}