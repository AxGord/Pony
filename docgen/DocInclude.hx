import haxe.macro.Compiler;

final exept: Map<String, Array<String>> = [
	'openfl' => [
		'pony.openfl',
		'pony.ui.touch.openfl',
		'pony.ui.touch.lime',
		'pony.ui.xml.OpenflXmlUi'
	],
	'flash' => [
		'pony.flash',
		'pony.ui.touch.flash'
	],
	'starling' => ['pony.ui.touch.starling', 'pony.flash.starling'],
	'pixi' => [
		'pony.pixi',
		'pony.ui.touch.pixi',
		'pony.ui.xml.PixiXmlUi',
	],
	'heaps' => [
		'pony.heaps',
		'pony.ui.touch.heaps',
		'pony.ui.xml.HeapsXmlUi',
		'pony.ui.keyboard.heaps'
	],
	'cc' => ['pony.cc'],
	'cs' => ['pony.cs'],
	'unity' => [
		'pony.unity3d',
		'pony.ui.touch.starling.touchManager.hitTestSources.UnityHitTestSource',
		'pony.ui.keyboard.unity'
	],
	'html' => ['pony.html', 'pony.HtmlVideo'],
	'js' => ['pony.js', 'pony.JsTools', 'pony.ui.keyboard.js'],
	'node' => ['pony.nodejs', 'pony.sys.nodejs', 'pony.fs.nodejs', 'pony.midi', 'pony.NPM'],
	'php' => ['pony.net.http.platform.php'],
	'kb' => ['pony.ui.keyboard'],
	'http' => ['pony.net.http'],
	'xr' => ['pony.xr'],
	'electron' => ['pony.electron'],
	'fsdep' => [
		'pony.text.tpl.Templates',
		'pony.text.tpl.TplSystem',
		'pony.text.tpl.TplDir',
		'pony.LangTable',
		'pony.net.rpc.RPCFileTransport'
	],
	'db' => ['pony.db'],
	'protobuf' => ['pony.net.Protobuf'],
	'magic' => ['pony.magic', 'pony.macro'],
	'sys' => ['pony.ZipTool', 'pony.ThreadTasks', 'pony.time.MainLoop'],
	'haxe3only' => ['pony.flash.GetFromStage', 'pony.flash.Exterface'],
	'mconsole' => ['pony.flash.mconsole'],
	'ui' => ['pony.ui'],
	'nape' => ['pony.physics.nape']
];

function include(exeptList: Array<String>) Compiler.include('pony', true, [for (e in exeptList) for (cl in exept[e]) cl]);

function cs() include([
	'openfl', 'flash', 'starling', 'pixi', 'heaps', 'cc', 'unity', 'html', 'js', 'node', 'kb', 'http',
	'xr', 'electron', 'fsdep', 'db', 'protobuf', 'magic', 'haxe3only'
]);

function fl() include([
	'openfl', 'starling', 'cs', 'pixi', 'heaps', 'cc', 'unity', 'html', 'js', 'node', 'http',
	'xr', 'electron', 'fsdep', 'db', 'protobuf', 'magic', 'sys', 'haxe3only', 'mconsole', 'nape'
]);

function neko() include([
	'openfl', 'flash', 'cs', 'starling', 'pixi', 'heaps', 'cc', 'unity', 'html', 'js', 'node', 'kb', 'http',
	'xr', 'electron', 'fsdep', 'db', 'protobuf', 'magic', 'haxe3only', 'ui'
]);

function node() include([
	'openfl', 'flash', 'cs', 'starling', 'pixi', 'heaps', 'cc', 'unity', 'html', 'kb',
	'xr', 'electron', 'fsdep', 'db', 'protobuf', 'magic', 'haxe3only', 'ui', 'php', 'http'
]);