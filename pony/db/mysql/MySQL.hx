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
package pony.db.mysql;
import haxe.PosInfos;
import pony.events.Signal;
import pony.events.Signal0;

/**
 * MySQL
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':cps'))
class MySQL extends pony.db.mysql.nodejs.MySQL implements IMySQL implements Dynamic<Table> {
	
	private var tables:Map<String, Table> = new Map();
	
	@:cps
	override public function action(q:String, ?actName:String, ?p:PosInfos):Bool {
		var err, _, _ = query(q, p).async();
		if (err != null) {
			_error(actName == null ? Std.string(err) : "Can't "+actName+': ' + err.stack, p);
			return false;
		} else
			return true;
	}
	
	public function resolve(table:String):Table {
		var t:Table = tables[table];
		if (t == null) {
			t = new Table(this, escapeId(table));
			tables[table] = t;
		}
		return t;
	}
	
	/**
	 * Close connection and destroy object
	 */
	override public function destroy():Void {
		tables = null;
		onConnect.destroy();
		onConnect = null;
		super.destroy();
	}
}