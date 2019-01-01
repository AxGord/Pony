package pony.text.tpl.style;

import pony.text.tpl.TplData.TplStyle;

/**
 * SquareStyle
 * @author AxGord
 */
class SquareStyle {

	public static var get:TplStyle = {
			begin: '[',
			end: ']',
			endClose: '/]',
			closeBegin: '[/',
			closeEnd: ']',
			shortBegin: '$',
			shortEnd: '',
			args: {
				begin: '{',
				end: '}',
				delemiter: ',',
				set: ':',
				valueq: '"',
				qalltime: false,
				nonamearg: true
			},
			group: '>',
			up: '^',
			space: true
		};
	
}