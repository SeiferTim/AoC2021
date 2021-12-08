package days;

import openfl.Assets;

using StringTools;

class Day08 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 08 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 08 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Int
	{
		var lines:Array<String> = Assets.getText("assets/data/day08a.txt").split("\r\n");

		var data:Array<DisplayData> = [];

		for (l in lines)
		{
			var tmpSplit:Array<String> = l.split(" | ");
			data.push({inputs: tmpSplit[0].split(" ").map(StringTools.trim), outputs: tmpSplit[1].split(" ").map(StringTools.trim)});
			trace(data[data.length - 1].inputs, ' | ', data[data.length - 1].outputs);
		}

		var count:Int = 0;
		for (d in data)
		{
			for (o in d.outputs)
			{
				if (o.length == 2 || o.length == 3 || o.length == 4 || o.length == 7)
				{
					trace(o);
					count++;
				}
			}
		}

		return count;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day08a.txt").split("\r\n");

		var data:Array<Float> = [];

		for (l in lines)
			data.push(decode(l));

		return sum(data);
	}

	private function decode(Line:String):Float
	{
		var digits:Array<String> = Line.split(" | ")[0].split(" ").map(StringTools.trim);
		var outputs:Array<String> = Line.split(" | ")[1].split(" ").map(StringTools.trim);

		var code:Array<Int> = [for (i in 0...10) 0];

		for (d in digits)
		{
			switch (d.length)
			{
				case 2:
					code[1] = parse(d);
				case 3:
					code[7] = parse(d);
				case 4:
					code[4] = parse(d);
				case 7:
					code[8] = parse(d);
				default:
			}
		}

		for (d in digits.filter(d -> d.length == 6))
		{
			var s:Int = parse(d);
			if ((s | code[7]) == code[8])
				code[6] = s;
			else if (countSet(s ^ code[4]) == 4)
				code[0] = s;
			else
				code[9] = s;
		}

		for (d in digits.filter(d -> d.length == 5))
		{
			var s:Int = parse(d);
			if (d == "fbcad")
			{
				trace(d, s, code[1], countSet(s ^ code[1]));
				trace("!");
			}
			if (countSet(s ^ code[1]) == 3)
				code[3] = s;
			else if (countSet(s ^ code[9]) == 1)
				code[5] = s;
			else
				code[2] = s;
		}

		trace(code);

		var output:String = "";
		for (o in outputs)
		{
			var s:Int = parse(o);

			trace(o, s, code.indexOf(s), Std.string(code.indexOf(s)));

			output += Std.string(code.indexOf(s));
		}

		trace(output);

		return Std.parseFloat(output);
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

	private function isSet(Value:Int, Digit:Int, Length:Int):Bool
	{
		return (Value & (1 << Length - 1 - Digit)) != 0;
	}

	private function countSet(Input:Int):Int
	{
		return toBinaryString(Input, 8).split("").filter(c -> c == "1").length;
	}

	private function parse(Digits:String):Int
	{
		var result:Int = 0;
		for (d in 0...7)
		{
			if (Digits.contains(String.fromCharCode("a".code + d)))
				result += 1 << d;
		}

		return result;
	}

	private function sum(Arr:Array<Float>):Float
	{
		var sum:Float = 0;
		for (a in Arr)
			sum += a;
		return sum;
	}
}

typedef DisplayData =
{
	var inputs:Array<String>;
	var outputs:Array<String>;
}
