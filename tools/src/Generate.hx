/**
 * Generate
 * @author AxGord <axgord@gmail.com>
 */
class Generate {

	private static var WEB_PAGES_PATH: String = 'bin/home/templates/Default/pages/';
	private static var WEB_MODELS_PATH: String = 'src/models/';
	private static var WEB_MODEL_TEMPLATE_PATH: String = 'webmodel/';

	public static function run(type: String, name: String): Void {
		if (name == null) Utils.error('Name not set');
		switch type {
			case 'webmodels', 'web', 'w':
				genWebModule(name);
			case _:
				Utils.error('Unknown type');
		}
	}

	private static function genWebModule(name: String): Void {
		Template.gen(WEB_MODEL_TEMPLATE_PATH, [
			'Model.hx' => '$WEB_MODELS_PATH::NAME::.hx',
			'Template.tpl' => '$WEB_PAGES_PATH::name::.tpl',
			'RMTemplate.tpl' => '${WEB_PAGES_PATH}rm::name::.tpl',
		], [
			'NAME' => name,
			'name' => name.toLowerCase()
		]);
	}

}
