package days;

import days.Day09.MyPoint;
import openfl.Assets;


using StringTools;

class Day11 extends Day
{
	// private var original:Array<Array<Int>>;
	private var octos:Array<Array<Null<Int>>>;

	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 11 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 11 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day11a.txt").split("\r\n");

		octos = [];
		for (l in lines)
			octos.push(l.split("").map(Std.parseInt));

		var numSteps:Int = 100;
		var flashed:Int = 0;

		var queue:Array<MyPoint> = [];

		for (s in 0...numSteps)
		{
			// original = [for (i in 0...octos.length) [for (j in 0...octos[i].length) octos[i][j]]];

			for (y in 0...octos.length)
			{
				for (x in 0...octos[y].length)
				{
					queue.push(new MyPoint(x, y));
				}
			}

			do
			{
				var q:MyPoint = queue.shift();

				octos[q.y][q.x]++;

				// traceOctos();

				if (octos[q.y][q.x] == 10)
				{
					for (y in q.y - 1...q.y + 2)
					{
						for (x in q.x - 1...q.x + 2)
						{
							if (!(x == q.x && y == q.y) && x >= 0 && x < octos[q.y].length && y >= 0 && y < octos.length)
							{
								queue.push(new MyPoint(x, y));
							}
						}
					}
				}
				// trace(queue.length);
			}
			while (queue.length > 0);

			for (y in 0...octos.length)
			{
				for (x in 0...octos[y].length)
				{
					if (octos[y][x] > 9)
					{
						flashed++;
						octos[y][x] = 0;
					}
				}
			}

			trace('Step ${s + 1}:');
			traceOctos();
		}

		return flashed;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day11a.txt").split("\r\n");
		octos = [];
		for (l in lines)
			octos.push(l.split("").map(Std.parseInt));
		var numSteps:Int = 0;
		var flashed:Int = 0;
		var queue:Array<MyPoint> = [];
		do
		{
			flashed = 0;
			// original = [for (i in 0...octos.length) [for (j in 0...octos[i].length) octos[i][j]]];
			for (y in 0...octos.length)
			{
				for (x in 0...octos[y].length)
				{
					queue.push(new MyPoint(x, y));
				}
			}
			do
			{
				var q:MyPoint = queue.shift();

				octos[q.y][q.x]++;
				// traceOctos();
				if (octos[q.y][q.x] == 10)
				{
					for (y in q.y - 1...q.y + 2)
					{
						for (x in q.x - 1...q.x + 2)
						{
							if (!(x == q.x && y == q.y) && x >= 0 && x < octos[q.y].length && y >= 0 && y < octos.length)
							{
								queue.push(new MyPoint(x, y));
							}
						}
					}
				}
				// trace(queue.length);
			}
			while (queue.length > 0);
			for (y in 0...octos.length)
			{
				for (x in 0...octos[y].length)
				{
					if (octos[y][x] > 9)
					{
						flashed++;
						octos[y][x] = 0;
					}
				}
			}
			// trace('Step ${s + 1}:');
			// traceOctos();
			numSteps++;
		}
		while (flashed < 100);

		return numSteps;
	}

	private function traceOctos():Void
	{
		var joining:Array<String> = [];
		for (o in octos)
		{
			joining.push(o.join(""));
		}
		trace("\r\n" + joining.join("\r\n"));
		trace("");
	}
}
