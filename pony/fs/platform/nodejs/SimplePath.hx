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

import pony.fs.SimplePath;
import js.Node;
import pony.SpeedLimit;

import pony.events.Signal;

using StringTools;
using Lambda;


class SimplePath
{
	public static inline function exists(path:String):Bool return untyped Node.fs.existsSync(path)
	public static inline function full(path:String):String {
		if (path.indexOf(':') == -1)
			return normalize(untyped __dirname + '/' + path);
		else
			return normalize(path);
	}
	public static inline function dir(path:String):String return Node.path.dirname(path) + '/'
	public static inline function file(path:String):String return Node.path.basename(path)
	public static inline function ext(path:String):String return Node.path.extname(path).substr(1)
	public static inline function normalize(path:String):String return Node.path.normalize(path).replace('\\', '/')//+(path.endsWith('/')?'/':'')
	public static inline function isDir(path:String):Bool return Node.fs.statSync(path).isDirectory()
	public static inline function isFile(path:String):Bool return Node.fs.statSync(path).isFile()
	public static inline function rename(path:String, newPath:String):Void return Node.fs.renameSync(path, newPath)
	public static inline function withoutExtension(f:String):String return Node.path.basename(f, '.'+ext(f))
	public static inline function copy(src:String, dst:String):Void Node.require('fs.extra').copy(src, dst)
	public static inline function remove(src:String):Void Node.require('fs.extra').removeSync(src)
	
	public static function up(path:String):String {
		var a:Array<String> = path.split('/');
		var b:Bool = path.endsWith('/');
		if (b) a.pop();
		a.pop();
		return a.join('/')+(b?'/':'');
	}
	
	private static var watched:Hash<Signal> = new Hash<Signal>();
	
	public static function watch(path:String, f:FileAct->Void):Void {
		if (!exists(path)) {
			var p:String = up(path);
			if (p == '') p = '.';
			var fu:Dynamic = null;
			fu = function(a:FileAct) {
				if (a == Update && exists(path)) {
					//trace('fu');
					f(Create);
					watch(path, f);
					unwatch(p, fu);
				}
			};
			watch(p, fu);
		} else if (watched.exists(path)) {
			watched.get(path).addListener(f);
		} else {
			var s:Signal = new Signal();
			s.haveListener = function() {
				//trace('Watch file: ' + path);
				var o:NodeWatchOpt = { persistent: true, interval: 500 };
				var sl:SpeedLimit = new SpeedLimit(100);
				var removed:Bool = false;
				var w:NodeFSWatcher = Node.fs.watch(path, o, function(t:String, d:String):Void {
					sl.run(function(){
						switch(t) {
							case 'change':
								if (removed) {
									removed = false;
									s.dispatch(Create);
								} else
									s.dispatch(Update);
							case 'rename':
								if (removed) {
									removed = false;
									s.dispatch(Create);
								} else {
									s.dispatch(Remove);
									removed = true;
								}
							default: throw 'Unknown';
						}
					});
				} );
				s.lostListener = w.close;
			};
			
			s.addListener(f);
			watched.set(path, s);
		}
	}
	
	public static function unwatch(path:String, f:FileAct->Void):Void {
		//todo: unwatch for not exists files
		if (watched.exists(path))
			watched.get(path).removeListener(f);
	}
	
}