package module;

import js.node.http.IncomingMessage;
import js.node.Fs;
import js.node.Https;
import pony.NPM;
import pony.fs.Dir;
import pony.fs.File;
import types.PoeditorConfig;

using pony.text.TextTools;

private typedef Lang = {
	name: String,
	code: String,
	percentage: Int,
	export: Dynamic
};

/**
 * Poeditor Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Poeditor extends NModule<PoeditorConfig> {

	override private function run(cfg: PoeditorConfig): Void {
		tasks.add();
		var client: Dynamic = Type.createInstance(NPM.poeditor_client, [cfg.token]);
		client.projects.get(cfg.id).then(function(project) {
			project.languages.list().then(function(languages: Array<Lang>) {
				for (i in 0...languages.length) {
					var lang: Lang = languages[i];
					log('Check lang: ' + lang.name);
					if (lang.percentage == 100 && cfg.list.exists(lang.code)) {
						tasks.add();
						try {
							lang.export({type: 'key_value_json'}).then(function(v) {
								var file: String = cfg.path + cfg.list[lang.code] + '.json';
								log('Update lang file: ' + file);
								var f = Fs.createWriteStream(file);
								Https.get(v, function(response: IncomingMessage) {
									response.once('end', tasks.end);
									response.pipe(f);
								});
							});
						} catch (e: Any) error(e);
					}
				}
				tasks.end();
			});
		});
	}

}