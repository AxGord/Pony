package ui;

import haxe.Exception;
import massive.munit.Assert;
import pony.ui.gui.slices.SliceData;
import pony.ui.gui.slices.SliceTools;

class SliceToolsTest {

	@Test
	public function animWithoutDelay(): Void {
		switch SliceTools.getType('coin/gold{anim8}') {
			case SliceData.Anim(speed, delay, rest, maxSpeed):
				Assert.areEqual(8.0, speed);
				Assert.isNull(delay);
				Assert.isNull(rest);
				Assert.isNull(maxSpeed);
			case _:
				Assert.fail('Not an anim');
		}
	}

	@Test
	public function animWithDelay(): Void {
		switch SliceTools.getType('coin/gold{anim8,700ms}') {
			case SliceData.Anim(speed, delay, rest, maxSpeed):
				Assert.areEqual(8.0, speed);
				Assert.areEqual(700, delay);
				Assert.isNull(rest);
				Assert.isNull(maxSpeed);
			case _:
				Assert.fail('Not an anim');
		}
	}

	@Test
	public function animParkedBoostedAndCapped(): Void {
		switch SliceTools.getType('coin/gold{anim24,rest3,boost1,max72}') {
			case SliceData.Anim(speed, delay, rest, boost, maxSpeed):
				Assert.areEqual(24.0, speed);
				Assert.isNull(delay);
				Assert.areEqual(3, rest);
				Assert.areEqual(1.0, boost);
				Assert.areEqual(72.0, maxSpeed);
			case _:
				Assert.fail('Not an anim');
		}
	}

	/** Fields are told apart by prefix, so their order in the spec carries no meaning. */
	@Test
	public function animFieldsAreOrderFree(): Void {
		switch SliceTools.getType('coin/gold{anim24,max72,boost2,rest5}') {
			case SliceData.Anim(_, _, rest, boost, maxSpeed):
				Assert.areEqual(5, rest);
				Assert.areEqual(2.0, boost);
				Assert.areEqual(72.0, maxSpeed);
			case _:
				Assert.fail('Not an anim');
		}
	}

	/** Boost is opt-in: nothing accumulates a speed-up unless the spec asks for it. */
	@Test
	public function animBoostDefaultsToNothing(): Void {
		switch SliceTools.getType('coin/gold{anim24,rest3}') {
			case SliceData.Anim(_, _, rest, boost, maxSpeed):
				Assert.areEqual(3, rest);
				Assert.isNull(boost);
				Assert.isNull(maxSpeed);
			case _:
				Assert.fail('Not an anim');
		}
	}

	@Test
	public function badAnimFieldThrows(): Void {
		var thrown: Bool = false;
		try
			SliceTools.getType('coin/gold{anim24,restX}')
		catch (exception: Exception)
			thrown = true;
		Assert.isTrue(thrown);
	}

	/** A misspelled field name used to slip through as a delay and blow up inside Time. */
	@Test
	public function unknownAnimFieldThrows(): Void {
		var thrown: Bool = false;
		try
			SliceTools.getType('coin/gold{anim24,bost1}')
		catch (exception: Exception)
			thrown = true;
		Assert.isTrue(thrown);
	}

	@Test
	public function animNameIsCleaned(): Void {
		Assert.areEqual('coin/gold', SliceTools.clean('coin/gold{anim24,rest3,max72}'));
	}

}
