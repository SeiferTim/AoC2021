package days;

import flixel.math.FlxPoint;
import openfl.Assets;

using StringTools;

class Day09 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 09 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 09 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Int
	{
		var lines:Array<String> = Assets.getText("assets/data/day09a.txt").split("\r\n");

		var heightmap:Array<Array<Null<Int>>> = [for (l in lines) l.split("").map(Std.parseInt)];

		var width:Int = heightmap[0].length;
		var height:Int = heightmap.length;

		var lows:Array<FlxPoint> = [];

		for (y in 0...height)
		{
			for (x in 0...width)
			{
				if (x == 0 && y == 0)
				{
					// check right and down
					if (heightmap[y][x + 1] > heightmap[y][x] && heightmap[y + 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (x == 0 && y == height - 1)
				{
					// check right and up
					if (heightmap[y][x + 1] > heightmap[y][x] && heightmap[y - 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (x == width - 1 && y == 0)
				{
					// check left and down
					if (heightmap[y][x - 1] > heightmap[y][x] && heightmap[y + 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (x == width - 1 && y == height - 1)
				{
					// check left and up
					if (heightmap[y][x - 1] > heightmap[y][x] && heightmap[y - 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (x == 0)
				{
					// check up, down, and right
					if (heightmap[y - 1][x] > heightmap[y][x]
						&& heightmap[y + 1][x] > heightmap[y][x]
						&& heightmap[y][x + 1] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (y == 0)
				{
					// check left, right, and down
					if (heightmap[y][x - 1] > heightmap[y][x]
						&& heightmap[y][x + 1] > heightmap[y][x]
						&& heightmap[y + 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (x == width - 1)
				{
					// check left, up, and down
					if (heightmap[y][x - 1] > heightmap[y][x]
						&& heightmap[y - 1][x] > heightmap[y][x]
						&& heightmap[y + 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else if (y == height - 1)
				{
					// check left, right and up
					if (heightmap[y][x - 1] > heightmap[y][x]
						&& heightmap[y][x + 1] > heightmap[y][x]
						&& heightmap[y - 1][x] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
				else
				{
					// check all 4
					if (heightmap[y - 1][x] > heightmap[y][x]
						&& heightmap[y + 1][x] > heightmap[y][x]
						&& heightmap[y][x - 1] > heightmap[y][x]
						&& heightmap[y][x + 1] > heightmap[y][x])
						lows.push(FlxPoint.get(x, y));
				}
			}
		}

		var risk:Int = 0;
		for (p in lows)
		{
			risk += heightmap[Std.int(p.y)][Std.int(p.x)] + 1;
		}

		return risk;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day09a.txt").split("\r\n");

		var heightmap:Array<Array<Null<Int>>> = [for (l in lines) l.split("").map(Std.parseInt)];

		var basins:Array<Array<MyPoint>> = [];

		// flood fill heightmap to find basins
		for (y in 0...heightmap.length)
		{
			for (x in 0...heightmap[0].length)
			{
				if (heightmap[y][x] < 9)
				{
					var points:Array<MyPoint> = [];
					var queue:Array<MyPoint> = [new MyPoint(x, y)];
					while (queue.length > 0)
					{
						var p:MyPoint = queue.shift();
						if (heightmap[p.y][p.x] < 9)
						{
							points.push(p);
							heightmap[p.y][p.x] = 9;
							if (p.x > 0)
								queue.push(new MyPoint(p.x - 1, p.y));
							if (p.x < heightmap[0].length-1)
								queue.push(new MyPoint(p.x + 1, p.y));
							if (p.y > 0)
								queue.push(new MyPoint(p.x, p.y - 1));
							if (p.y < heightmap.length-1)
								queue.push(new MyPoint(p.x, p.y + 1));
						}
					}
					if (points.length > 0)
						basins.push(points);
				}
			}
		}

		// sort basins by size
		basins.sort(function(a:Array<MyPoint>, b:Array<MyPoint>):Int
		{
			return b.length - a.length;
		});

		// multiply the length of the 3 largest basins
		return basins[0].length * basins[1].length * basins[2].length;
	}
}

class MyPoint
{
	public var x:Int;
	public var y:Int;

	public function new(X:Int, Y:Int):Void
	{
		x = X;
		y = Y;
	}
}
