package module;

import js.node.Fs;
import js.node.Https;
import js.node.http.IncomingMessage;
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
@:nullSafety(Strict) final class Poeditor extends NModule<PoeditorConfig> {

	#if (haxe_ver < 4.2) override #end
	private function run(cfg: PoeditorConfig): Void {
		tasks.add();
		final client: Dynamic = Type.createInstance(NPM.poeditor_client, [cfg.token]);
		client.projects.get(cfg.id).then(function(project) {
			project.languages.list().then(function(languages: Array<Lang>) {
				for (i => lang in languages) {
					log('Check lang: ' + lang.name);
					if (lang.percentage == 100 && cfg.list.exists(lang.code)) {
						tasks.add();
						try {
							lang.export({ type: 'key_value_json' }).then(function(v) {
								final file: String = cfg.path + cfg.list[lang.code] + '.json';
								log('Update lang file: ' + file);
								final f: Dynamic = Fs.createWriteStream(file);
								Https.get(v, function(response: IncomingMessage) {
									response.once('end', tasks.end);
									response.pipe(f);
								});
							});
						} catch (e: Any)
							error(e);
					}
				}
				tasks.end();
			});
		});
	}

}
