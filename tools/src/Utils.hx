package;
import haxe.xml.Fast;
import sys.io.File;

/**
 * Share
 * @author AxGord <axgord@gmail.com>
 */
class Utils {
	
	public static inline var MAIN_FILE:String = 'pony.xml';
	
	public static function parseArgs(args:Array<String>):AppCfg {
		var debug = args.indexOf('debug') != -1;
		var app:String = null;
		for (a in args) if (a != 'debug' && a != 'release') {
			app = a;
			break;
		}
		return {app: app, debug:debug};
	}
	
	public static function getXml():Fast return new Fast(Xml.parse(File.getContent(MAIN_FILE))).node.project;
	
	public static function error(message:String, errCode:Int = 1):Void {
		Sys.println(message);
		Sys.exit(errCode);
	}
	
}