package pony.html;

import haxe.io.Bytes;
import js.Browser;
import js.Lib;
import js.html.Blob;
import js.html.Event;
import js.html.FileReader;
import js.html.InputElement;
import pony.events.Signal1;
import pony.magic.HasSignal;

/**
 * FileDialog
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class FileDialog implements HasSignal {

	@:auto public var onOpen: Signal1<Bytes>;

	private var input: InputElement;

	public function new() {
		input = Browser.document.createInputElement();
		input.type = 'file';
		input.onchange = dialogHandler;
	}

	/**
	 * Work only for user click event
	 */
	public function open(): Void input.click();

	private function dialogHandler(event: Event): Void {
		var reader: FileReader = new FileReader();
		reader.readAsArrayBuffer(untyped event.target.files[0]);
		reader.onload = loadHandler;
	}

	private function loadHandler(event: Event): Void eOpen.dispatch(Bytes.ofData(untyped event.target.result));

	/**
	 * pony.xml
	 * download: <unit url="https://raw.githubusercontent.com/eligrey/FileSaver.js/v{v}/dist/FileSaver.min.js" v="2.0.2"/>
	 * uglify: <input>jslib/FileSaver.min.js</input>
	 */
	public static function save(bytes: Bytes, name: String = 'file'): Void {
		var blob: Blob = new Blob([ bytes.getData() ], { type: 'application/octet-stream' });
		Lib.global.saveAs(blob, name);
	}

}