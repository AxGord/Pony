import pony.fs.Dir;
import pony.fs.File;

class License {

	public static function run(args:Array<String>):Void {
        var file:File = 'LICENSE.txt';

        switch args.shift() {
            case 'create':
                switch args.shift().toLowerCase() {
                    case 'bsd':
                        var na = [];
                        var email:String = null;
                        for (a in args) {
                            if (a.indexOf('@') != -1)
                                email = a;
                            else
                                na.push(a);
                        }
                        var author = na.join(' ');
                        if (author == null) Utils.error('Author not set');
                        var data = haxe.Resource.getString('bsd');
                        var date = Date.now().getFullYear() + ' $author';
                        if (email != null) date += ' <$email>';
                        data = StringTools.replace(data, '::DATE::', date);
                        data = StringTools.replace(data, '::AUTHOR::', author.toUpperCase());
                        file.content = data;
                        Sys.println('Create $file');

                    case 'closed':
                        var na = [];
                        var a = null;
                        var company:String = [while ((a = args.shift()) != '-') a].join(' ');
                       
                        var email:String = null;
                        for (a in args) {
                            if (a.indexOf('@') != -1)
                                email = a;
                            else
                                na.push(a);
                        }
                        var author = na.join(' ');
                        if (author == null) Utils.error('Author not set');
                        var data = haxe.Resource.getString('closed');
                        var date = Date.now().getFullYear();
                        if (email != null) author += ' <$email>';
                        data = StringTools.replace(data, '::COMPANY::', company);
                        data = StringTools.replace(data, '::DATE::', Std.string(date));
                        data = StringTools.replace(data, '::AUTHOR::', author);
                        
                        file.content = data;
                        Sys.println('Create $file');

                    case _:
                        Utils.error('Unknown license');
                }
            case 'update':
                if (!file.exists) {
                    Utils.error('$file not found');
                    return;
                }
                var data = file.content.split('\n');
                for (line in 0...data.length) data[line] = '* ' + data[line];
                data.unshift('/**');
                data.push('**/');
                for (file in ('.':Dir).contentRecursiveFiles('.hx')) {
                    var fcontent = file.content;
                    var lines:Array<String> = fcontent.split('\n');
                    if (lines[0] == '/**') {
                        var n:Int = 0;
                        var error = true;
                        for (line in lines) {
                            n++;
                            if (line == '**/') {
                                error = false;
                                break;
                            }
                        }
                        if (error) {
                            Utils.error('Unclosed comment in $file!');
                            return;
                        }
                        var flag = true;
                        if (data.length == n) {
                            for (i in 0...n) {
                                if (data[i] != lines[i]) {
                                    flag = false;
                                    break;
                                }
                            }
                        } else {
                            flag = false;
                        }
                        if (!flag) {
                            var ok = false;
                            for (line in lines) {
                                if (line.toLowerCase().indexOf('copyright') != -1) {
                                    ok = true;
                                    break;
                                }
                            }
                            if (ok) {
                                Sys.println('Update license in file $file');
                                file.content = data.concat(lines.slice(n)).join('\n');
                            } else {
                                Sys.println('Add license in file $file');
                                file.content = data.join('\n') + '\n' + fcontent;
                            }
                        }
                    } else {
                        Sys.println('Add license in file $file');
                        file.content = data.join('\n') + '\n' + fcontent;
                    }
                }
            case _:
                Utils.error('Unknown command');
        }
    }

}