package module;

import pony.Fast;
import pony.magic.HasAbstract;

import types.BAConfig;
import types.BASection;

/**
 * CfgModule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
#if (haxe_ver >= 4.2) abstract #end
class CfgModule<T:BAConfig> extends Module implements HasAbstract {

	private var lastcfgs: Array<T> = [];
	private var allcfgs: Array<Array<T>> = [];

	#if (haxe_ver < 4.2)
	override public function init(): Void throw 'Abstract';
	#end

	private function configHandler(cfg: T): Void lastcfgs.push(cfg);

	private function savecfg(): Void {
		if (lastcfgs.length > 0) {
			allcfgs.push(lastcfgs);
			lastcfgs = [];
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function readConfig(ac: AppCfg): Void {
		for (xml in nodes) {
			readNodeConfig(xml, ac);
			for (cfg in lastcfgs) cfg.group = parseGroup(xml);
			savecfg();
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function runModule(before: Bool, section: BASection): Void {
		for (cfgs in allcfgs) {
			var actual: Array<T> = [
				for (cfg in cfgs) if (cfg.before == before && cfg.section == section && modules.checkAllowGroups(cfg.group)) cfg
			];
			if (actual.length > 0) addToRun(run.bind(actual));
		}
	}

	private function run(cfg: Array<T>): Void {
		for (e in cfg) runNode(e);
		finishCurrentRun();
	}

	private function readNodeConfig(xml: Fast, ac: AppCfg): Void {}
	private function runNode(cfg: T): Void {}

}