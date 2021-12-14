package days;

import days.Day09.MyPoint;
import flixel.util.FlxAxes;
import openfl.Assets;

using StringTools;

class Day13 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 13 - Part A: " + Std.string(answerA));

		var answerB:String = getAnswerB();

		PlayState.addOutput("Day 13 - Part B: " + answerB);
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day13a.txt").split("\r\n");
		var folds:Array<Fold> = [];

		var maxX:Int = 0;
		var maxY:Int = 0;
		var points:Array<String> = [];

		for (l in lines)
		{
			if (l.trim() != "")
			{
				if (l.startsWith("fold along"))
				{
					var end:String = l.substring(l.lastIndexOf(" ") + 1);
					var split:Array<String> = end.split("=");
					trace(l, split[0], split[1]);
					folds.push(new Fold(split[0], Std.parseInt(split[1])));
				}
				else
				{
					var split:Array<String> = l.split(",");
					points.push(l);
					if (Std.parseInt(split[0]) > maxX)
						maxX = Std.parseInt(split[0]);
					if (Std.parseInt(split[1]) > maxY)
						maxY = Std.parseInt(split[1]);
				}
			}
		}

		switch (folds[0].axis)
		{
			case 'x':
				for (x in 1...(maxX + 1) - folds[0].line)
				{
					for (y in 0...maxY + 1)
					{
						if (points.contains(Std.string(folds[0].line + x) + "," + Std.string(y)))
						{
							if (!points.contains(Std.string(folds[0].line - x) + "," + Std.string(y)))
								points.push(Std.string(folds[0].line - x) + "," + Std.string(y));
							points.remove(Std.string(folds[0].line + x) + "," + Std.string(y));
						}
					}
				}
				maxX = folds[0].line - 1;

			case 'y':
				for (y in 1...(maxY + 1) - folds[0].line)
				{
					for (x in 0...maxX + 1)
					{
						if (points.contains(Std.string(x) + "," + Std.string(folds[0].line + y)))
						{
							if (!points.contains(Std.string(x) + "," + Std.string(folds[0].line - y)))
								points.push(Std.string(x) + "," + Std.string(folds[0].line - y));
							points.remove(Std.string(x) + "," + Std.string(folds[0].line + y));
						}
					}
				}
				maxY = folds[0].line - 1;

			default:
		}

		return points.length;
	}

	private function getAnswerB():String
	{
		var lines:Array<String> = Assets.getText("assets/data/day13a.txt").split("\r\n");
		var folds:Array<Fold> = [];

		var maxX:Int = 0;
		var maxY:Int = 0;
		var points:Array<String> = [];

		for (l in lines)
		{
			if (l.trim() != "")
			{
				if (l.startsWith("fold along"))
				{
					var end:String = l.substring(l.lastIndexOf(" ") + 1);
					var split:Array<String> = end.split("=");
					trace(l, split[0], split[1]);
					folds.push(new Fold(split[0], Std.parseInt(split[1])));
				}
				else
				{
					var split:Array<String> = l.split(",");
					points.push(l);
					if (Std.parseInt(split[0]) > maxX)
						maxX = Std.parseInt(split[0]);
					if (Std.parseInt(split[1]) > maxY)
						maxY = Std.parseInt(split[1]);
				}
			}
		}

		for (f in folds)
		{
			switch (f.axis)
			{
				case 'x':
					for (x in 1...(maxX + 1) - f.line)
					{
						for (y in 0...maxY + 1)
						{
							if (points.contains(Std.string(f.line + x) + "," + Std.string(y)))
							{
								if (!points.contains(Std.string(f.line - x) + "," + Std.string(y)))
									points.push(Std.string(f.line - x) + "," + Std.string(y));
								points.remove(Std.string(f.line + x) + "," + Std.string(y));
							}
						}
					}
					maxX = f.line ;

				case 'y':
					for (y in 1...(maxY + 1) - f.line)
					{
						for (x in 0...maxX + 1)
						{
							if (points.contains(Std.string(x) + "," + Std.string(f.line + y)))
							{
								if (!points.contains(Std.string(x) + "," + Std.string(f.line - y)))
									points.push(Std.string(x) + "," + Std.string(f.line - y));
								points.remove(Std.string(x) + "," + Std.string(f.line + y));
							}
						}
					}
					maxY = f.line ;

				default:
			}
		}

		var result:String = "\r\n\r\n";

		for (y in 0...maxY)
		{
			for (x in 0...maxX)
			{
				if (points.contains(Std.string(x) + "," + Std.string(y)))
					result += "#";
				else
					result += ".";
			}
			result += "\r\n";
		}

		trace(result);

		return result;
	}
}

class Fold
{
	public var axis:String;
	public var line:Int;

	public function new(Axis:String, Line:Int):Void
	{
		axis = Axis;
		line = Line;
	}
}
