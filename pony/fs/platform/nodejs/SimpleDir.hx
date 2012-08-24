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
package pony.fs.platform.nodejs;

import js.Node;
import pony.Stream;

using StringTools;

class SimpleDir
{

	public static inline function delete(dir:String):Void {
		Node.fs.rmdirSync(dir);
	}
	
	public static function read(dir:String, ?er:EReg):Stream<String> {
		try {
			if (!dir.endsWith('/')) dir += '/';
			return new Stream<String>(
					Node.fs.readdirSync(dir),
					er != null ? er.match : null,
					function(s:String) return SimplePath.isDir(dir + s) ? s + '/' : s
				);
		} catch (e:Dynamic) {
			return new Stream<String>();
		}
	}
	
	public static function readDirs(dir:String, ?er:EReg, ?ext:String):Stream<String> {
		try {
			//if (!dir.endsWith('/')) dir += '/';
			dir = SimplePath.full(dir);
			return new Stream<String>(
					Node.fs.readdirSync(dir),
					if (ext == null)
						er == null ? function(s:String) return SimplePath.isDir(dir + s) : function(s:String) return er.match(s) && SimplePath.isDir(dir + s)
					else
						er == null ? function(s:String) return SimplePath.ext(s) == ext && SimplePath.isDir(dir + s) : function(s:String) return SimplePath.ext(s) == ext && er.match(s) && SimplePath.isDir(dir + s),
					function(s:String) return s + '/'
				);
		} catch (e:Dynamic) {
			return new Stream<String>();
		}
	}
	
	public static function readFiles(dir:String, ?er:EReg, ?ext:String):Stream<String> {
		try {
			//if (!dir.endsWith('/')) dir += '/';
			dir = SimplePath.full(dir);
			return new Stream<String>(
					Node.fs.readdirSync(dir),
					if (ext == null)
						er == null ? function(s:String) return SimplePath.isFile(dir + s) : function(s:String) return er.match(s) && SimplePath.isFile(dir + s)
					else
						er == null ? function(s:String) return SimplePath.ext(s) == ext && SimplePath.isFile(dir + s) : function(s:String) return SimplePath.ext(s) == ext && er.match(s) && SimplePath.isFile(dir + s)
				);
		} catch (e:Dynamic) {
			return new Stream<String>();
		}
	}
	
	public static inline function create(dir:String):Void Node.require('fs.extra').mkdirRecursiveSync(dir)
}