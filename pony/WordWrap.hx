package pony;
using pony.Tools;
/**
 * ...
 * @author AxGord
 */
class WordWrap {

	public static var newLine:Int = '\n'.charCodeAt(0);
	public static var def:Int = '-'.charCodeAt(0);
	public static var space:Int = ' '.charCodeAt(0);
	
	public static var splitChars:Array<String> = [' ', '-', '\t'];

	public static function wordWrap(str:String, width:Int):String {
		var words:Array<String> = StringTls.explode(str, splitChars);

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