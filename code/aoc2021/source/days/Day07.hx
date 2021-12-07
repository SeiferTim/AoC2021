package days;

import openfl.Assets;

using StringTools;

class Day07 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 07 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 07 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:String = Assets.getText("assets/data/day07a.txt").trim();

		var crabs:Array<Null<Int>> = lines.split(",").map(Std.parseInt);
		crabs.sort((a, b) -> a - b);

		var positions:Array<Float> = [for (i in 0...crabs[crabs.length - 1]) 0];

		for (c in crabs)
		{
			positions[c]++;
		}

		var minFuelAmt:Float = Math.POSITIVE_INFINITY;
		var fuel:Float = 0;
		for (p in 0...positions.length)
		{
			fuel = 0;
			for (c in 0...positions.length)
			{
				fuel += Math.abs(p - c) * positions[c];
			}
			minFuelAmt = Math.min(fuel, minFuelAmt);
		}

		return minFuelAmt;
	}
    
    private function getAnswerB():Float
	{
		var lines:String = Assets.getText("assets/data/day07a.txt").trim();

		var crabs:Array<Null<Int>> = lines.split(",").map(Std.parseInt);
		crabs.sort((a, b) -> a - b);

		var positions:Array<Float> = [for (i in 0...crabs[crabs.length - 1]) 0];

		for (c in crabs)
		{
			positions[c]++;
		}

		var minFuelAmt:Float = Math.POSITIVE_INFINITY;
		var fuel:Float = 0;
		for (p in 0...positions.length)
		{
			fuel = 0;
			for (c in 0...positions.length)
			{
				fuel += sumOf(Math.abs(p - c)) * positions[c];
			}
			minFuelAmt = Math.min(fuel, minFuelAmt);
		}

		return minFuelAmt;
	}

    private function sumOf(Value:Float):Float
    {
        return Value * (Value + 1) / 2;
    }
}
