/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;

import haxe.Constraints.Function;
import js.Browser;
import js.html.DOMElement;

enum UserAgent {
	IE; Edge; Chrome; Safari; Firefox; Samsung; Unknown;
}

enum OS {
	Windows; Linux(type:Linux); Android; Unknown; IOS;
}

enum Linux {
	Ubuntu; Other;
}

enum ISA {
	X32; X64; Unknown;
}

/**
 * JsTools
 * @author AxGord <axgord@gmail.com>
 */
class JsTools {

	public static var agent(get, never):UserAgent;
	public static var os(get, never):OS;
	public static var isa(get, never):ISA;
	
	public static var isMobile(get, never):Bool;
	public static var isFSE(get, never):Bool;
	
	private static var _agent:UserAgent;
	private static var _os:OS;
	private static var _isa:ISA;
	
	private static var logFunction:Function;
	
	private static function get_agent():UserAgent {
		if (_agent != null) return _agent;
		var ua = Browser.navigator.userAgent.toLowerCase();
		if (ua.indexOf('msie') != -1
		|| ua.indexOf('trident/') > 0) {
			_agent = IE;
		} else if (ua.indexOf('edge') != -1) {
			_agent = Edge;
		} else if (ua.indexOf('samsung') != -1) {
			_agent = Samsung;
		} else if (ua.indexOf('chrome') != -1) {
			_agent = Chrome;
		} else if (ua.indexOf('safari') != -1 && ua.indexOf('android') == -1) {
			_agent = Safari;
		} else if (ua.indexOf('firefox') != -1) {
			_agent = Firefox;
		} else {
			_agent = UserAgent.Unknown;
		}
		return _agent;
	}
	
	private static function get_os():OS {
		if (_os != null) return _os;
		var ua = Browser.navigator.userAgent.toLowerCase();
		if (ua.indexOf('windows') != -1) {
			_os = Windows;
		} else if (ua.indexOf('android') != -1) {
			_os = Android;
		} else if (ua.indexOf('linux') != -1) {
			if (ua.indexOf('ubuntu') != -1)
				_os = Linux(Ubuntu);
			else
				_os = Linux(Other);
		} else {
			var iDevices = [
				'iPad Simulator',
				'iPhone Simulator',
				'iPod Simulator',
				'iPad',
				'iPhone',
				'iPod'
			];
			if (Browser.navigator.platform != null)
				while (iDevices.length > 0)
					if (Browser.navigator.platform == iDevices.pop())
						return _os = OS.IOS;
			_os = OS.Unknown;
		}
		return _os;
	}
	
	private static function get_isa():ISA {
		if (_isa != null) return _isa;
		var ua = Browser.navigator.userAgent.toLowerCase();
		if (ua.indexOf('x86_32') != -1 || ua.indexOf('x32') != -1) {
			_isa = X32;
		} else if (ua.indexOf('x86_64') != -1 || ua.indexOf('x64') != -1) {
			_isa = X64;
		} else {
			_isa = ISA.Unknown;
		}
		return _isa;
	}
	
	@:extern inline private static function get_isMobile():Bool {
		#if simmobile
		return true;
		#else
		return untyped Browser.window.orientation != null;
		#end
	}
	
	@:extern inline public static function remove(el:DOMElement):Void {
		agent == IE ? el.parentNode.removeChild(el) : el.remove();
	}
	
	@:extern inline public static function get_isFSE():Bool {
		return untyped 
        {
            Browser.document.fullscreenElement ||
            Browser.document.mozFullScreen ||
            Browser.document.mozFullscreenElement ||
            Browser.document.webkitFullscreenElement ||
            Browser.document.msFullscreenElement;
        };
	}
	
	public static function closeFS():Void {
		untyped {
			if (document.cancelFullScreen)
				document.cancelFullScreen();
			else if (document.mozCancelFullScreen)
				document.mozCancelFullScreen();
			else if (document.webkitCancelFullScreen)
				document.webkitCancelFullScreen();
			else if (document.msCancelFullScreen)
				document.msCancelFullScreen();
		}
	}
	
	public static function fse(e:DOMElement):Void {
		untyped {
			if (e.requestFullscreen)
				e.requestFullscreen();
			else if (e.mozRequestFullScreen)
				e.mozRequestFullScreen();
			else if (e.webkitRequestFullscreen)
				e.webkitRequestFullscreen();
			else if (e.msRequestFullscreen)
				e.msRequestFullscreen();
		}
	}
	
	public static function disableLog():Void {
		logFunction = Browser.console.log;
		untyped Browser.console.log = Tools.nullFunction0;
	}
	
	public static function enableLog():Void {
		untyped Browser.console.log = logFunction;
	}
	
}