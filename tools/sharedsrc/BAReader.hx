import pony.Fast;
import pony.geom.Point;
import pony.magic.HasAbstract;
import pony.text.XmlConfigReader;
import types.BAConfig;
import types.BASection;

/**
 * BAReader
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
#if (haxe_ver >= 4.2) abstract #end
class BAReader<T:BAConfig> extends XmlConfigReader<T> implements HasAbstract {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'before':
				final cfg: T = copyCfg();
				cfg.before = true;
				_selfCreate(xml, cfg);
			case 'after':
				final cfg: T = copyCfg();
				cfg.before = false;
				_selfCreate(xml, cfg);
			case 'server':
				createSection(xml, Server);
			case 'prepare':
				createSection(xml, Prepare);
			case 'build':
				createSection(xml, Build);
			case 'cordova':
				createSection(xml, Cordova);
			case 'android':
				createSection(xml, Android);
			case 'iphone':
				createSection(xml, Iphone);
			case 'electron':
				createSection(xml, Electron);
			case 'run':
				createSection(xml, Run);
			case 'zip':
				createSection(xml, Zip);
			case 'ftp':
				createSection(xml, Ftp);
			case 'hash':
				createSection(xml, Hash);
			case 'remote':
				createSection(xml, Remote);
			case 'unpack':
				createSection(xml, Unpack);
			/* case 'module':
				var name = StringTools.trim(xml.innerData);
				if (pony.text.XmlTools.isTrue(xml, after));
					cfg.runAfter.push(name);
				else
					cfg.runBefore.push(name); */

			case _:
				throw 'Unknown tag: ${xml.name}';
		}
	}

	private function createSection(xml: Fast, section: BASection): Void {
		final cfg: T = copyCfg();
		clean();
		cfg.section = section;
		_selfCreate(xml, cfg);
	}

	@:abstract private function clean(): Void;

	override private function end(): Void if (cfg.allowCfg && onConfig != null) onConfig(cfg);

	private function allowCreate(xml: Fast): Void {
		final cfg: T = copyCfg();
		cfg.allowCfg = true;
		_selfCreate(xml, cfg);
	}

	private function denyCreate(xml: Fast): Void {
		final cfg: T = copyCfg();
		cfg.allowCfg = false;
		_selfCreate(xml, cfg);
	}

	/**
	 * Reads a `WxH` or `W H` pair; a lone number is a square.
	 */
	private static function parseWh(val: String): Point<Int> {
		final a: Array<String> = val.split(val.indexOf('x') != -1 ? 'x' : ' ');
		final w: Int = parseSide(a[0]);
		return new Point<Int>(w, a.length > 1 ? parseSide(a[1]) : w);
	}

	/**
	 * One side of a size. An empty string is zero, which every caller reads as "not set"; anything
	 * else that is not a plain number throws, because the alternative is a config typo silently
	 * meaning "not set" and the build going on to produce the wrong size.
	 */
	private static function parseSide(val: String): Int {
		if (val == '') return 0;
		final v: Null<Int> = Std.parseInt(val);
		if (v == null || '$v' != val) throw 'Bad size: "$val"';
		return v;
	}

	/**
	 * A `<unit>`'s own size, falling back to the size inherited from the enclosing scope.
	 */
	private function readSize(xml: Fast, fallback: Point<Int>): Point<Int> {
		if (xml.has.wh) return parseWh(normalize(xml.att.wh));
		final w: Int = xml.has.w ? parseSide(normalize(xml.att.w)) : fallback.x;
		final h: Int = xml.has.h ? parseSide(normalize(xml.att.h)) : fallback.y;
		return new Point<Int>(w, h);
	}

}
