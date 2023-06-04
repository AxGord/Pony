package pony.electron;

import monaco.Editor.IStandaloneCodeEditor;
import monaco.Editor.IStandaloneThemeData;
import monaco.Editor.ITextModel;
import monaco.Languages.LanguageConfiguration;

import js.html.Element;
import js.node.Fs;

import pony.NPM;
import pony.events.Signal0;
import pony.Tasks;
import pony.events.Waiter;

typedef Lang = LangBase<String>;
private typedef LangLoaded = LangBase<LanguageConfiguration>;

private typedef LangBase<T> = {
	name: String,
	ext: String,
	tm: String,
	?conf: T
}

private typedef GrammarDef = {
	format: String,
	content: String
}

/**
 * Monaco editor
 * With themes and textmate json support
 * @author AxGord <axgord@gmail.com>
 */
class MonacoEditor extends pony.Logable {

	public static var instance(default, null): MonacoEditor;

	public static function init(home: String = 'monaco/', modulesPath: String = '', ?themes: Array<String>, ?langs: Array<Lang>): Void {
		instance = new MonacoEditor(home, modulesPath, themes, langs);
	}

	@:auto public var onInit: Signal0;
	public var inited(default, null): Waiter = new Waiter();

	public var monaco(default, null): Monaco;

	private var tasks: Tasks;
	private var wmodule: String;
	private var monacoDir: String;
	private var themes: Map<String, IStandaloneThemeData> = new Map<String, IStandaloneThemeData>();
	private var langs: Map<String, LangLoaded> = new Map<String, LangLoaded>();

	private function new(
		home: String = 'monaco/',
		modulesPath: String = '',
		onigasm: String = 'node_modules/onigasm/lib/onigasm.wasm',
		?themes: Array<String>,
		?langs: Array<Lang>
	) {
		super();

		var dir: String = js.Node.__dirname + '/' + modulesPath;
		monacoDir = dir + home;
		wmodule = dir + onigasm;

		onInit.add(_init, -10);
		onInit.add(inited.end, 10);
		tasks = new Tasks(eInit.dispatch);

		tasks.add();
		Fs.exists(wmodule, wasmExistsHandler);

		tasks.add();
		NPM.monaco_loader().then(loadMonacoHandler);

		loadThemes(themes);
		loadLangs(langs);
	}

	private function loadThemes(themes: Array<String>): Void {
		if (themes != null)
			for (theme in themes)
				if (needLoadTheme(theme)) {
					tasks.add();
					readMonacoFile(theme + '.theme.json', function(s: String): Void {
						try {
							this.themes[theme] = haxe.Json.parse(s);
							log(theme + ' theme loaded');
							tasks.end();
						} catch (e:js.Error) {
							error(e.message);
						}
					});
				}
	}

	private function loadLangs(langs: Array<Lang>): Void {
		if (langs != null)
			for (lang in langs) {
				tasks.add();
				var l: LangLoaded = {
					name: lang.name,
					ext: lang.ext,
					tm: null,
					conf: null
				};
				this.langs[lang.name] = l;
				var st: Tasks = new Tasks(tasks.end);
				st.add();
				readMonacoFile(lang.tm, function(s: String): Void {
					log(l.name + ' tm loaded');
					l.tm = s;
					st.end();
				});
				if (lang.conf != null) {
					st.add();
					readMonacoFile(lang.conf, function(s: String): Void {
						try {
							l.conf = haxe.Json.parse(s);
							log(l.name + ' conf loaded');
							st.end();
						} catch (e:js.Error) {
							error(e.message);
						}
					});
				}
			}
	}

	private function readMonacoFile(file: String, cb: String -> Void): Void {
		Fs.readFile(monacoDir + file, 'utf-8', function(err: js.Error, s: String): Void {
			if (err != null)
				error(err.message);
			else
				cb(s);
		});
	}

	private function wasmExistsHandler(v: Bool): Void {
		if (v)
			NPM.onigasm.loadWASM(wmodule).then(loadWASMHandler);
		else
			error('$wmodule not exists');
	}

	private function loadWASMHandler(): Void {
		log('onigasm loaded');
		tasks.end();
	}

	private function loadMonacoHandler(monaco: Monaco): Void {
		log('monaco loaded');
		this.monaco = monaco;
		tasks.end();
	}

	private function needLoadTheme(theme: String): Bool return [null, 'vs', 'vs-dark', 'hc-black'].indexOf(theme) == -1;

	private function _init(): Void {
		var registryClass = NPM.monaco_textmate.Registry;
		var registry = Type.createInstance(registryClass, [
			{
				getGrammarDefinition: getGrammarDefinition
			}
		]);

		var grammars = pony.JsTools.mapToJSMap([for (l in langs) l.name => 'source.' + l.ext]);
		for (l in langs) {
			monaco.languages.register({id: l.name, extensions: [l.ext]});
			if (l.conf != null)
				monaco.languages.setLanguageConfiguration(l.name, l.conf);
		}
		NPM.monaco_editor_textmate.wireTmGrammars(monaco, registry, grammars);

		for (k in themes.keys())
			monaco.editor.defineTheme(k, themes[k]);

		log('monaco ready');
	}

	private function getGrammarDefinition(scopeName: String): GrammarDef {
		log('get tm: ' + scopeName);
		for (l in langs) {
			if (scopeName == 'source.' + l.ext) {
				return {
					format: 'json',
					content: l.tm
				};
			}
		}
		return null;
	}

	public function createEditor(container: Element, ?theme: String): IStandaloneCodeEditor {
		log('create editor');
		return monaco.editor.create(container, {
			theme: theme == null ? 'vs-dark' : theme,
			automaticLayout: true
		});
	}

	public function createModel(value: String, ?lang: String): ITextModel {
		log('create $lang model');
		return monaco.editor.createModel(value, lang);
	}

	public function create(container: Element, value: String, ?lang: String, ?theme: String): IStandaloneCodeEditor {
		log('create $lang editor');
		return monaco.editor.create(container, {
			theme: theme == null ? 'vs-dark' : theme,
			automaticLayout: true,
			language: lang,
			value: value
		});
	}

}