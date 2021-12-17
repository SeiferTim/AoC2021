package days;

import openfl.Assets;

using StringTools;

class Day17 extends Day
{
	private var targetXMin:Int = 282;
	private var targetXMax:Int = 314;
	private var targetYMin:Int = -80;
	private var targetYMax:Int = -45;

	// private var targetXMin:Int = 20;
	// private var targetXMax:Int = 30;
	// private var targetYMin:Int = -10;
	// private var targetYMax:Int = -5;

	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 17 - Part A: " + Std.string(answerA));

		var answerB:Int = getAnswerB();

		PlayState.addOutput("Day 17 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var highestY:Int = 0;
		var bestDirStr:String = "";

		for (x in 1...targetXMax)
		{
			for (y in targetYMin...(-targetYMin))
			{
				var dir:String = '$x,$y';
				var test:Int = fireProbe(x, y);
				if (test > highestY)
				{
					highestY = test;
					bestDirStr = dir;
				}
			}
		}

		trace(bestDirStr);

		return highestY;
	}

	private function getAnswerB():Int
	{
		var reached:Int = 0;

		trace(targetXMax, targetYMin, (-targetYMin));

		for (x in 1...targetXMax + 1)
		{
			for (y in targetYMin...(-targetYMin) + 1)
			{
				// var dir:String = '$x,$y';
				var test:Bool = checkProbe(x, y);
				if (test)
				{
					trace(x, y);
					reached++;
				}
			}
		}

		return reached;
	}

	private function fireProbe(XVel:Int, YVel:Int):Int
	{
		var highestY:Int = -1;

		var x:Int = 0;
		var y:Int = 0;

		var velX:Int = XVel;
		var velY:Int = YVel;

		var reachedTarget:Bool = false;

		while (x < targetXMax && y > targetYMin)
		{
			x += velX;
			y += velY;
			velX += velX > 0 ? -1 : velX < 0 ? 1 : 0;
			velY--;

			if (y > highestY)
			{
				highestY = y;
			}

			if (x >= targetXMin && x <= targetXMax && y >= targetYMin && y <= targetYMax)
			{
				reachedTarget = true;
				break;
			}
		}

		return reachedTarget ? highestY : -1;
	}

	private function checkProbe(XVel:Int, YVel:Int):Bool
	{
		var x:Int = 0;
		var y:Int = 0;

		var velX:Int = XVel;
		var velY:Int = YVel;

		var reachedTarget:Bool = false;

		while (x < targetXMax && y > targetYMin)
		{
			x += velX;
			y += velY;
			velX += velX > 0 ? -1 : velX < 0 ? 1 : 0;
			velY--;

			if (x >= targetXMin && x <= targetXMax && y >= targetYMin && y <= targetYMax)
			{
				reachedTarget = true;
				break;
			}
		}

		return reachedTarget;
	}
}
