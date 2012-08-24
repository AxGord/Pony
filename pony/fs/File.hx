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

import pony.events.Signal;
import pony.Priority;
import pony.fs.SimplePath;

using StringTools;
using pony.Ultra;

/**
 * @author AxGord
 */

class File
{
	public var list:Priority<String>;
	public var content(getContent, setContent):String;
	public var dir(getDir, setDir):Dir;
	public var exists(getExists, null):Bool;
	public var ext(getExt, null):String;
	public var name(getName, setName):String;
	public var fullName(getFullName, null):String;
	
	public var onUpdate:Signal;
	public var onRemove:Signal;
	
	public function new(?f:String, ?a:Array<String>)
	{
		onUpdate = new Signal();
		onUpdate.haveListener = haveUpdateListener;
		onUpdate.lostListener = lostUpdateListener;
		onRemove = new Signal();
		onRemove.haveListener = haveRemoveListener;
		onRemove.lostListener = lostUpdateListener;
		list = new Priority<String>(f, a);
	}
	
	public inline function toString():String {
		return list.toString();
	}
	
	private function getExists():Bool {
		for (f in list)
			if (SimplePath.exists(f) && SimplePath.isFile(f))
				return true;
		return false;
	}
	
	private function getContent():String {
		for (e in list)
			if (SimplePath.exists(e) && SimplePath.isFile(e))
				return SimpleFile.getContent(e);
		throw 'File not exists';
	}
	
	private function setContent(c:String):String {
		try {
			SimpleFile.setContent(list.first, c);
		} catch (e:String) {
			dir.create();
			SimpleFile.setContent(list.first, c);
		}
		return c;
	}
	
	private function getDir():Dir {
		var a:Array<String> = [];
		for (f in list)
			a.push(SimplePath.dir(f));
		return new Dir(a);
	}
	
	
	private function setDir(dir:Dir):Dir {
		var d:String = dir.list.first;
		if (!d.endsWith('/')) d += '/';
		if (SimplePath.exists(list.first)) {
			SimplePath.rename(list.first, d + name);
		}
		list.clear();
		list.add(d + name);
		return dir;
	}
	
	public inline function delete():Void {
		SimpleFile.delete(list.first);
	}
	
	private inline function getExt():String {
		return SimplePath.ext(list.first);
	}
	
	private function getName():String {
		var a:Array<String> = list.first.split('/');
		return a.pop();
	}
	
	private function setName(n:String):String {
		if (SimplePath.exists(list.first)) {
			SimplePath.rename(list.first, dir.list.first + n);
		}
		list.clear();
		list.add(dir.list.first + n);
		return n;
	}
	
	private function getFullName():String {
		return SimplePath.full(list.first);
	}
	
	public function withoutExtension():String {
		return SimplePath.withoutExtension(name);
	}
	
	private function haveUpdateListener():Void {
		for (f in list)
			SimplePath.watch(f, dispatchIfUpdate);
	}
	
	private function lostUpdateListener():Void {
		for (f in list)
			SimplePath.unwatch(f, dispatchIfUpdate);
	}
	
	private function haveRemoveListener():Void {
		for (f in list)
			SimplePath.watch(f, dispatchIfRemove);
	}
	
	private function lostRemoveListener():Void {
		for (f in list)
			SimplePath.unwatch(f, dispatchIfRemove);
	}
	
	public function listToFileArray():Array<File> {
		return list.array.map(function(s:String):File return new File(s));
	}
	
	public function getFirstExists():String {
		for (f in list)
			if (SimplePath.exists(f) && SimplePath.isFile(f))
				return f;
		return null;
	}
	
	/**
	 * Copy this file to dest or new file
	 */
	public function copy(?dest:Dir, ?file:File):Void {
		//trace(fullName + ' copy to ' + dest.full()+name);
		if (dest != null)
			SimplePath.copy(fullName, dest.full() + name);
		else
			SimplePath.copy(fullName, file.fullName);
	}
	
	private function dispatchIfUpdate(a:FileAct):Void {
		if (a == Update) onUpdate.dispatch();
		else if (a == Create) {
			var e:Bool = false;
			for (f in list)
				if (e) {
					if (SimplePath.exists(f)) {
						onUpdate.dispatch();
						break;
					}
				} else if (SimplePath.exists(f))
					e = true;
		}
	}
	
	private function dispatchIfRemove(a:FileAct):Void {
		if (a == Remove) {
			if (!exists)
				onRemove.dispatch();
			else
				onUpdate.dispatch();
		}
	}
}