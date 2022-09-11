package pony.ui.gui.slices;

import pony.time.Time;

/**
 * SliceData
 * @author AxGord <axgord@gmail.com>
 */
enum SliceData {
	Not(?s: String);
	Vert2(?a: Array<String>);
	Hor2(?a: Array<String>);
	Vert3(?a: Array<String>);
	Hor3(?a: Array<String>);
	Four(?a: Array<String>);
	Vert6(?a: Array<String>);
	Hor6(?a: Array<String>);
	Nine(?a: Array<String>);
	Anim(?speed: Float, ?delay: Time, ?a: Array<String>);
}