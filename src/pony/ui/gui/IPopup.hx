package pony.ui.gui;

/**
 * IPopup
 * @author AxGord <axgord@gmail.com>
 */
interface IPopup {

	dynamic function onClose(): Void;
	function destroyPopup(): Void;

}