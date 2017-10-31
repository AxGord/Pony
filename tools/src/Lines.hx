import pony.fs.Dir;

class Lines {

	public static function run(args:Array<String>):Void {
        tryShow('Haxe', '.hx');
        tryShow('Xml', '.xml');
        tryShow('Json', '.json');
        tryShow('JavaScript', '.js');
    }

    private static function tryShow(lang:String, ext:String):Void {
        var count = getCount(ext);
        if (count > 0)
            Sys.println('$lang files total lines count: $count');
    }

    private static function getCount(ext:String):Int {
        var count:Int = 0;
        for (file in ('.':Dir).contentRecursiveFiles(ext))
            count += file.content.split('\n').length;
        return count;
    }

}