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

package pony.fs.platform.neko;

import neko.FileSystem;
import neko.io.File;
import neko.io.Path;
import pony.fs.SimplePath;

using StringTools;

/**
 * @author AxGord
 */

class SimplePath
{

	public static inline function exists(path:String):Bool
	{
		var p:String = normalize(path);
		if (p.endsWith('/')) p = p.substr(0, -1);
		return FileSystem.exists(p);
	}
	
	public static inline function full(path:String):String {
		return normalize(FileSystem.fullPath(path));
	}
	
	public static function dir(path:String):String {
		var p:Path = new Path(path);
		return normalize(p.dir+'/');
	}
	
	public static function file(path:String):String {
		var p:Path = new Path(path);
		return p.file;
	}
	
	public static function ext(path:String):String {
		var p:Path = new Path(path);
		return p.ext;
	}
	
	public static function normalize(path:String):String {
		path = path.replace('\\', '/');
		var a:Array<String> = [];
		for (e in path.split('/'))
			if (e != '')
				a.push(e);
		return a.join('/')+(path.endsWith('/')?'/':'');
	}
	
	public static inline function isDir(path:String):Bool {
		var p:String = normalize(path);
		if (p.endsWith('/')) p = p.substr(0, -1);
		return FileSystem.isDirectory(p);
	}
	
	public static inline function isFile(path:String):Bool {
		return !FileSystem.isDirectory(path);
	}
	
	public static inline function rename(path:String, newPath:String):Void {
		FileSystem.rename(path, newPath);
	}
	
	public static function up(path:String):String {
		var a:Array<String> = path.split('/');
		var b:Bool = path.endsWith('/');
		if (b) a.pop();
		a.pop();
		return a.join('/')+(b?'/':'');
	}
	
	public static inline function withoutExtension(f:String):String {
		return Path.withoutExtension(f);
	}
	
	public static inline function watch(path:String, f:FileAct->Void):Void { }
	public static inline function unwatch(path:String, f:FileAct->Void):Void { }
	
	public static inline function copy(src:String, dst:String):Void File.copy(src, dst)
	public static inline function remove(src:String):Void {
		if (isDir(src))
			FileSystem.deleteDirectory(src);
		else
			FileSystem.deleteFile(src);
	}
	
}