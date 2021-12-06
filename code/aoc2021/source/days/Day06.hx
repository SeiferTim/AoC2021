package days;

import openfl.Assets;

using StringTools;

class Day06 extends Day
{
	override public function start():Void
	{
		// var answerA:Int = getAnswerA();

		// PlayState.addOutput("Day 06 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 06 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Int
	{
		var lines:String = Assets.getText("assets/data/day06a.txt").trim();

		var fish:Array<Null<Int>> = lines.split(",").map(Std.parseInt);

		var newFish:Int = 0;
		for (d in 0...80)
		{
			newFish = 0;
			for (f in 0...fish.length)
			{
				if (fish[f] == 0)
				{
					fish[f] = 6;
					newFish++;
				}
				else
				{
					fish[f]--;
				}
			}
			for (f in 0...newFish)
			{
				fish.push(8);
			}
		}

		return fish.length;
	}

	private function getAnswerB():Float
	{
		var lines:String = Assets.getText("assets/data/day06a.txt").trim();

		var fish:Array<Null<Int>> = lines.split(",").map(Std.parseInt);

		var counts:Array<Float> = [for (i in 0...9) 0];
		for (f in fish)
		{
			counts[f]++;
		}

		trace('init: $counts', sum(counts));

		for (d in 0...256)
		{
			var p:Float = counts.shift();

			counts[6] += p;
			counts.push(p);

			trace('$d: $counts', sum(counts));
		}

		return sum(counts);
	}

	private function sum(Arr:Array<Float>):Float
	{
		var sum:Float = 0;
		for (a in Arr)
			sum += a;
		return sum;
	}
}
