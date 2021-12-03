package days;

import flixel.math.FlxPoint;
import openfl.Assets;

class Day02 extends Day
{
	override public function start():Void
	{
		var answerA:Float = getAnswerA();
		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 02 - Part A: " + Std.string(answerA));
		PlayState.addOutput("Day 02 - Part B: " + Std.string(answerB));
	}

	private function parseCommand(S:String):Command
	{
		var s:Array<String> = S.split(" ");

		return {
			direction: s[0],
			amount: Std.parseInt(s[1])
		};
	}

	private function getAnswerA():Float
	{
		var lines:String = Assets.getText("assets/data/day02a.txt");
		var inputs:Array<Null<Command>> = lines.split("\r\n").map(parseCommand);

		var pos:FlxPoint = FlxPoint.get();

		var larger:Int = 0;

		for (i in inputs)
		{
			// PlayState.addOutput(Std.string(pos) + ": " + Std.string(i));

			switch (i.direction)
			{
				case "up":
					pos.y -= i.amount;

				case "down":
					pos.y += i.amount;

				case "forward":
					pos.x += i.amount;
			}
		}
		return pos.x * pos.y;
	}

	private function getAnswerB():Float
	{
		var lines:String = Assets.getText("assets/data/day02a.txt");
		var inputs:Array<Null<Command>> = lines.split("\r\n").map(parseCommand);

		var h:Int = 0;
		var aim:Int = 0;
		var d:Int = 0;

		var larger:Int = 0;

		for (i in inputs)
		{
			// PlayState.addOutput(Std.string(pos) + ": " + Std.string(i));

			switch (i.direction)
			{
				case "up":
					aim -= i.amount;

				case "down":
					aim += i.amount;

				case "forward":
					h += i.amount;
					d += aim * i.amount;
			}
		}
		return h * d;
	}
}

typedef Command =
{
	var direction:Direction;
	var amount:Int;
}

@:enum abstract Direction(String) from String to String
{
	public var forward;
	public var down;
	public var up;
}
