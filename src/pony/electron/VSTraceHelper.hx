package pony.electron;

import haxe.Log;

import js.Node;

/**
 * Visual Studio Code Trace Nodejs Helper
 * Using stderr for output
 * @author AxGord <axgord@gmail.com>
 */
class VSTraceHelper extends pony.Logable {

	private function new() {
		super();
		Log.trace = traceHandler;
		onLog << logHandler;
		onError << errorHandler;
	}

	private static function traceHandler(v:Any, ?p:haxe.PosInfos):Void {
		Node.console.warn('\x1b[32m${p.fileName}:${p.lineNumber}: $v');
	}

	private static function logHandler(v:String, ?p:haxe.PosInfos):Void {
		Node.console.warn('\x1b[34m${p.fileName}:${p.lineNumber}: $v');
	}

	private static function errorHandler(v:String, ?p:haxe.PosInfos):Void {
		Node.console.error('${p.fileName}:${p.lineNumber}: $v');
	}

}