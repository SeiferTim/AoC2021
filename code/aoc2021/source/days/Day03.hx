package days;

import openfl.Assets;

class Day03 extends Day
{
	private var binLength:Int = 0;

	override public function start():Void
	{
		var answerA:Float = getAnswerA();

		PlayState.addOutput("Day 03 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 03 - Part B: " + Std.string(answerB));
	}

	private function binToInt(S:String):Int
	{
		var value:Int = 0;
		for (l in 0...S.length)
		{
			value += Std.parseInt(S.charAt(l)) << (S.length - l - 1);
		}
		return value;
	}

	private function getAnswerA():Float
	{
		var lines:String = Assets.getText("assets/data/day03a.txt");

		var inputs:Array<Int> = lines.split("\r\n").map(binToInt);

		var epsilon:Int = 0;
		var gamma:Int = 0;

		binLength = lines.split("\r\n")[0].length;
		var counts:Array<Int> = [for (d in 0...binLength) 0];

		for (i in inputs)
		{
			for (d in 0...binLength)
			{
				if (i & (1 << binLength - 1 - d) == 1)
					counts[d]++;
			}
		}

		for (d in 0...binLength)
		{
			if (counts[d] > inputs.length / 2)
			{
				gamma += 1 << binLength - 1 - d;
			}
			else
			{
				epsilon += 1 << binLength - 1 - d;
			}
		}

		PlayState.addOutput(gamma + " " + epsilon);

		return gamma * epsilon;
	}

	private function getAnswerB():Float
	{
		var lines:String = Assets.getText("assets/data/day03a.txt");
		var inputs:Array<Int> = lines.split("\r\n").map(binToInt);

		var ogr:Array<Int> = inputs.copy();
		var csr:Array<Int> = inputs.copy();

		binLength = lines.split("\r\n")[0].length;

		for (d in 0...binLength)
		{
			ogr = getFilter(ogr, d, true);

			if (ogr.length == 1)
				break;
		}

		for (d in 0...binLength)
		{
			csr = getFilter(csr, d, false);
			if (csr.length == 1)
				break;
		}

		// PlayState.addOutput("ogr " + toBinaryString(ogr[0], binLength) + " - " + Std.string(ogr[0]));
		// PlayState.addOutput("csr " + toBinaryString(csr[0], binLength) + " - " + Std.string(csr[0]));

		// PlayState.addOutput("* " + Std.string(ogr[0] * csr[0]));

		return ogr[0] * csr[0];
	}

	private function getFilter(Values:Array<Int>, Digit:Int, Max:Bool = true):Array<Int>
	{
		var count:Int = 0;
		for (v in Values)
		{
			if (isSet(v, Digit, binLength))
				count++;
		}
		if ((count >= Values.length / 2 && Max) || (count < Values.length / 2 && !Max))
			return Values.filter((v:Int) -> isSet(v, Digit, binLength));
		else
			return Values.filter((v:Int) -> !isSet(v, Digit, binLength));
	}

	private function isSet(Value:Int, Digit:Int, Length:Int):Bool
	{
		return (Value & (1 << Length - 1 - Digit)) != 0;
	}

	private function toBinaryString(Value:Int, Length:Int):String
	{
		var s:String = "";
		for (d in 0...Length)
		{
			s += isSet(Value, d, Length) ? "1" : "0";
		}
		return s;
	}
}
