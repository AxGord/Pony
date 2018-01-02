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
package pony.text;
using pony.Tools;
/**
 * Word wrap
 * @author AxGord
 */
class WordWrap {

	public static var newLine:Int = '\n'.charCodeAt(0);
	public static var def:Int = '-'.charCodeAt(0);
	public static var space:Int = ' '.charCodeAt(0);
	
	public static var splitChars:Array<String> = [' ', '-', '\t'];

	public static function wordWrap(str:String, width:Int):String {
		var words:Array<String> = TextTools.explode(str, splitChars);

		var curLineLength:Int = 0;
		var strBuilder:StringBuf = new StringBuf();
		for (word in words)
		{
			// If adding the new word to the current line would be too long,
			// then put it on a new line (and split it up if it's too long).
			if (curLineLength + word.length > width)
			{
				// Only move down to a new line if we have text on the current line.
				// Avoids situation where wrapped whitespace causes emptylines in text.
				if (curLineLength > 0)
				{
					strBuilder.addChar(newLine);
					curLineLength = 0;
				}

				// If the current word is too long to fit on a line even on it's own then
				// split the word up.
				while (word.length > width)
				{
					strBuilder.addSub(word, 0, width - 1);
					strBuilder.addChar(def);
					word = word.substr(width - 1);
					strBuilder.addChar(newLine);
				}

				// Remove leading whitespace from the word so the new line starts flush to the left.
				word = StringTools.ltrim(word);
			}
			strBuilder.add(word);
			strBuilder.addChar(space);
			curLineLength += word.length;
		}

		return strBuilder.toString();
	}

		
}