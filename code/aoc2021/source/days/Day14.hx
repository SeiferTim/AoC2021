package days;

import haxe.Int64;
import openfl.Assets;

using StringTools;

class Day14 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 14 - Part A: " + Std.string(answerA));

		var answerB:Int64 = getAnswerB();

		PlayState.addOutput("Day 14 - Part B: " + Int64.toStr(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day14atmp.txt").split("\r\n");

		var template:Array<String> = lines[0].split("");

		var recipies:Map<String, String> = [];

		for (l in 2...lines.length)
		{
			var line:String = lines[l];

			var parts:Array<String> = line.split(" -> ");

			var input:String = parts[0];

			var output:String = parts[1];

			recipies.set(input, output);
		}

		for (step in 0...9)
		{
			var newTemplate:String = "";
			for (r in 1...template.length)
			{
				if (recipies.exists(template[r - 1] + template[r]))
				{
					newTemplate += template[r - 1] + recipies.get(template[r - 1] + template[r]);
				}
				else
				{
					newTemplate += template[r - 1];
				}
			}
			newTemplate += template[template.length - 1];
			template = newTemplate.split("");
		}

		var values:Map<String, Float> = arrayCountValues(template);
		var maxAmt:Float = 0;
		var minAmt:Float = Math.POSITIVE_INFINITY;
		var maxKey:String = "";
		var minKey:String = "";

		for (element => amount in values)
		{
			if (amount > maxAmt)
			{
				maxAmt = amount;
				maxKey = element;
			}
			if (amount < minAmt)
			{
				minAmt = amount;
				minKey = element;
			}
		}

		return maxAmt - minAmt;
	}

	private function getAnswerB():Int64
	{
		var lines:Array<String> = Assets.getText("assets/data/day14a.txt").split("\r\n");

		var template:Array<String> = lines[0].split("");

		var recipies:Map<String, String> = [];

		for (l in 2...lines.length)
		{
			var line:String = lines[l];

			var parts:Array<String> = line.split(" -> ");

			var input:String = parts[0];

			var output:String = parts[1];

			recipies.set(input, output);
		}

		// trace([for (i => p in recipies) '$i: $p']);

		var pairCounts:Map<String, Int64> = [];
		var pair:String = "";
		var pCount:Int64 = 0;
		for (i in 1...template.length)
		{
			pair = template[i - 1] + template[i];
			pCount = 0;

			if (pairCounts.exists(pair))
			{
				pCount = pairCounts.get(pair);
			}
			pairCounts.set(pair, pCount + 1);
		}
		// trace([for (pair => counts in pairCounts) pair + ": " + counts]);

		var newCount:Map<String, Int64> = [];
		var recipie:String = "";
		var first:String = "";
		var second:String = "";
		var amt:Int64 = 0;

		for (step in 0...40)
		{
			newCount = [];
			for (pair => counts in pairCounts)
			{
				if (recipies.exists(pair))
				{
					recipie = recipies.get(pair);

					first = pair.substr(0, 1) + recipie;

					second = recipie + pair.substr(1, 1);

					trace(first, second);

					amt = 0;
					if (newCount.exists(first))
						amt = newCount.get(first);

					newCount.set(first, amt + counts);

					amt = 0;
					if (newCount.exists(second))
						amt = newCount.get(second);

					newCount.set(second, amt + counts);
				}
			}
			pairCounts = newCount.copy();
			trace([for (pair => counts in pairCounts) pair + ": " + counts]);
		}

		// // trace([for (pair => counts in pairCounts) pair + ": " + counts]);

		var letterCounts:Map<String, Int64> = [];
		var x:String = "";
		var y:String = "";
		var val:Int64 = 0;
		for (p => v in pairCounts)
		{
			x = p.substr(0, 1);
			y = p.substr(1, 1);

			if (!letterCounts.exists(x))
				val = 0;
			else
			{
				val = letterCounts.get(x);
			}
			letterCounts.set(x, val + v);

			trace('x: $x, val: ' + Int64.toStr(val + v));

			if (!letterCounts.exists(y))
				val = 0;
			else
			{
				val = letterCounts.get(y);
			}
			letterCounts.set(y, val + v);

			trace('y: $y, val: ' + Int64.toStr(val + v));
		}

		val = letterCounts.get(template[0]) + 1;
		letterCounts.set(template[0], val);

		trace(template[0], val);

		val = letterCounts.get(template[template.length - 1]) + 1;
		letterCounts.set(template[template.length - 1], val);

		trace(template[template.length - 1], val);

		trace([for (letter => counts in letterCounts) letter + ": " + counts]);

		var values:Array<Int64> = [for (a in letterCounts) a];

		values.sort(function(a, b)
		{
			return a == b ? 0 : (b > a ? -1 : 1);
		});

		trace([for (v in values) Int64.toStr(v)]);

		return (values[values.length - 1] - values[0]) / 2;
	}

	private function arrayCountValues(A:Array<String>):Map<String, Float>
	{
		var map:Map<String, Float> = [];
		for (a in A)
		{
			if (!map.exists(a))
			{
				map.set(a, 1);
			}
			else
			{
				var v:Float = map.get(a);
				map.set(a, v + 1);
			}
		}
		return map;
	}
}
