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
package pony.text.tpl;

/**
 * TplData
 * @author AxGord
 */
typedef TplData = Array<TplContent>;

enum TplContent {
	Text(t:String);
	Tag(t:TplTag);
	ShortTag(t:TplShortTag);
}

typedef TplTag = {
	name: TplTagName,
	args: Map<String, TplData>,
	arg: TplData,
	content: TplData
};

typedef TplShortTag = {
	name: TplTagName,
	arg: TplData
};

typedef TplTagName = {
	up:Int,
	name:Array<String>
};

typedef TplStyle = {
	begin:String,
	end:String,
	endClose:String,
	closeBegin:String,
	closeEnd:String,
	shortBegin:String,
	shortEnd:String,
	args:TplStyleArgs,
	group:String,
	up:String,
	space:Bool
};

typedef TplStyleArgs = {
	begin: String,
	end: String,
	delemiter: String,
	set: String,
	valueq: String,
	qalltime: Bool,
	nonamearg: Bool
};