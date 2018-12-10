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
package module;

import pony.Tools;
import haxe.xml.Fast;
import pony.Queue;
import types.BASection;
import pony.events.Signal0;

/**
 * Module
 * @author AxGord <axgord@gmail.com>
 */
class Module extends pony.Logable implements pony.magic.HasAbstract implements pony.magic.HasLink {

	@:auto public static var onEndQueue:Signal0;
	public static var busy(link, never):Bool = GLOBALQUEUE.busy;

	private static inline var CONFIG_PRIORITY:Int = -100;
	private static var GLOBALQUEUE:Queue<(() -> Void) -> Void> = new Queue<(() -> Void) -> Void>(globalRunNextRun);

	public var modules:Modules;
	private var xml(get, never):Fast;
	#if (haxe_ver >= "4.0.0")
	private var nodes(get, never):Array<Fast>;
	#else
	private var nodes(get, never):List<Fast>;
	#end
	private var _xml:Fast;
	private var xname:String;
	private var currentSection:BASection;
	private var startTime:Float;

	public function new(?xname:String) {
		super();
		this.xname = xname;
	}

	private function get_xml():Fast {
		if (_xml == null)
			_xml = xname == null ? modules.xml : modules.getNode(xname);
		return _xml;
	}

	#if (haxe_ver >= "4.0.0")
	private function get_nodes():Array<Fast> {
		return xname == null ? [] : modules.xml.nodes.resolve(xname);
	}
	#else
	private function get_nodes():List<Fast> {
		return xname == null ? new List<Fast>() : modules.xml.nodes.resolve(xname);
	}
	#end

	private static function globalRunNextRun(fn:Void -> Void):Void fn();
	public static function lockQueue():Void GLOBALQUEUE.call(Tools.nullFunction0);
	public static function unlockQueue():Void GLOBALQUEUE.next();

	private function addToRun(fn:Void -> Void):Void {
		GLOBALQUEUE.call(function():Void {
			begin();
			fn();
		});
	}

	private function finishCurrentRun():Void {
		end();
		GLOBALQUEUE.next();
		if (!GLOBALQUEUE.busy)
			eEndQueue.dispatch();
	}

	private function begin():Void {
		log('Start $xname');
		startTime = Sys.time();
	}

	private function end():Void {
		log('Complete $xname, time: ' + Std.int((Sys.time() - startTime) * 1000) / 1000);
	}

	@:abstract public function init():Void;
	private function runModule(before:Bool, section:BASection):Void throw 'Abstract';
	private function readConfig(ac:AppCfg):Void {}

	private function initSections(priority:Int, ?current:BASection):Void {
		if (xml == null) return;
		currentSection = current;
		addConfigListener();
		addListeners(priority, moduleBefore, moduleAfter);
		
		if (current != null) switch current {
			case Server: modules.commands.onServer.once(moduleStart, priority);
			case Prepare: modules.commands.onPrepare.once(moduleStart, priority);
			case Build: modules.commands.onBuild.once(moduleStart, priority);
			case Run: modules.commands.onRun.once(moduleStart, priority);
			case Zip: modules.commands.onZip.once(moduleStart, priority);
			case Remote: modules.commands.onRemote.once(moduleStart, priority);
			case Hash: modules.commands.onHash.once(moduleStart, priority);
			case Unpack: modules.commands.onUnpack.once(moduleStart, priority);
		}
	}

	private function moduleStart():Void runModule(false, currentSection);
	private function moduleBefore(section:BASection):Void if (section != currentSection) runModule(true, section);
	private function moduleAfter(section:BASection):Void if (section != currentSection) runModule(false, section);

	private function addConfigListener():Void {
		modules.commands.onServer.once(emptyConfig, CONFIG_PRIORITY);
		modules.commands.onPrepare.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onBuild.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onRun.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onZip.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onRemote.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onHash.once(getConfig, CONFIG_PRIORITY);
		modules.commands.onUnpack.once(getConfig, CONFIG_PRIORITY);
	}

	private function removeConfigListener():Void {
		modules.commands.onServer >> emptyConfig;
		modules.commands.onPrepare >> getConfig;
		modules.commands.onBuild >> getConfig;
		modules.commands.onRun >> getConfig;
		modules.commands.onZip >> getConfig;
		modules.commands.onRemote >> getConfig;
		modules.commands.onHash >> emptyConfig;
		modules.commands.onUnpack >> emptyConfig;
	}

	private function addListeners(priority:Int, before:BASection -> Void, after:BASection -> Void):Void {
		modules.commands.onServer.once(before.bind(Server), CONFIG_PRIORITY + priority);
		modules.commands.onPrepare.once(before.bind(Prepare), CONFIG_PRIORITY + priority);
		modules.commands.onBuild.once(before.bind(Build), CONFIG_PRIORITY + priority);
		modules.commands.onRun.once(before.bind(Run), CONFIG_PRIORITY + priority);
		modules.commands.onZip.once(before.bind(Zip), CONFIG_PRIORITY + priority);
		modules.commands.onRemote.once(before.bind(Remote), CONFIG_PRIORITY + priority);
		modules.commands.onHash.once(before.bind(Hash), CONFIG_PRIORITY + priority);
		modules.commands.onUnpack.once(before.bind(Unpack), CONFIG_PRIORITY + priority);

		modules.commands.onServer.once(after.bind(Server), priority);
		modules.commands.onPrepare.once(after.bind(Prepare), priority);
		modules.commands.onBuild.once(after.bind(Build), priority);
		modules.commands.onRun.once(after.bind(Run), priority);
		modules.commands.onZip.once(after.bind(Zip), priority);
		modules.commands.onRemote.once(after.bind(Remote), priority);
		modules.commands.onHash.once(after.bind(Hash), priority);
		modules.commands.onUnpack.once(after.bind(Unpack), priority);
	}

	private function getConfig(a:String, b:String):Void {
		removeConfigListener();
		readConfig(Utils.parseArgs([a, b]));
	}

	private function emptyConfig():Void {
		removeConfigListener();
		readConfig({debug:false, app:null});
	}

}