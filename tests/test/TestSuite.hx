import massive.munit.TestSuite;

import db.DBTest;
import events.DispatcherTest;
import events.SignalTest;
import events.WaiterTest;
import ExampleTest;
import fs.SimpleFileTest;
import magic.ArgsArrayTest;
import magic.AsyncTest;
import magic.PolymorphTest;
import net.WebServerTest;
import PriorityTest;
import SpeedLimitTest;
import StreamTest;
import tpl.TplTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(db.DBTest);
		add(events.DispatcherTest);
		add(events.SignalTest);
		add(events.WaiterTest);
		add(ExampleTest);
		add(fs.SimpleFileTest);
		add(magic.ArgsArrayTest);
		add(magic.AsyncTest);
		add(magic.PolymorphTest);
		add(net.WebServerTest);
		add(PriorityTest);
		add(SpeedLimitTest);
		add(StreamTest);
		add(tpl.TplTest);
	}
}
