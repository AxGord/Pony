
#if nodejs
import js.node.http.IncomingMessage;
import js.node.Fs;
import js.node.Https;
import sys.FileSystem;
import sys.io.File;
import pony.Tasks;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;

/**
 * Poeditor
 * @author AxGord <axgord@gmail.com>
 */
class Poeditor {

	private static var POEditorClient = Node.require('poeditor-client');
	
	private var id:Int;
	private var path:String;
	private var client:Dynamic;
	private var files:Map<String, String>;
	
	public function new(xml:Fast) {
		var token:String = null;
		try {
			token = xml.node.token.innerData;
			id = Std.parseInt(xml.node.id.innerData);
			path = xml.node.path.innerData;
			FileSystem.createDirectory(path);
			files = [for (e in xml.node.list.elements) e.innerData => e.name];
		} catch (_:Dynamic) {
			Sys.println('Configuration error');
			return;
		}
		
		client = Type.createInstance(POEditorClient, [token]);
	}
	
	public function updateFiles(cb:Void->Void):Void {
		var tasks = new Tasks(cb);
		client.projects.get(id).then(function(project){
			project.languages.list().then(function(languages:Array<Dynamic>){
				tasks.add();
				for (language in languages) {
					if (language.percentage != 100 || !files.exists(language.code)) continue;
					tasks.add();
					var lang = language;
					lang.export({type: 'key_value_json'}).then(function(v) {
						var file = path + files[lang.code] + '.json';
						Sys.println('Update lang file: '+file);
						var f = Fs.createWriteStream(file);
						Https.get(v, function(response:IncomingMessage) {
							response.once('end', tasks.end);
							response.pipe(f); 
						});
					});
				}
				tasks.end();
			});
		});
	}
	
	
}
#end