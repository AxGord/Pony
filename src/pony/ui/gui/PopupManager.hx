package pony.ui.gui;

import pony.time.DeltaTime;

/**
 * PopupManager
 * @author AxGord <axgord@gmail.com>
 */
class PopupManager<Popup> {

	public var onStartClose: Void -> Void;

	private var list: Array<Popup> = [];
	private var wantFromList: Bool = false;
	private var current: IPopup;

	public function new() {}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function clearList(): Void list = [];

	public function showPopup(type: Popup): Void {
		if (current == null && !wantFromList) {
			_showPopup(type);
		} else {
			list.push(type);
		}
	}

	public function hardPopup(type: Popup): Void {
		abortFromList();
		list = [];
		endClose();
		_showPopup(type);
	}

	public dynamic function getPopup(type: Popup): IPopup return throw 'Method not set';

	public dynamic function onClose(): Void {}

	public function close(): Void {
		if (abortFromList()) return;
		if (current == null) return;
		if (onStartClose != null)
			onStartClose();
		else
			endClose();
	}

	public function endClose(): Void {
		if (current == null) return;
		current.destroyPopup();
		current = null;
		onClose();
		if (wantFromList || list.length <= 0) return;
		wantFromList = true;
		DeltaTime.fixedUpdate < showFromList;
	}

	private function _showPopup(type: Popup): Void {
		current = getPopup(type);
		current.onClose = close;
	}

	private function abortFromList(): Bool {
		if (!wantFromList) return false;
		wantFromList = false;
		DeltaTime.fixedUpdate >> showFromList;
		return true;
	}

	private function showFromList(): Void {
		wantFromList = false;
		_showPopup(list.shift());
	}

}
