package days;

import days.Day09.MyPoint;
import openfl.Assets;

using StringTools;

class Day15 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 15 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 15 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day15a.txt").split("\r\n");

		var grid:Array<Array<Null<Int>>> = [];
		for (l in lines)
		{
			grid.push(l.split("").map(Std.parseInt));
		}

		var pathValue:Float = aStarSearch(grid, new MyPoint(0, 0), new MyPoint(grid[0].length - 1, grid.length - 1));

		return pathValue;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day15a.txt").split("\r\n");

		var baseGrid:Array<Array<Null<Int>>> = [];
		for (l in lines)
		{
			baseGrid.push(l.split("").map(Std.parseInt));
		}

		var grid:Array<Array<Null<Int>>> = [
			for (y in 0...Std.int(baseGrid.length * 5)) [for (x in 0...Std.int(baseGrid[0].length * 5)) 0]
		];

		for (y in 0...baseGrid.length)
		{
			for (x in 0...baseGrid[0].length)
			{
				var originalValue:Int = baseGrid[y][x];

				for (stepX in 0...5)
				{
					for (stepY in 0...5)
					{
						grid[y + (baseGrid.length * stepY)][x + (baseGrid[0].length * stepX)] = (originalValue + stepX + stepY) > 9 ? (originalValue + stepX
							+ stepY) - 9 : (originalValue + stepX + stepY);
					}
				}
			}
		}

		// trace(grid);

		var pathValue:Float = aStarSearch(grid, new MyPoint(0, 0), new MyPoint(grid[0].length - 1, grid.length - 1));
		return pathValue;
	}

	private function aStarSearch(grid:Array<Array<Null<Int>>>, start:MyPoint, end:MyPoint):Int
	{
		var frontier:Array<PriorityObject<MyPoint>> = [];
		frontier.push(new PriorityObject(start, 0));

		var cameFrom:Map<String, Null<MyPoint>> = [];
		var costSoFar:Map<String, Int> = [];

		// cameFrom.set(start.toString(), null);
		costSoFar.set(start.toString(), 0);

		while (frontier.length > 0)
		{
			var current:MyPoint = frontier.shift().object;

			if (current.equals(end))
			{
				break;
			}

			var neighbors:Array<MyPoint> = getNeighbors(grid, current);
			for (next in neighbors)
			{
				var newCost:Int = costSoFar.get(current.toString()) + grid[next.y][next.x];

				if (!costSoFar.exists(next.toString()) || newCost < costSoFar.get(next.toString()))
				{
					costSoFar.set(next.toString(), newCost);
					var priority:Int = newCost + heuristic(next, end);
					frontier.push(new PriorityObject<MyPoint>(next, priority));
					frontier.sort(function(a:PriorityObject<MyPoint>, b:PriorityObject<MyPoint>):Int
					{
						return a.priority - b.priority;
					});
					cameFrom.set(next.toString(), current);
				}
			}
		}

		var totalCost:Int = 0;
		var current:MyPoint = end;
		while (cameFrom.exists(current.toString()))
		{
			totalCost += grid[current.y][current.x];
			current = cameFrom.get(current.toString());
			if (current == null)
				break;
		}

		return totalCost;
	}

	private function heuristic(a:MyPoint, b:MyPoint):Int
	{
		return Std.int(Math.abs(a.x - b.x) + Math.abs(a.y - b.y));
	}

	private function getNeighbors(grid:Array<Array<Null<Int>>>, current:MyPoint):Array<MyPoint>
	{
		var neighbors:Array<MyPoint> = [];

		var x:Int = current.x;
		var y:Int = current.y;

		if (x > 0)
		{
			neighbors.push(new MyPoint(x - 1, y));
		}

		if (x < grid[0].length - 1)
		{
			neighbors.push(new MyPoint(x + 1, y));
		}

		if (y > 0)
		{
			neighbors.push(new MyPoint(x, y - 1));
		}

		if (y < grid.length - 1)
		{
			neighbors.push(new MyPoint(x, y + 1));
		}

		return neighbors;
	}
}

class PriorityObject<T>
{
	public var object:T;
	public var priority:Int;

	public function new(object:T, priority:Int):Void
	{
		this.object = object;
		this.priority = priority;
	}
}
