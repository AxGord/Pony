/**
 * Gen
 * @author AxGord <axgord@gmail.com>
 */
class Gen {

	private static var WEB_PAGES_PATH: String = 'bin/home/templates/Default/pages/';
	private static var WEB_MODULES_PATH: String = 'modules/';

	public static function run(type: String, args: Array<String>): Void {
		var name: String = args.shift();
		if (name == null) Utils.error('Name not set');
		switch type {
			case 'webmodule':
				genWebModule(name);
			case _:
				Utils.error('Unknown type');
		}
	}

	private static function genWebModule(name: String): Void {
		gen([
			'Module.hx' => '$WEB_MODULES_PATH/::NAME::.hx',
			'Template.tpl' => '$WEB_PAGES_PATH/::name::.tpl',
			'RMTemplate.tpl' => '$WEB_PAGES_PATH/::name::.tpl',
		], [
			'NAME' => name,
			'name' => name.toLowerCase()
		]);
	}

	public static function gen(files: Map<String, String>, vars: Map<String, String>): Void {
		// todo
	}

}
