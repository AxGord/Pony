/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.text;

/**
 * Encode/decode string
 * @author AxGord
 */
class TextCoder {
	
	static private var chars:String = '0123456789QWERTYUIOPASDFGHJKLZXCVBNM';
	
	private var key:String;
	
	public function new(key:String) {
		this.key = key.toUpperCase();
	}
	
	public function encode(text:String):String {
		var s:String = core(text);
		if (text.toUpperCase() == core(s, -1))
			return s;
		else
			return null;
	}
	
	public function decode(text:String, k=null):String {
		var s:String = core(text, -1);
		if (text.toUpperCase() == core(s))
			return s;
		else
			return null;
	}
	
	private function core(text:String, mode:Int = 1):String {
		if (text == '') return null;
		var n:Int = 0;
		text = text.toUpperCase();
		var s:String = '';
		for (i in 0...text.length) {
			if (n >= key.length)
				n = 0;
			var tp:Int = chars.indexOf(text.charAt(i));
			var kp:Int = chars.indexOf(key.charAt(n));
			var np:Int = tp + kp * mode;
			if (np >= chars.length)
				np -= chars.length;
			if (np < 0)
				np += chars.length;
			s += chars.charAt(np);
			n++;
		}
		return s;
	}
	
}