import sys.FileSystem;
import sys.io.File;

using StringTools;

function main() {
	for (f in FileSystem.readDirectory('api'))
		File.saveContent('api/$f', File.getContent('api/$f').replace('* @author AxGord <axgord@gmail.com>', ''));
}
