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
import pony.fs.Dir;
import pony.fs.File;

class License {

	public static function run(a:String, args:Array<String>):Void {
        var file:File = 'LICENSE.txt';

        switch a {
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