package pony.flash.ui;
import pony.events.Signal;

/**
 * @author Maletin
 */

interface IScrollBar 
{
	public var size(get, set):Float;
	public var total(default, set):Float;
	public var position(get,set):Float;
	public var isVert:Bool;
	public var update:Signal;
	public function setPositionPercent(p:Float):Void;
}