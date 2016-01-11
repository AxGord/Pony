import massive.munit.TestSuite;

import ColorTest;
import events.ListenerTest;
import events.SignalTest;
import fs.UnitTest;
import geom.GeomToolsTest;
import LoaderTest;
import magic.DeclaratorTest;
import magic.ExtendedPropertiesTest;
import magic.HasAbstractTest;
import magic.InTest;
import magic.NinjaTest;
import magic.StaticInitTest;
import magic.SuperPuperTest;
import math.BalanceTest;
import math.LikerTest;
import physics.TempTest;
import PoolTest;
import PriorityTest;
import StreamTest;
import text.tpl.TplTest;
import TextCoderTest;
import time.DTimerTest;
import time.TimelineTest;
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
		add(geom.GeomToolsTest);
		add(LoaderTest);
		add(magic.DeclaratorTest);
		add(magic.ExtendedPropertiesTest);
		add(magic.HasAbstractTest);
		add(magic.InTest);
		add(magic.NinjaTest);
		add(magic.StaticInitTest);
		add(magic.SuperPuperTest);
		add(math.BalanceTest);
		add(math.LikerTest);
		add(physics.TempTest);
		add(PoolTest);
		add(PriorityTest);
		add(StreamTest);
		add(text.tpl.TplTest);
		add(TextCoderTest);
		add(time.DTimerTest);
		add(time.TimelineTest);
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
