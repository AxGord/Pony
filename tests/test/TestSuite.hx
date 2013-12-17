import massive.munit.TestSuite;

import events.ListenerTest;
import events.SignalTest;
import FunctionTest;
import LoaderTest;
import magic.DeclaratorTest;
import magic.StaticInitTest;
import math.BalanceTest;
import physics.ThermoTest;
import PriorityTest;
import TextCoderTest;
import ToolsTest;
import TumblerTest;
import ui.FocusManagerTest;
import ui.KeyboardTest;

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
		add(LoaderTest);
		add(magic.DeclaratorTest);
		add(magic.StaticInitTest);
		add(math.BalanceTest);
		add(physics.ThermoTest);
		add(PriorityTest);
		add(TextCoderTest);
		add(ToolsTest);
		add(TumblerTest);
		add(ui.FocusManagerTest);
		add(ui.KeyboardTest);
	}
}
