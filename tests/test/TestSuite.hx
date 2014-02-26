import massive.munit.TestSuite;

import ColorTest;
import events.ListenerTest;
import events.SignalTest;
import fs.UnitTest;
import FunctionTest;
import LoaderTest;
import magic.DeclaratorTest;
import magic.StaticInitTest;
import math.BalanceTest;
import math.LikerTest;
import physics.TempTest;
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

		add(ColorTest);
		add(events.ListenerTest);
		add(events.SignalTest);
		add(fs.UnitTest);
		add(FunctionTest);
		add(LoaderTest);
		add(magic.DeclaratorTest);
		add(magic.StaticInitTest);
		add(math.BalanceTest);
		add(math.LikerTest);
		add(physics.TempTest);
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
