package pony.html;

import haxe.io.Bytes;
import js.Browser;
import js.Lib;
import js.lib.ArrayBuffer;
import js.html.File;
import js.html.Blob;
import js.html.Event;
import js.html.FileReader;
import js.html.Element;
import js.html.InputElement;
import pony.events.Signal0;
import pony.events.Signal2;
import pony.magic.HasSignal;

/**
 * FileDialog
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class FileDialog implements HasSignal {

	@:auto public var onOpen: Signal2<String, Bytes>;
	@:auto public var onDragEnter: Signal0;
	@:auto public var onDragLeave: Signal0;

	private var input: InputElement;
	private var dropElement: Null<Element>;

	public function new(?dropElement: Element) {
		this.dropElement = dropElement;
		input = Browser.document.createInputElement();
		input.type = 'file';
		input.onchange = dialogHandler;
		if (dropElement != null) {
			dropElement.addEventListener('dragover', dragoverHandler);
			dropElement.addEventListener('dragenter', dragenterHandler);
			dropElement.addEventListener('dragleave', dragleaveHandler);
			dropElement.addEventListener('drop', dropHandler);
		}
	}

	/**
	 * Work only for user click event
	 */
	public function open(): Void input.click();

	private function dialogHandler(event: Event): Void {
		readFile(untyped event.target.files[0]);
	}

	private inline function readFile(file: File): Void {
		var reader: FileReader = new FileReader();
		reader.readAsArrayBuffer(file);
		reader.onload = loadHandler.bind(file.name);
	}

	private function dragenterHandler(event: Event): Void {
		event.preventDefault();
		eDragEnter.dispatch();
	}

	private function dragleaveHandler(event: Event): Void {
		event.preventDefault();
		eDragLeave.dispatch();
	}

	private function dragoverHandler(event: Event): Void event.preventDefault();

	private function dropHandler(event: Event): Void {
		event.preventDefault();
		readFile(untyped event.dataTransfer.items[0].getAsFile());
	}

	private function loadHandler(name: String, event: Event): Void eOpen.dispatch(name, Bytes.ofData(untyped event.target.result));

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