package module;

import pony.Fast;
import pony.text.TextTools;

import sys.FileSystem;

import types.BASection;
import types.UglifyConfig;

/**
 * Uglify module
 * @author AxGord <axgord@gmail.com>
 */
class Uglify extends NModule<UglifyConfig> {

	private static inline var PRIORITY: Int = 3;
	private static inline var REMOVE_CACHE_PRIORITY: Int = -120;
	public static var CACHE_FILE: String = 'libcache.js';

	public function new() super('uglify');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void {
		if (xml == null) return;
		initSections(PRIORITY, BASection.Build);
		modules.commands.onPrepare.add(removeCache, REMOVE_CACHE_PRIORITY);
	}

	private function removeCache(): Void {
		if (FileSystem.exists(CACHE_FILE)) FileSystem.deleteFile(CACHE_FILE);
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new UglifyReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			sourcemap: {
				input: null,
				output: null,
				url: null,
				source: null,
				offset: 0
			},
			mangle: false,
			compress: false,
			libcache: null,
			output: '',
			input: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	#if (haxe_ver < 4.2) override #end
	private function writeCfg(protocol: NProtocol, cfg: Array<UglifyConfig>): Void {
		if (TextTools.isTrue(Sys.getEnv('PONY_FORCE_DISABLE_LIBCACHE'))) for (c in cfg) c.libcache = null;
		protocol.uglifyRemote(cfg);
	}

}

private class UglifyReader extends BAReader<UglifyConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.output = null;
		cfg.input = [];
		cfg.sourcemap = {
			input: null,
			output: null,
			url: null,
			source: null,
			offset: 0
		};
		cfg.mangle = false;
		cfg.compress = false;
		cfg.libcache = null;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'libcache': cfg.libcache = TextTools.isTrue(val) ? Uglify.CACHE_FILE : null;
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'output': cfg.output = normalize(xml.innerData);
			case 'input': cfg.input.push(normalize(xml.innerData));
			case 'sourcemap':
				var offset: Null<Int> = xml.hasNode.offset ? Std.parseInt(xml.node.offset.innerData) : null;
				if (offset == null) offset = 0;
				cfg.sourcemap = {
					input: normalize(xml.node.input.innerData),
					output: normalize(xml.node.output.innerData),
					url: normalize(xml.node.url.innerData),
					source: normalize(xml.node.source.innerData),
					offset: offset
				};
			case 'm', 'mangle': cfg.mangle = true;
			case 'c', 'compress': cfg.compress = true;
			case 'libcache': cfg.libcache = Uglify.CACHE_FILE;
			case _: super.readNode(xml);
		}
	}

}