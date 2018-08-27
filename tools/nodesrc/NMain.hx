/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/

import haxe.io.Output;
import haxe.io.Bytes;
import hxbit.Serializer;
import haxe.Log;
import pony.Logable;
import pony.Tools;
import module.NModule;

class NMain extends Logable {

	// private var stderr:Output;

	private function new():Void {
		super();
		onLog << Sys.println;
		// stderr = Sys.stderr();
		// onError << errorHandler;
		onError << Sys.println;
		var args = Sys.args();
		var b:Bytes = Tools.hexToBytes(args.pop());
		var serializer:Serializer = new Serializer();
		var np:NProtocol = serializer.unserialize(b, NProtocol);
		listen(cast new module.Bmfont(np.bmfont));
		listen(cast new module.Imagemin(np.imagemin));
	}

	private function listen(m:NModule<Any>):Void {
		m.onLog << log;
		m.onError << error;
		m.start();
	}

	// private function errorHandler(r:String):Void {
	// 	stderr.writeString(r + '\n');
	// }

	private static function main():Void new NMain();

}