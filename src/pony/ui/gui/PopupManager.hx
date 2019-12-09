package pony.ui.gui;

import pony.time.DeltaTime;

/**
 * PopupManager
 * @author AxGord <axgord@gmail.com>
 */
class PopupManager<Popup> {

	private var list: Array<Popup> = [];
	private var current: IPopup;
	private var wantFromList: Bool = false;

	public var onStartClose: Void -> Void;

	public function new() {}

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

	private function _showPopup(type: Popup): Void {
		current = getPopup(type);
		current.onClose = close;
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
		if (!wantFromList && list.length > 0 ) {
			wantFromList = true;
			DeltaTime.fixedUpdate < showFromList;
		}
	}

	private function abortFromList(): Bool {
		if (wantFromList) {
			wantFromList = false;
			DeltaTime.fixedUpdate >> showFromList;
			return true;
		} else {
			return false;
		}
	}

	private function showFromList(): Void {
		wantFromList = false;
		_showPopup(list.shift());
	}

	@:extern public inline function clearList(): Void list = [];

}