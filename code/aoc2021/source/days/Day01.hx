package days;

import openfl.Assets;

class Day01 extends Day
{
	override public function start():Void
	{
		var answerA:Int = getAnswerA();
		var answerB:Int = getAnswerB();

		PlayState.addOutput("Day 01 - Part A: " + Std.string(answerA));
		PlayState.addOutput("Day 01 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Int
	{
		var lines:String = Assets.getText("assets/data/day01a.txt");
		var inputs:Array<Null<Int>> = lines.split("\r\n").map(Std.parseInt);

		var larger:Int = 0;

		for (i in 1...inputs.length)
		{
			if (inputs[i] > inputs[i - 1])
			{
				larger++;
			}
		}
		return larger;
	}

	private function getAnswerB():Int
	{
		var lines:String = Assets.getText("assets/data/day01a.txt");
		var inputs:Array<Null<Int>> = lines.split("\r\n").map(Std.parseInt);

		var larger:Int = 0;

		for (i in 3...inputs.length)
		{
			var a:Int = inputs[i - 1] + inputs[i - 2] + inputs[i - 3];
			var b:Int = inputs[i] + inputs[i - 1] + inputs[i - 2];

			if (b > a)
			{
				larger++;
			}
		}
		return larger;
	}
}
