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

import js.Browser;
import js.html.DOMElement;

/**
 * JsTools
 * @author AxGord <axgord@gmail.com>
 */
class JsTools {

	public static var isIE(get, never):Bool;
	public static var isEdge(get, never):Bool;
	public static var isMobile(get, never):Bool;
	public static var isAndroid(get, never):Bool;
	
	private static var _isIE:Null<Bool>;
	private static var _isEdge:Null<Bool>;
	private static var _isAndroid:Null<Bool>;
	
	private static function get_isIE():Bool {
		if (_isIE == null) {
			_isIE = Browser.navigator.userAgent.indexOf('MSIE') != -1
				|| Browser.navigator.appVersion.indexOf('Trident/') > 0;
		}
		return _isIE;
	}
	
	private static function get_isEdge():Bool {
		if (_isEdge == null) {
			_isEdge = Browser.navigator.userAgent.indexOf('Edge') != -1;
		}
		return _isEdge;
	}
	
	private static function get_isAndroid():Bool {
		if (_isAndroid == null) {
			_isAndroid = Browser.navigator.userAgent.toLowerCase().indexOf('android') != -1;
		}
		return _isAndroid;
	}
	
	@:extern inline private static function get_isMobile():Bool return untyped Browser.window.orientation != null;
	
	@:extern inline public static function remove(el:DOMElement):Void {
		isIE ? el.parentNode.removeChild(el) : el.remove();
	}
	
}