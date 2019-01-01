package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;

/**
 * FontStyle
 * @author AxGord <axgord@gmail.com>
 */
typedef FontStyle = {font : String, size : Float, color : pony.color.Color, ?bold : Bool, ?italic : Bool, ?underline : Bool, ?align:Align, ?border:Border<Int>};