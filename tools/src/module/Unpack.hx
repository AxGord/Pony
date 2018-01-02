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

import haxe.xml.Fast;
import types.BASection;

/**
 * Unpack module
 * @author AxGord <axgord@gmail.com>
 */
class Unpack extends Module {

	private var beforeZips:Map<BASection, Array<ZipConfig>> = new Map();
	private var afterZips:Map<BASection, Array<ZipConfig>> = new Map();

	public function new() super('unpack');

	override public function init():Void {
		if (xml == null) return;

		modules.commands.onServer.once(emptyConfig, -20);
		modules.commands.onPrepare.once(getConfig, -20);
		modules.commands.onBuild.once(getConfig, -20);
		modules.commands.onRun.once(getConfig, -20);
		modules.commands.onZip.once(getConfig, -20);

		modules.commands.onServer.once(before.bind(Server), -5);
		modules.commands.onPrepare.once(before.bind(Prepare), -5);
		modules.commands.onBuild.once(before.bind(Build), -5);
		modules.commands.onRun.once(before.bind(Run), -5);
		modules.commands.onZip.once(before.bind(Zip), -5);

		modules.commands.onServer.once(after.bind(Server), 5);
		modules.commands.onPrepare.once(after.bind(Prepare), 5);
		modules.commands.onBuild.once(after.bind(Build), 5);
		modules.commands.onRun.once(after.bind(Run), 5);
		modules.commands.onZip.once(after.bind(Zip), 5);
	}

	private function readConfig(ac:AppCfg):Void {

		modules.commands.onServer >> emptyConfig;
		modules.commands.onPrepare >> getConfig;
		modules.commands.onBuild >> getConfig;
		modules.commands.onRun >> getConfig;
		modules.commands.onZip >> getConfig;
		
		new UnpackReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			zips: []
		}, configHandler);
	}

	private function getConfig(a:String, b:String):Void readConfig(Utils.parseArgs([a, b]));

	private function emptyConfig():Void readConfig({debug:false, app:null}); 

	private function configHandler(cfg:UnpackConfig):Void {
		if (cfg.zips.length == 0) return;
		if (cfg.before) {
			if (beforeZips.exists(cfg.section))
				beforeZips[cfg.section] = beforeZips[cfg.section].concat(cfg.zips);
			else
				beforeZips[cfg.section] = cfg.zips;
		} else {
			if (afterZips.exists(cfg.section))
				afterZips[cfg.section] = afterZips[cfg.section].concat(cfg.zips);
			else
				afterZips[cfg.section] = cfg.zips;
		}
	}

	private function before(section:BASection):Void {
		if (!beforeZips.exists(section)) return;
		for (c in beforeZips[section]) unzip(c);
	}

	private function after(section:BASection):Void {
		if (!afterZips.exists(section)) return;
		for (c in afterZips[section]) unzip(c);
	}

	private function unzip(c:ZipConfig):Void {
		log('Unzip: ' + c.file);
		for (e in haxe.zip.Reader.readZip(sys.io.File.read(c.file))) {
			Sys.println(e.fileName);
			var f:String = c.path + e.fileName;
			Utils.createPath(f);
			sys.io.File.saveBytes(f, haxe.zip.Reader.unzip(e));
		}
		if (c.rm) {
			log('Delete: ' + c.file);
			sys.FileSystem.deleteFile(c.file);
		}

	}
	
}

private typedef ZipConfig = {
	path: String,
	file: String,
	rm: Bool
}

private typedef UnpackConfig = { > types.BAConfig,
	zips: Array<ZipConfig>
}

private class UnpackReader extends BAReader<UnpackConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'zip': cfg.zips.push({
				path: try StringTools.trim(xml.innerData) catch (_:Any) '',
				file: xml.att.file,
				rm: xml.has.rm && xml.att.rm.toLowerCase() == 'true'
			});

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.zips = [];
	}

}
