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
package pony.net.http.modules.mfb;
import pony.net.http.sn.FBData;
import pony.text.tpl.ITplPut;

/**
 * MFBConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MFBConnect extends ModuleConnect<MFB>
{

	public var token(get, set):String;
	
	private var data:FBData;
	
	override public function tpl(parent:ITplPut):ITplPut
		return new MFBPut(this, null, parent);
	
	inline private function get_token():String
		return cpq.connection.sessionStorage['fb_token'];
	
	inline private function set_token(t:String):String
		return cpq.connection.sessionStorage['fb_token'] = t;
	
	public function getBaseData(cb:FBData->Void):Void {
		if (data != null) {
			cb(data);
		} else {
			if (token == null) {
				cb(null);
			} else
				base.fb.me(token, function(d:FBData) {
					if (d == null) {
						token = null;
						cpq.connection.endAction();
						return;
					} else
						cb(data = d);
				});
		}
	}
	
	public function getId(cb:String->Void):Void
		getBaseData(function(d) cb(d == null?'0':d.id));
	
}