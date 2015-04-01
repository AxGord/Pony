/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.time;
import pony.events.Signal;
import pony.events.Signal1.Signal1;
import pony.magic.Declarator;
import pony.time.DTimer;
using pony.Tools;
/**
 * Clock
 * @author AxGord <axgord@gmail.com>
 */
class RealClock implements Declarator {

	public static var dateSep:String = '-';
	public static var months:Array<String> = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'];
	public static var invertDate:Bool = false;
	
	public static var updateTime:Signal1<Void,String> = Signal.createEmpty();
	public static var updateDate:Signal1<Void,String> = Signal.createEmpty();
	
	private static function __init__():Void {
		updateTime.takeListeners << enableTime;
		updateDate.takeListeners << enableDate;
		updateTime.lostListeners << disableTime;
		updateDate.lostListeners << disableDate;
	}
	
	private static function enableTime():Void DeltaTime.fixedUpdate << updaterTime;
	private static function disableTime():Void DeltaTime.fixedUpdate >> updaterTime;
	
	private static function updaterTime():Void updateTime.dispatch((DeltaTime.nowDate:Time).clock());
	
	private static function enableDate():Void DeltaTime.fixedUpdate << updaterDate;
	private static function disableDate():Void DeltaTime.fixedUpdate >> updaterDate;
	
	private static function updaterDate():Void {
		var d = DeltaTime.nowDate;
		var a:Array<String> = [Std.string(d.getFullYear()), months[d.getMonth()], d.getDate().toFixed('00')];
		if (invertDate) a.reverse();
		updateDate.dispatch(a.join(dateSep));
	}
	
	inline public static function localeRus():Void {
		dateSep = ' ';
		invertDate = true;
		months = ['января','февраля','марта','апреля','мая','июня','июля','августа','сентября','октября','ноября','декабря'];
	}
	
}