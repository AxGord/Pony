package pony.ui.touch;

import pony.events.Event0;
import pony.events.Event1;

/**
 * @author AxGord <axgord@gmail.com>
 */
interface TouchableBaseEvents {

	var eOver: Event1<Touch>;
	var eOut: Event1<Touch>;
	var eOutUp: Event1<Touch>;
	var eOverDown: Event1<Touch>;
	var eOutDown: Event1<Touch>;
	var eDown: Event1<Touch>;
	var eUp: Event1<Touch>;
	var eClick: Event0;
}