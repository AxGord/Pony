package pony;

import haxe.crypto.Crc32;
import haxe.io.Bytes;
import haxe.io.Output;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Tools;
import haxe.zip.Writer;
import pony.ds.ROArray;
import pony.text.TextTools;
import sys.FileStat;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

using Lambda;
using StringTools;

/**
 * ZipTool
 * @author AxGord <axgord@gmail.com>
 */
class ZipTool extends Logable {

	public static var ignore(default, null): ROArray<String> = ['.DS_Store', '.Spotlight-V100', '.Trashes', 'ehthumbs.db', 'Thumbs.db'];

	public var allowList: Array<String> = null;

	private final output: String;
	private final prefix: String;
	private final compressLvl: Int;
	private var root: String;
	private final fileOutput: Output;
	private final writer: Writer;

	public function new(output: String = '', prefix: String = '', compressLvl: Int = 9, ?root: String) {
		super();
		this.output = output;
		this.prefix = prefix;
		this.compressLvl = compressLvl;
		if (root != null && root.charAt(root.length - 1) != '/') root += '/';
		this.root = root != null ? root : '';
		final a: Array<String> = output.split('/');
		a.pop();
		if (a.length > 0) FileSystem.createDirectory(a.join('/'));
		if (FileSystem.exists(output)) FileSystem.deleteFile(output);
		fileOutput = File.write(output, true);
		writer = new Writer(fileOutput);
	}

	public function writeList(input: Array<String>): ZipTool {
		for (e in input) writeEntry(e);
		return this;
	}

	public function end(): Void {
		writer.writeCDR();
		fileOutput.flush();
		fileOutput.close();
	}

	public function writeEntry(entry: String): ZipTool {
		if (needIgnore(entry)) return this;
		if (!FileSystem.exists(prefix + entry)) {
			error('File not exists: $prefix$entry');
			return this;
		}
		if (FileSystem.isDirectory(prefix + entry))
			writeDir(entry);
		else
			writeFile(entry);
		return this;
	}

	public function needIgnore(entry: String): Bool {
		final index: Int = entry.lastIndexOf('/');
		return ignore.indexOf(index == -1 ? entry : entry.substr(index + 1)) != -1;
	}

	public function writeDir(dir: String): ZipTool {
		for (e in FileSystem.readDirectory(prefix + dir)) writeEntry(dir + (dir.substr(-1) == '/' ? '' : '/') + e);
		return this;
	}

	public function writeFile(file: String): ZipTool {
		if (prefix.endsWith('/') && file.startsWith('/')) file = file.substr(1);
		final f: String = prefix + file;
		if (allowList != null && allowList.indexOf(f) == -1) return this;
		log(f);
		final stat: FileStat = FileSystem.stat(f);
		final b: Bytes = File.getBytes(f);
		final entry: Entry = { fileName: root + file, fileSize: stat.size, fileTime: stat.mtime, compressed: false, dataSize: b.length, data: b, crc32: Crc32.make(
			b
		) };
		if (compressLvl > 0) Tools.compress(entry, compressLvl);
		writer.writeEntryHeader(entry);
		fileOutput.writeFullBytes(entry.data, 0, entry.data.length);
		return this;
	}

	public static function unpackFile(
		file: String, targetPath: String = '', ?extractFirstLevelDirs: Bool, ?filter: Array<String>, ?log: String -> Void
	): Void {
		final input: FileInput = File.read(file);
		for (e in Reader.readZip(input)) {
			var u: String = e.fileName;
			if (u.substr(-1) == '/') continue;
			if (log != null) log(u);
			if (extractFirstLevelDirs) u = TextTools.allAfter(u, '/');
			if (filter != null && filter.exists(function(f: String): Bool return u.substr(-f.length) == f)) {
				log('skip');
				continue;
			}
			final f: String = targetPath + u;
			final path: String = f.substr(0, f.lastIndexOf('/') + 1);
			if (path != '' && !FileSystem.exists(path)) FileSystem.createDirectory(path);
			File.saveBytes(f, Reader.unzip(e));
		}
		input.close();
	}

	public function writeHash(hash: Map<String, Array<String>>): ZipTool {
		if (hash == null) return this;
		for (file => value in hash) {
			final f: String = prefix + file;
			if (allowList != null && allowList.indexOf(f) == -1) continue;
			log(f);
			final h: Array<String> = value;
			final b: Bytes = File.getBytes(f);
			final entry: Entry = { fileName: file, fileSize: Std.parseInt(h[1]), fileTime: Date.fromTime(Std.parseFloat(h[0])), compressed: false, dataSize: b.length, data: b, crc32: h.length
				> 2
				? Std.parseInt(h[2])
				: Crc32.make(b) };
			if (compressLvl > 0) Tools.compress(entry, compressLvl);
			writer.writeEntryHeader(entry);
			fileOutput.writeFullBytes(entry.data, 0, entry.data.length);
		}
		return this;
	}

}
