import js.html.Element;
import js.Browser;
import pony.electron.MonacoEditor;

class Main {

	private var container:Element;

	private function new() {
		container = Browser.document.createDivElement();
		container.style.width = '100%';
		container.style.height = '100%';
		Browser.document.body.appendChild(container);

		if (MonacoEditor.instance == null)
			MonacoEditor.init(
				// 'monaco/',
				// ['darker'],
				// [{
				// 	name: 'haxe',
				// 	ext: 'hx',
				// 	tm: 'haxe.tm.json',
				// 	conf: 'haxe.conf.json'
				// }]
			);
		MonacoEditor.instance.onLog << haxe.Log.trace;
		MonacoEditor.instance.onError << haxe.Log.trace;
		MonacoEditor.instance.inited.wait(initMonaco);
	}

	private function initMonaco():Void {
		var editor = MonacoEditor.instance.createEditor(container/* , theme */);
		var model = MonacoEditor.instance.createModel("function main() {\n\tconsole.log('Hello world');\n}", 'javascript'/* , 'haxe' */);
		editor.setModel(model);
	}

	private static function main():Void pony.JsTools.onDocReady < init;
	private static function init():Void new Main();

}