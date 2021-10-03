import sys.FileSystem;
import sys.io.File;

function main() {
	for (f in FileSystem.readDirectory('api'))
		File.saveContent('api/$f', StringTools.replace(File.getContent('api/$f'), '* @author AxGord <axgord@gmail.com>', ''));
}
