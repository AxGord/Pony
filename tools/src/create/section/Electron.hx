package create.section;

import pony.text.XmlTools;

/**
 * Electron
 * @author AxGord <axgord@gmail.com>
 */
class Electron extends Section {

	public function new() super('electron');

	#if (haxe_ver < 4.2) override #end
	public function result(): Xml {
		init();
		set('win', 'true');
		set('win32', 'true');
		set('linux', 'true');
		set('mac', 'true');
		set('pack', 'true');
		return xml;
	}
}