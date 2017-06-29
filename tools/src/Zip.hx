import haxe.crypto.Crc32;
import haxe.io.Output;
import haxe.xml.Fast;
import haxe.zip.Compress;
import haxe.zip.Entry;
import haxe.zip.Tools;
import haxe.zip.Writer;
import sys.FileSystem;
import sys.io.File;

/**
 * ZipMain
 * @author AxGord <axgord@gmail.com>
 */
class Zip {

	private var input:Array<String> = [];
	private var output:String = 'app.zip';
	private var prefix:String = 'bin/';
	private var debug:Bool;
	private var app:String;
	private var compressLvl:Int = 9;
	private var list:List<Entry> = new List<Entry>();
	
	public function new(xml:Fast, app:String, debug:Bool) {
		Sys.println('Zip files');
		
		this.app = app;
		this.debug = debug;
		getData(xml);
		
		var a = output.split('/');
		a.pop();
		FileSystem.createDirectory(a.join('/'));
		if (FileSystem.exists(output))
			FileSystem.deleteFile(output);
		
		for (e in input) {
			writeEntry(e);
		}
		
		var o:Output = File.write(output, true);
		var writer:Writer = new Writer(o);
		writer.write(list);
		o.flush();
		o.close();
	}
	
	private function writeEntry(entry:String):Void {
		if (!FileSystem.exists(prefix+entry)) throw 'File not exists: '+entry;
		if (FileSystem.isDirectory(prefix+entry)) {
			writeDir(entry);
		} else {
			writeFile(entry);
		}
	}
	
	private function writeDir(dir:String):Void {
		for (e in FileSystem.readDirectory(prefix+dir)) {
			writeEntry(dir + (dir.substr(-1) == '/' ? '' : '/') + e);
		}
	}
	
	private function writeFile(file:String):Void {
		Sys.println(prefix+file);
		var b = File.getBytes(prefix + file);
		var entry = {
			fileName: file,
			fileSize: b.length,
			fileTime: Date.now(),
			compressed: false,
			dataSize: b.length,
			data: b,
			crc32: Crc32.make(b)};
		if (compressLvl > 0) Tools.compress(entry, compressLvl);
		list.push(entry);
	}
	
	private function getData(xml:Fast):Void {
		for (node in xml.elements) {
			switch node.name {
				case 'input': input.push(node.innerData);
				case 'output': output = node.innerData;
				case 'apps': getData(node.node.resolve(app));
				case 'debug': if (debug) getData(node);
				case 'release': if (!debug) getData(node);
				case 'prefix': prefix = node.innerData;
				case 'compress': compressLvl = Std.parseInt(node.innerData);
				case _: throw 'Wrong zip tag';
			}
		}
	}
	
}