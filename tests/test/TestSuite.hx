/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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
import magic.HasLinkTest;
import magic.InTest;
import magic.NinjaTest;
import magic.StaticInitTest;
import magic.SuperPuperTest;
import math.BalanceTest;
import math.LikerTest;
import math.MathToolsTest;
import OrTest;
import physics.TempTest;
import PoolTest;
import PriorityTest;
import StreamTest;
import text.TextToolsTest;
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
		add(magic.HasLinkTest);
		add(magic.InTest);
		add(magic.NinjaTest);
		add(magic.StaticInitTest);
		add(magic.SuperPuperTest);
		add(math.BalanceTest);
		add(math.LikerTest);
		add(math.MathToolsTest);
		add(OrTest);
		add(physics.TempTest);
		add(PoolTest);
		add(PriorityTest);
		add(StreamTest);
		add(text.TextToolsTest);
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
