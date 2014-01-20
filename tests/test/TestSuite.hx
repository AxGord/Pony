import massive.munit.TestSuite;

import events.ListenerTest;
import events.SignalTest;
import FunctionTest;
import LoaderTest;
import magic.DeclaratorTest;
import magic.StaticInitTest;
import math.BalanceTest;
import PriorityTest;
import TextCoderTest;
import time.DTimerTest;
import time.TimerTest;
import time.TimeTest;
import ToolsTest;
import TumblerTest;
import ui.ButtonCoreTest;
import ui.FocusManagerTest;
import ui.KeyboardTest;
import ui.PresserTest;

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
		add(PriorityTest);
		add(TextCoderTest);
		add(time.DTimerTest);
		add(time.TimerTest);
		add(time.TimeTest);
		add(ToolsTest);
		add(TumblerTest);
		add(ui.ButtonCoreTest);
		add(ui.FocusManagerTest);
		add(ui.KeyboardTest);
		add(ui.PresserTest);
	}
}
