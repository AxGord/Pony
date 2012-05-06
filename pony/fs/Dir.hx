/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/

package pony.fs;

import pony.fs.SimplePath;
import pony.events.Signal;
import pony.Priority;
import pony.Stream;

using StringTools;
using Lambda;

/**
 * @author AxGord
 */

class Dir
{
	public var list:Priority<String>;
	public var exists(getExists, setExists):Bool;
	public var up(getUp, setUp):Dir;
	public var name(getName, setName):String;
	public var ext(getExt, null):String;
	
	public var onAddDir:Signal;
	public var onAddFile:Signal;
	public var onAddFileR:Signal;

	public function new(?dir:String, ?dirs:Array<String>)
	{
		onAddDir = new Signal();
		onAddDir.haveListener = haveAddDirListener;
		onAddDir.lostListener = lostAddDirListener;
		onAddFile = new Signal();
		onAddFile.haveListener = haveAddFileListener;
		onAddFile.lostListener = lostAddFileListener;
		onAddFileR = new Signal();
		onAddFileR.haveListener = haveAddFileRListener;
		onAddFileR.lostListener = lostAddFileRListener;
		
		list = new Priority<String>();
		if (dir != null)
			if (dir.endsWith('/'))
				list.add(dir);
			else
				list.add(dir+'/');
		if (dirs != null)
			for (d in dirs)
				if (d.endsWith('/'))
					list.add(d);
				else
					list.add(d+'/');
	}
	
	public inline function toString():String {
		return list.toString();
	}
	
	private function getExists():Bool {
		for (d in list)
			if (SimplePath.exists(d) && SimplePath.isDir(d))
				return true;
		return false;
	}
	
	private function setExists(b:Bool):Bool {
		if (b)
			create();
		else
			delete();
		return b;
	}
	
	public function dir(?n:String, ?na:Array<String>):Dir {
		if (n != null) {
			return new Dir(_dir(n));
		} else {
			var a:Array<String> = [];
			for (n in na) {
				a = a.concat(_dir(n));
			}
			return new Dir(a);
		}
	}
	
	private function _dir(n:String):Array<String> {
		if (!n.endsWith('/')) n += '/';
		var a:Array<String> = [];
		for (d in list)
			a.push(d + n);
		return a;
	}
	
	public function dirs(?er:EReg, ?ext:String):Stream<Dir> {
		var sended:List<String> = new List<String>();
		var s:Stream<Dir> = new Stream<Dir>([]);
		for (e in list)
			s = s.concat(new Stream<Dir>(
					SimpleDir.readDirs(e, er, ext),
					function(s:String) return if (sended.indexOf(s) == -1) { sended.push(s); true; } else false,
					function(s:String):Dir {
						var d:Dir = new Dir();
						for (e in list)
							d.list.add(e + s);
						return d;
					}
				));
		return s;
	}
	
	private function getUp():Dir {
		var sended:List<String> = new List<String>();
		var d:Dir = new Dir();
		for (e in list) {
			var s:String = SimplePath.up(e);
			if (sended.indexOf(s) == -1) {
				 sended.push(s);
				 d.list.add(s);
			}
		}
		return d;
	}
	
	private function setUp(dir:Dir):Dir {
		var d:String = dir.list.first;
		if (!d.endsWith('/')) d += '/';
		if (SimplePath.exists(list.first)) {
			SimplePath.rename(list.first, d + name);
		}
		list.clear();
		list.add(d + name);
		return dir;
	}
	
	private function getName():String {
		var a:Array<String> = list.first.split('/');
		a.pop();
		return a.pop();
	}
	
	private function setName(n:String):String {
		if (SimplePath.exists(list.first)) {
			SimplePath.rename(list.first, up.list.first + n);
		}
		list.clear();
		list.add(up.list.first + n);
		return n;
	}
	
	public function file(n:String):File {
		var a:Array<String> = [];
		for (d in list)
			a.push(d + n);
		return new File(a);
	}
	
	public function create():Void {
		if (!exists)
			try {
				SimpleDir.create(list.first);
			} catch (e:String) {
				up.create();
				SimpleDir.create(list.first);
			}
	}
	
	public function isDir(n:String):Bool {
		for (d in list)
			if (SimplePath.isDir(d + n))
				return true;
		return false;
	}
	
	public function isFile(n:String):Bool {
		for (d in list)
			if (SimplePath.isFile(d + n))
				return true;
		return false;
	}
	
	public function files(?er:EReg, ?ext:String):Stream<File> {
		var sended:List<String> = new List<String>();
		var s:Stream<File> = new Stream<File>([]);
		for (e in list)
			s = s.concat(new Stream<File>(
					SimpleDir.readFiles(e, er, ext),
					function(s:String) return if (sended.indexOf(s) == -1) { sended.push(s); true; } else false,
					function(s:String):File {
						var d:File = new File();
						for (e in list)
							d.list.add(e + s);
						return d;
					}
				));
		return s;
	}
	
	public function filesR(?er:EReg, ?ext:String, prefix:String = ''):Stream<{ f: File, n: String}> {
		var s:Stream<{f: File, n: String}> = new Stream<{f: File, n: String}>(
				files(er, ext),
				function(f:File):{ f: File, n: String}
					return { f: f, n: prefix + (ext == null ? f.name : f.withoutExtension()) }
			);
		for (d in dirs()) {
			s = s.concat(d.filesR(er, ext, prefix + d.name + '/'));
		}
		return s;
	}
	
	public function content():Stream<String> {
		var sended:List<String> = new List<String>();
		var s:Stream<String> = new Stream<String>([]);
		for (e in list)
			s = s.concat(new Stream<String>(
					SimpleDir.read(e),
					function(s:String) return if (sended.indexOf(s) == -1) { sended.push(s); true; } else false
				));
		return s;
	}
	
	public inline function delete():Void {
		SimpleDir.delete(list.first);
	}
	
	private inline function getExt():String {
		return SimplePath.ext(list.first);
	}
	
	////////////////
	private var _files:List<String>;
	
	private function haveAddFileListener():Void {
		_files = new List<String>();
		for (f in files())
			_files.push(f.name);
		for (d in list)
			SimplePath.watch(d, dirUpdateAddFile);
	}
	
	private function lostAddFileListener():Void {
		_files = null;
		for (d in list)
			SimplePath.unwatch(d, dirUpdateAddFile);
	}
	
	private function dirUpdateAddFile(a:FileAct):Void {
		if (a != Update) return;
		var nl = new List<String>();
		for (f in files()) {
			if (_files.indexOf(f.name) == -1)
				onAddFile.dispatch(f);
			nl.push(f.name);
		}
		_files = nl;
	}
	
	//////////////////
	private var _dirs:List<String>;
		
	private function haveAddDirListener():Void {
		_dirs = new List<String>();
		for (f in dirs())
			_dirs.push(f.name);
		for (d in list)
			SimplePath.watch(d, dirUpdateAddDir);
	}
	
	private function lostAddDirListener():Void {
		_dirs = null;
		for (d in list)
			SimplePath.unwatch(d, dirUpdateAddDir);
	}
	
	private function dirUpdateAddDir(a:FileAct):Void {
		if (a != Update) return;
		var nl = new List<String>();
		for (f in dirs()) {
			if (_dirs.indexOf(f.name) == -1)
				onAddDir.dispatch(f);
			nl.push(f.name);
		}
		_dirs = nl;
	}
	
	////////////////
	private function haveAddFileRListener():Void {
		onAddFile.addListener(dirUpdateAddFileR);
		for (d in dirs())
			d.onAddFileR.addListener(dirUpdateAddFileRSub);
	}
	
	private function lostAddFileRListener():Void {
		onAddFile.removeListener(dirUpdateAddFileR);
		for (d in dirs())
			d.onAddFileR.removeListener(dirUpdateAddFileRSub);
	}
	
	private function dirUpdateAddFileR(f:File):Void {
		onAddFileR.dispatch(name+'/'+f.name, f);
	}
	
	private function dirUpdateAddFileRSub(n:String, f:File):Void {
		onAddFileR.dispatch(name+'/'+n, f);
	}
	
	
	public function full():String {
		return SimplePath.full(list.first);
	}
	
}