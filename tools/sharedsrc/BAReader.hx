import pony.Fast;
import pony.text.XmlConfigReader;
import types.BAConfig;
import types.BASection;

/**
 * BAReader
 * @author AxGord <axgord@gmail.com>
 */
class BAReader<T:BAConfig> extends XmlConfigReader<T> implements pony.magic.HasAbstract {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'before':
				var cfg = copyCfg();
				cfg.before = true;
				_selfCreate(xml, cfg);
			case 'after':
				var cfg = copyCfg();
				cfg.before = false;
				_selfCreate(xml, cfg);
			case 'server': createSection(xml, Server);
			case 'prepare': createSection(xml, Prepare);
			case 'build': createSection(xml, Build);
			case 'cordova': createSection(xml, Cordova);
			case 'android': createSection(xml, Android);
			case 'iphone': createSection(xml, Iphone);
			case 'electron': createSection(xml, Electron);
			case 'run': createSection(xml, Run);
			case 'zip': createSection(xml, Zip);
			case 'hash': createSection(xml, Hash);
			case 'remote': createSection(xml, Remote);
			case 'unpack': createSection(xml, Unpack);
			/* case 'module':
				var name = StringTools.trim(xml.innerData);
				if (pony.text.XmlTools.isTrue(xml, after));
					cfg.runAfter.push(name);
				else
					cfg.runBefore.push(name); */

			case _: throw 'Unknown tag: ${xml.name}';
		}
	}

	private function createSection(xml:Fast, section:BASection):Void {
		var cfg = copyCfg();
		clean();
		cfg.section = section;
		_selfCreate(xml, cfg);
	}

	@:abstract private function clean():Void;

	override private function end():Void if (cfg.allowCfg) onConfig(cfg);

	private function allowCreate(xml:Fast):Void {
		var cfg:T = copyCfg();
		cfg.allowCfg = true;
		_selfCreate(xml, cfg);
	}

	private function denyCreate(xml:Fast):Void {
		var cfg:T = copyCfg();
		cfg.allowCfg = false;
		_selfCreate(xml, cfg);
	}

}