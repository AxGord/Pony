import massive.munit.TestSuite;

import ArrKeyTest;
import db.DBTest;
import DictionaryTest;
import events.DispatcherTest;
import events.SignalTest;
import events.WaiterTest;
import ExampleTest;
import fs.SimpleFileTest;
import IntervalsTest;
import magic.ArgsArrayTest;
import magic.AsyncTest;
import magic.PolymorphTest;
import net.WebServerTest;
import net.XSocketTest;
import ObjKeyTest;
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

		add(ArrKeyTest);
		add(db.DBTest);
		add(DictionaryTest);
		add(events.DispatcherTest);
		add(events.SignalTest);
		add(events.WaiterTest);
		add(ExampleTest);
		add(fs.SimpleFileTest);
		add(IntervalsTest);
		add(magic.ArgsArrayTest);
		add(magic.AsyncTest);
		add(magic.PolymorphTest);
		add(net.WebServerTest);
		add(net.XSocketTest);
		add(ObjKeyTest);
		add(PriorityTest);
		add(SpeedLimitTest);
		add(StreamTest);
		add(tpl.TplTest);
	}
}
