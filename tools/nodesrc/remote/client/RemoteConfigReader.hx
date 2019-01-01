package remote.client;

import haxe.xml.Fast;
import pony.text.XmlConfigReader;
import types.RemoteConfig;

/**
 * RemoteConfigReader
 * @author AxGord <axgord@gmail.com>
 */
class RemoteConfigReader extends XmlConfigReader<RemoteConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'host': cfg.host = StringTools.trim(xml.innerData);
			case 'port': cfg.port = Std.parseInt(xml.innerData);
			case 'key': cfg.key = StringTools.trim(xml.innerData);

			case 'get': cfg.commands.push(Get(StringTools.trim(xml.innerData)));
			case 'send': cfg.commands.push(Send(StringTools.trim(xml.innerData)));
			case 'exec': cfg.commands.push(Exec(StringTools.trim(xml.innerData)));
			case 'command': cfg.commands.push(Command(StringTools.trim(xml.innerData)));

			case _: super.readNode(xml);
		}
	}

}