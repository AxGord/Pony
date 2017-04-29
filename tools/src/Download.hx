#if nodejs
import pony.Tasks;
import js.node.Http;
import js.node.Https;
import js.node.Fs;
import js.Node;
import sys.FileSystem;
import haxe.xml.Fast;
import pony.Pair;

/**
 * Donwload
 * @author AxGord <axgord@gmail.com>
 */
class Download {
	
	private var path:String;
	private var units:Array<Pair<String, String>>;
	
	public function new(xml:Fast) {
		try {
			path = xml.att.path;
			FileSystem.createDirectory(path);
			units = [for (e in xml.nodes.unit) {
				if (e.has.v) {
					var v = e.att.v;
					new Pair(StringTools.replace(e.att.url, '{v}', v), e.has.check ? StringTools.replace(e.att.check, '{v}', v) : null);
				} else {
					new Pair(e.att.url, e.has.check ? e.att.check : null);
				}
			}];
		} catch (e:Dynamic) {
			trace(e);
			Sys.println('Configuration error');
			return;
		}
	}
	
	public function run(cb:Void->Void):Void {
		
		var tasks = new Tasks(cb);
		
		var downloadList = [];
		
		for (unit in units) {
			
			var file = path + unit.a.split('/').pop();
			
			var needDownload = false;
			
			if (FileSystem.exists(file)) {
				if (unit.b != null)
					needDownload = sys.io.File.getContent(file).indexOf(unit.b) == -1;
				else
					needDownload = false;
			} else {
				needDownload = true;
			}
			
			if (needDownload) {
				downloadList.push(new Pair(file, unit.a));
			}
			
		}
		
		for (file in downloadList) {
			Sys.println('Download '+file.b);
			tasks.add();
			
			var f = Fs.createWriteStream(file.a);
			Https.get(file.b, function(response) response.pipe(f)).once('end', tasks.end);
		}
		
		
		
	}
	
}
#end