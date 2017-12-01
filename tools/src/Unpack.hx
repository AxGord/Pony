/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import haxe.xml.Fast;

/**
 * Unpack
 * @author AxGord <axgord@gmail.com>
 */
class Unpack {

	public function new(xml:Fast) {
		for (z in xml.nodes.zip) {
			var path = '';
			try path = StringTools.trim(z.innerData) catch (_:Dynamic) {}
			var file = z.att.file;
			Sys.println('Unzip: ' + file);
			for (e in haxe.zip.Reader.readZip(sys.io.File.read(file))) {
				Sys.println(e.fileName);
				Utils.createPath(path + e.fileName);
				sys.io.File.saveBytes(path + e.fileName, haxe.zip.Reader.unzip(e));
			}
			if (z.has.rm && z.att.rm.toLowerCase() == 'true') {
				Sys.println('Delete: ' + file);
				sys.FileSystem.deleteFile(file);
			}
		}
	}

}