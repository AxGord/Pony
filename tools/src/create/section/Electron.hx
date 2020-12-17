package create.section;

import pony.text.XmlTools;

/**
 * Electron
 * @author AxGord <axgord@gmail.com>
 */
class Electron extends Section {

	public function new() super('electron');

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