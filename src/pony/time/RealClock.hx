package pony.time;

import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DTimer;

using pony.Tools;

/**
 * Clock
 * @author AxGord <axgord@gmail.com>
 */
class RealClock implements Declarator implements HasSignal {

	public static var dateSep:String = '-';
	public static var months:Array<String> = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
	public static var invertDate:Bool = false;
	
	@:auto public static var updateTime:Signal1<String>;
	@:auto public static var updateDate:Signal1<String>;
	
	private static function __init__():Void {
		eUpdateTime.onTake << enableTime;
		eUpdateDate.onTake << enableDate;
		eUpdateTime.onLost << disableTime;
		eUpdateDate.onLost << disableDate;
	}
	
	private static function enableTime():Void DeltaTime.fixedUpdate << updaterTime;
	private static function disableTime():Void DeltaTime.fixedUpdate >> updaterTime;
	
	private static function updaterTime():Void eUpdateTime.dispatch((DeltaTime.nowDate:Time).clock());
	
	private static function enableDate():Void DeltaTime.fixedUpdate << updaterDate;
	private static function disableDate():Void DeltaTime.fixedUpdate >> updaterDate;
	
	private static function updaterDate():Void {
		var d = DeltaTime.nowDate;
		var a:Array<String> = [Std.string(d.getFullYear()), months[d.getMonth()], d.getDate().toFixed('00')];
		if (invertDate) a.reverse();
		eUpdateDate.dispatch(a.join(dateSep));
	}
	
	inline public static function localeRus():Void {
		dateSep = ' ';
		invertDate = true;
		months = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
	}
	
}