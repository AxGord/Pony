#if nodejs
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
			Sys.println(project);
			project.languages.list().then(function(languages:Array<Dynamic>){
				for (language in languages) {
					if (language.percentage != 100 || !files.exists(language.code)) continue;
					tasks.add();
					var lang = language;
					lang.terms.list().then(function(terms:Array<Dynamic>){
						var obj:Dynamic = {};
						for (term in terms) Reflect.setField(obj, term.term, term.translation);
						var r = Json.stringify(obj, null, '\t');
						File.saveContent(path + files[lang.code] + '.json', r);
						tasks.end();
					});
				}
			});
		});
	}
	
	
}
#end