package pony.text.tpl.style;

import pony.text.tpl.TplData.TplStyle;

/**
 * DefaultStyle
 * @author AxGord
 */
class DefaultStyle {

	public static var get:TplStyle = {
			begin: '<_',
			end: '>',
			endClose: '/>',
			closeBegin: '</_',
			closeEnd: '>',
			shortBegin: '%',
			shortEnd: '%',
			args: {
				begin: ' ',
				end: '',
				delemiter: ' ',
				set: '=',
				valueq: '"',
				qalltime: false,
				nonamearg: true
			},
			group: '-',
			up: '-',
			space: true
		};
	
}