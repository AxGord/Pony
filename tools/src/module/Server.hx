package module;

/**
 * Server module
 * @author AxGord <axgord@gmail.com>
 */
class Server extends Module {

	public function new() super('server');

	override public function init():Void {
		if (xml == null) return;
		if (pony.text.XmlTools.isTrue(xml, 'keep'))
			modules.commands.onServer < Utils.runAndKeepNode.bind('ponyServer');
		else
			modules.commands.onServer < Utils.runNode.bind('ponyServer');
	}

}