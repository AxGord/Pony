import pony.fs.Dir;
import pony.fs.File;

using StringTools;
using pony.Tools;

/**
 * License
 * @author AxGord <axgord@gmail.com>
 */
class License {

	private static final LICENSE_TEMPLATE_PATH: String = 'license/';
	private static final LICENSE_OUTPUT_FILE: String = 'LICENSE';

	public static function run(a: String, args: Array<String>): Void {
		var file: File = LICENSE_OUTPUT_FILE;
		switch a {
			case 'create':
				create(args);
			case 'remove':
				for (file in ('.': Dir).contentRecursiveFiles('.hx')) {
					final lines: Array<String> = file.content.split('\n');
					var allowRemove: Bool = false;
					var n: Int = 0;
					while (n < lines.length) {
						final c: String = StringTools.trim(lines[n]);
						if (c == '/**') {
							allowRemove = true;
							break;
						}
						if (c.length > 0) {
							break;
						}
						n++;
					}
					if (!allowRemove) continue;
					var error: Bool = true;
					for (line in lines) {
						n++;
						if (line.trim() != '**/') continue;
						error = false;
						break;
					}
					if (error) {
						Sys.println('Unclosed comment in $file!');
						continue;
					}
					Sys.println('Remove license from file $file');
					file.content = lines.slice(n).join('\n');
				}

			case 'update':
				if (!file.exists) {
					file = 'LICENSE.txt';
					if (!file.exists) {
						Utils.error('$file not found');
						return;
					}
				}
				final data: Array<String> = file.content.split('\n');
				for (line in 0...data.length) data[line] = '* ${data[line]}';
				data.unshift('/**');
				data.push('**/');
				for (file in ('.': Dir).contentRecursiveFiles('.hx')) {
					final fcontent: String = file.content;
					final lines: Array<String> = fcontent.split('\n');
					if (StringTools.trim(lines[0]) == '/**') {
						var n: Int = 0;
						var error: Bool = true;
						for (line in lines) {
							n++;
							if (line.trim() != '**/') continue;
							error = false;
							break;
						}
						if (error) {
							Utils.error('Unclosed comment in $file!');
							return;
						}
						var flag: Bool = true;
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
							var ok: Bool = false;
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
								file.content = data.join('\n') + '\n$fcontent';
							}
						}
					} else {
						Sys.println('Add license in file $file');
						file.content = data.join('\n') + '\n$fcontent';
					}
				}
			case _:
				Utils.error('Unknown command');
		}
	}

	private static function create(args: Array<String>): Void {
		switch args.shift().toLowerCase() {
			case 'bsd':
				parseArgsAndGenLicense('bsd.txt', args);
			case 'mit':
				parseArgsAndGenLicense('mit.txt', args);
			case 'closed':
				final all: Array<String> = args.join(' ').split('@');
				if (all.length < 2) Utils.error('Email not set');
				final a: Array<String> = all[0].split(' ');
				final b: Array<String> = all[1].split(' ');
				final email: String = '${a.pop()}@${b.shift()}';
				final author: String = a.join(' ');
				final company: String = b.join(' ');
				genLicense('closed.txt', author, email, company);
			case _:
				Utils.error('Unknown license');
		}
	}

	private static function parseArgsAndGenLicense(tpl: String, args: Array<String>): Void {
		final na: Array<String> = [];
		var email: String = null;
		for (a in args) {
			if (a.indexOf('@') != -1)
				email = a;
			else
				na.push(a);
		}
		final author: String = na.join(' ');
		genLicense(tpl, author, email);
	}

	private static function genLicense(tpl: String, author: String, email: String, ?company: String): Void {
		final date: Int = Date.now().getFullYear();
		if (author.nore()) Utils.error('Author not set');
		if (company.nore()) company = author;
		if (email == null) email = '';
		if (email != '') email = ' <$email>';
		Template.gen(LICENSE_TEMPLATE_PATH, [tpl => LICENSE_OUTPUT_FILE], [
			'COMPANY' => company,
			'DATE' => '$date',
			'author' => author,
			'AUTHOR' => author.toUpperCase(),
			'email' => email
		]);
	}

}
