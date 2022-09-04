package module;

import types.UglifyConfig;
import module.NModule;
import pony.NPM;
import sys.FileSystem;
import sys.io.File;

/**
 * Uglify Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Uglify extends NModule<UglifyConfig> {

	private static var MAP_EXT: String = '.map';

	override private function run(cfg: UglifyConfig): Void {
		if (cfg.input.length == 0) throw 'Not inputs';
		if (cfg.debug && cfg.libcache != null) {
			@:nullSafety(Off) var lastFile: String = cfg.input.pop();
			if (cfg.input.length == 0) {
				patchMapFile(lastFile + MAP_EXT, cfg.sourcemap.offset);
				return;
			}
			var lastContent: String = File.getContent(lastFile);
			var libdata: String = '';
			if (FileSystem.exists(cfg.libcache)) {
				libdata = File.getContent(cfg.libcache);
			} else {
				var inputContent: Dynamic<String> = {};
				for (f in cfg.input) @:nullSafety(Off) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));
				var tries: Int = 3;
				do {
					var r = NPM.uglify_js.minify(inputContent, {
						toplevel: true,
						warnings: true,
						mangle: cfg.mangle,
						compress: untyped (cfg.compress ? {} : false)
					});
					libdata = r.code;
				} while (libdata == null && --tries > 0);
				if (libdata == null) {
					error("Can't generate lib data!");
					return;
				}
				File.saveContent(cfg.libcache, libdata);
			}
			File.saveContent(lastFile, libdata + '\n' + lastContent);
			patchMapFile(lastFile + MAP_EXT, 1 + cfg.sourcemap.offset);
		} else {
			var inputContent: Dynamic<String> = {};
			for (f in cfg.input) @:nullSafety(Off) Reflect.setField(inputContent, f.split('/').pop(), File.getContent(f));

			var r = NPM.uglify_js.minify(inputContent, {
				toplevel: true,
				warnings: true,
				sourceMap: cfg.sourcemap.input == null ? null : {
					content: File.getContent(cfg.sourcemap.input),
					filename: cfg.sourcemap.source,
					url: cfg.sourcemap.url
				},
				mangle: cfg.mangle,
				compress: untyped cfg.compress ? {} : false
			});
			if (r.error != null) return error(r.error);
			File.saveContent(cfg.output, r.code);
			if (cfg.sourcemap.output != null) File.saveContent(cfg.sourcemap.output, patchMap(r.map, cfg.sourcemap.offset));
		}
	}

	public function patchMapFile(file: String, offset: Int): Void {
		if (offset == 0) return;
		File.saveContent(file, patchMap(File.getContent(file), offset));
	}

	public function patchMap(content: String, offset: Int): String {
		if (offset == 0) return content;
		log('Offset map: $offset');
		var originalMap = NPM.convert_source_map.fromJSON(content).toObject();
		var offsettedMap = NPM.offset_sourcemap_lines(originalMap, offset);
		return NPM.convert_source_map.fromObject(offsettedMap).toJSON();
	}

}