import massive.munit.TestSuite;

import events.ListenerTest;
import events.SignalTest;
import FunctionTest;
import PriorityTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(events.ListenerTest);
		add(events.SignalTest);
		add(FunctionTest);
		add(PriorityTest);
	}
}
