package days;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxAxes;
import openfl.Assets;

class Day05 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 05 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 05 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day05a.txt").split("\r\n");

		var segments:Array<LineSegment> = [];

		var pieces:Array<String> = [];
		var startPos:Array<Null<Int>> = [];
		var endPos:Array<Null<Int>> = [];
		var segment:LineSegment = null;

		var maxX:Int = 0;
		var maxY:Int = 0;

		for (s in lines)
		{
			pieces = s.split(" -> ");
			startPos = pieces[0].split(",").map(Std.parseInt);
			endPos = pieces[1].split(",").map(Std.parseInt);
			segment = new LineSegment(startPos[0], startPos[1], endPos[0], endPos[1]);
			segments.push(segment);

			maxX = FlxMath.maxInt(maxX, segment.start.x);
			maxX = FlxMath.maxInt(maxX, segment.end.x);
			maxY = FlxMath.maxInt(maxY, segment.start.y);
			maxY = FlxMath.maxInt(maxY, segment.end.y);
		}

		var map:Map<String, Int> = [for (x in 0...maxX + 1) for (y in 0...maxY + 1) '$x,$y' => 0];

		var value:Int = 0;

		for (s in segments)
		{
			switch (s.axis)
			{
				case FlxAxes.X:
					var y:Int = s.start.y;
					for (x in s.start.x...s.end.x + 1)
					{
						value = map.get('$x,$y');

						map.set('$x,$y', value + 1);
					}

				case FlxAxes.Y:
					var x:Int = s.start.x;
					for (y in s.start.y...s.end.y + 1)
					{
						value = map.get('$x,$y');

						map.set('$x,$y', value + 1);
					}

				case FlxAxes.XY:
					// nuffin
			}
		}

		var count:Int = 0;
		for (value in map)
		{
			if (value > 1)
			{
				count++;
			}
		}

		trace(getMap(map, maxX, maxY));
		return count;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day05a.txt").split("\r\n");

		var segments:Array<LineSegment> = [];

		var pieces:Array<String> = [];
		var startPos:Array<Null<Int>> = [];
		var endPos:Array<Null<Int>> = [];
		var segment:LineSegment = null;

		var maxX:Int = 0;
		var maxY:Int = 0;

		for (s in lines)
		{
			pieces = s.split(" -> ");
			startPos = pieces[0].split(",").map(Std.parseInt);
			endPos = pieces[1].split(",").map(Std.parseInt);
			segment = new LineSegment(startPos[0], startPos[1], endPos[0], endPos[1]);
			segments.push(segment);

			maxX = FlxMath.maxInt(maxX, segment.start.x);
			maxX = FlxMath.maxInt(maxX, segment.end.x);
			maxY = FlxMath.maxInt(maxY, segment.start.y);
			maxY = FlxMath.maxInt(maxY, segment.end.y);
		}

		var map:Map<String, Int> = [for (x in 0...maxX + 1) for (y in 0...maxY + 1) '$x,$y' => 0];

		var value:Int = 0;

		for (s in segments)
		{
			var y:Int = s.start.y;
			var x:Int = s.start.x;
			switch (s.axis)
			{
				case FlxAxes.X:
					while (x <= s.end.x)
					{
						value = map.get('$x,$y');

						map.set('$x,$y', value + 1);
						x++;
					}

				case FlxAxes.Y:
					while (y <= s.end.y)
					{
						value = map.get('$x,$y');

						map.set('$x,$y', value + 1);
						y++;
					}

				case FlxAxes.XY:
					while (s.start.x < s.end.x ? x <= s.end.x : x >= s.end.x)
					{
						trace('$x,$y');

						value = map.get('$x,$y');

						map.set('$x,$y', value + 1);

						if (s.start.x < s.end.x)
							x++;
						else
							x--;
						if (s.start.y < s.end.y)
							y++;
						else
							y--;
					}
			}
		}

		var count:Int = 0;
		for (value in map)
		{
			if (value > 1)
			{
				count++;
			}
		}
		//trace(getMap(map, maxX, maxY));
		return count;
	}

	private function getMap(Map:Map<String, Int>, MaxX:Int, MaxY:Int):String
	{
		var showMap:String = "";
		var value:Int;

		for (x in 0...MaxX)
		{
			for (y in 0...MaxY)
			{
				value = Map.get('$x,$y');
				showMap += Std.string(value);
			}
			showMap += '\r\n';
		}
		return showMap;
	}
}

class LineSegment
{
	public var start:PointInt;
	public var end:PointInt;
	public var axis(get, null):FlxAxes;

	public function new(StartX:Int, StartY:Int, EndX:Int, EndY:Int):Void
	{
		if (StartX < EndX || StartY < EndY)
		{
			start = {x: StartX, y: StartY};
			end = {x: EndX, y: EndY};
		}
		else
		{
			start = {x: EndX, y: EndY};
			end = {x: StartX, y: StartY};
		}
	}

	private function get_axis():FlxAxes
	{
		if (start.x == end.x)
		{
			return FlxAxes.Y;
		}
		else if (start.y == end.y)
		{
			return FlxAxes.X;
		}
		else
		{
			return FlxAxes.XY;
		}
	}
}

typedef PointInt =
{
	var x:Int;
	var y:Int;
}
