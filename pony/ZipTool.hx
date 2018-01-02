/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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
	
	private var output:String;
	private var prefix:String;
	private var compressLvl:Int;
	private var list:List<Entry> = new List<Entry>();

	public function new(output:String = '', prefix:String = '', compressLvl:Int = 9) {
		super();
		this.output = output;
		this.prefix = prefix;
		this.compressLvl = compressLvl;
		var a = output.split('/');
		a.pop();
		if (a.length > 0) FileSystem.createDirectory(a.join('/'));
		if (FileSystem.exists(output)) FileSystem.deleteFile(output);
	}

	public function writeList(input:Array<String>):ZipTool {
		for (e in input) writeEntry(e);
		return this;
	}

	public function end():Void {
		var o:Output = File.write(output, true);
		var writer:Writer = new Writer(o);
		writer.write(list);
		o.flush();
		o.close();
	}

	public function writeEntry(entry:String):ZipTool {
		if (needIgnore(entry)) return this;
		if (!FileSystem.exists(prefix+entry)) {
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
		for (e in FileSystem.readDirectory(prefix+dir)) {
			writeEntry(dir + (dir.substr(-1) == '/' ? '' : '/') + e);
		}
		return this;
	}
	
	public function writeFile(file:String):ZipTool {
		log(prefix + file);
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
		return this;
	}

}