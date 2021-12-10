package days;

import openfl.Assets;

using StringTools;

class Day10 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 10 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 10 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day10a.txt").split("\r\n");

		var series:Array<String> = [];

		var P:Int = 0;
		var B:Int = 0;
		var C:Int = 0;
		var A:Int = 0;

		for (l in lines)
		{
			trace(l);
			var line:Array<String> = l.split("");
			series = [];
			for (i in line)
			{
				switch (i)
				{
					case "(", "[", "{", "<":
						series.push(i);
					case ")":
						if (series.pop() != "(")
						{
							P++;
							break;
						}
					case "]":
						if (series.pop() != "[")
						{
							B++;
							break;
						}
					case "}":
						if (series.pop() != "{")
						{
							C++;
							break;
						}
					case ">":
						if (series.pop() != "<")
						{
							A++;
							break;
						}
					default:
						break;
				}
			}
		}

		return P * 3 + B * 57 + C * 1197 + A * 25137;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day10a.txt").split("\r\n");

		var series:Array<String> = [];

		var additions:Array<Array<String>> = [];

		var P:Int = 0;
		var B:Int = 0;
		var C:Int = 0;
		var A:Int = 0;

		for (l in lines)
		{
			// trace(l);
			var line:Array<String> = l.split("");
			series = [];
			for (i in line)
			{
				switch (i)
				{
					case "(", "[", "{", "<":
						series.push(i);
					case ")":
						if (series.pop() != "(")
						{
							P++;
							series = [];
							break;
						}
					case "]":
						if (series.pop() != "[")
						{
							B++;
							series = [];
							break;
						}
					case "}":
						if (series.pop() != "{")
						{
							C++;
							series = [];
							break;
						}
					case ">":
						if (series.pop() != "<")
						{
							A++;
							series = [];
							break;
						}
					default:
						break;
				}
			}

			if (series.length > 0)
			{
				var newAdd:Array<String> = [];
				while (series.length > 0)
				{
					switch (series.pop())
					{
						case "(":
							newAdd.push(")");
						case "[":
							newAdd.push("]");
						case "{":
							newAdd.push("}");
						case "<":
							newAdd.push(">");
						default:
					}
				}
				additions.push(newAdd);
			}
		}

		var scores:Array<Float> = [];
		for (a in additions)
		{
			var score:Float = 0;
			for (s in a)
			{
				score *= 5;
				switch (s)
				{
					case ")":
						score += 1;
					case "]":
						score += 2;
					case "}":
						score += 3;
					case ">":
						score += 4;
				}
			}
			// trace(a, score);
			scores.push(score);
		}

		scores.sort(function(a, b)
		{
			return a == b ? 0 : (b > a ? -1 : 1);
		});

		for (s in scores)
		{
			trace(s);
		}

		return scores[Std.int(scores.length / 2) ];
	}
}
