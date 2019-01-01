package pony;

import haxe.crypto.Crc32;
import haxe.io.Output;
import haxe.zip.Entry;
import haxe.zip.Tools;
import haxe.zip.Writer;
import sys.FileSystem;
import sys.io.File;

/**
 * ZipTool
 * @author AxGord <axgord@gmail.com>
 */
class ZipTool extends pony.Logable {

	public var ignore:Array<String> = ['.DS_Store'];
	public var allowList:Array<String> = null;

	private var output:String;
	private var prefix:String;
	private var compressLvl:Int;
	private var fileOutput:Output;
	private var writer:Writer;

	public function new(output:String = '', prefix:String = '', compressLvl:Int = 9) {
		super();
		this.output = output;
		this.prefix = prefix;
		this.compressLvl = compressLvl;
		var a = output.split('/');
		a.pop();
		if (a.length > 0) FileSystem.createDirectory(a.join('/'));
		if (FileSystem.exists(output)) FileSystem.deleteFile(output);

		fileOutput = File.write(output, true);
		writer = new Writer(fileOutput);
	}

	public function writeList(input:Array<String>):ZipTool {
		for (e in input) writeEntry(e);
		return this;
	}

	public function end():Void {
		writer.writeCDR();
		fileOutput.flush();
		fileOutput.close();
	}

	public function writeEntry(entry:String):ZipTool {
		if (needIgnore(entry)) return this;
		if (!FileSystem.exists(prefix + entry)) {
			error('File not exists: ' + entry);
			return this;
		}
		if (FileSystem.isDirectory(prefix + entry)) {
			writeDir(entry);
		} else {
			writeFile(entry);
		}
		return this;
	}
	
	public function needIgnore(entry:String):Bool {
		var index = entry.lastIndexOf('/');
		return if (index == -1) {
			ignore.indexOf(entry) != -1;
		} else {
			ignore.indexOf(entry.substr(index + 1)) != -1;
		}
	}

	public function writeDir(dir:String):ZipTool {
		for (e in FileSystem.readDirectory(prefix + dir)) {
			writeEntry(dir + (dir.substr(-1) == '/' ? '' : '/') + e);
		}
		return this;
	}
	
	public function writeFile(file:String):ZipTool {
		var f = prefix + file;
		if (allowList != null && allowList.indexOf(f) == -1) return this;
		log(f);
		var stat = FileSystem.stat(f);
		var b = File.getBytes(f);
		var entry:Entry = {
			fileName: file,
			fileSize: stat.size,
			fileTime: stat.mtime,
			compressed: false,
			dataSize: b.length,
			data: b,
			crc32: Crc32.make(b)
		};
		if (compressLvl > 0) Tools.compress(entry, compressLvl);

		writer.writeEntryHeader(entry);
		fileOutput.writeFullBytes(entry.data, 0, entry.data.length);
		
		return this;
	}

	public static function unpackFile(file:String, targetPath:String = '', ?log:String -> Void):Void {
		var input = File.read(file);
		for (e in haxe.zip.Reader.readZip(input)) {
			if (e.fileName.substr(-1) == '/') continue;
			if (log != null) log(e.fileName);
			var f:String = targetPath + e.fileName;
			var path = f.substr(0, f.lastIndexOf('/') + 1);
			if (path != '' && !FileSystem.exists(path))
				FileSystem.createDirectory(path);
			File.saveBytes(f, haxe.zip.Reader.unzip(e));
		}
		input.close();
	}

	public function writeHash(hash:Map<String, Array<String>>):ZipTool {
		if (hash == null) return this;
		for (file in hash.keys()) {
			var f = prefix + file;
			if (allowList != null && allowList.indexOf(f) == -1) continue;
			log(f);
			var h = hash[file];
			var b = File.getBytes(f);
			var entry:Entry = {
				fileName: file,
				fileSize: Std.parseInt(h[1]),
				fileTime: Date.fromTime(Std.parseFloat(h[0])),
				compressed: false,
				dataSize: b.length,
				data: b,
				crc32: h.length > 2 ? Std.parseInt(h[2]) : Crc32.make(b)
			};
			if (compressLvl > 0) Tools.compress(entry, compressLvl);

			writer.writeEntryHeader(entry);
			fileOutput.writeFullBytes(entry.data, 0, entry.data.length);
		}
		return this;
	}

}