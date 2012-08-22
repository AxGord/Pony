package fs;
#if neko
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import pony.fs.Dir;
import pony.fs.SimpleDir;
import pony.fs.SimpleFile;
import pony.fs.SimplePath;
import pony.magic.Inform;
#end
/**
 * @author AxGord
 */

class SimpleFileTest
{
	#if neko
	@Test
	public function dirRead()
	{
		/*
		var f:String = SimplePath.dir(Inform.file()) + '/test.txt';
		trace(f);
		trace(SimplePath.exists(f));
		trace(SimpleFile.getContent(f));
		*/
		//trace(SimpleDir.read(SimplePath.dir(Inform.file())).array());
		Assert.areEqual('SimpleFileTest.hx', SimpleDir.read(SimplePath.dir(Inform.file())).array()[0]);
	}
	
	@Test
	public function dir() {
		//var d:Dir = new Dir(SimplePath.dir(Inform.file()));
		//d.add(d.up().array);
		//d.dir('folder').file('test2.txt').content = 'hi guys';
		//trace(d.file('test.txt').content);
		
		//trace(d.files('txt'));
	}
	#end
}