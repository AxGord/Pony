package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;
import pony.color.Color;

/**
 * FontStyle
 * @author AxGord <axgord@gmail.com>
 */
typedef FontStyle = {
	font: String,
	size: Float,
	color: Color,
	?bold : Bool,
	?italic : Bool,
	?underline : Bool,
	?align:Align,
	?border:Border<Int>
}