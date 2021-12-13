package days;

import flixel.system.FlxAssets.VirtualInputData;
import openfl.Assets;

using StringTools;

class Day12 extends Day
{
	private var caves:Map<String, Cave> = [];

	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 12 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 12 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day12atmp.txt").split("\r\n");

		var cave:Cave = null;
		for (l in lines)
		{
			var splits:Array<String> = l.split("-");
			if (caves.exists(splits[0]))
			{
				cave = caves.get(splits[0]);
			}
			else
			{
				cave = new Cave(splits[0]);
			}
			cave.addConnection(splits[1]);
			caves.set(splits[0], cave);

			if (caves.exists(splits[1]))
			{
				cave = caves.get(splits[1]);
			}
			else
			{
				cave = new Cave(splits[1]);
			}
			cave.addConnection(splits[0]);
			caves.set(splits[1], cave);
		}

		var paths:Int = 0;
		var visited:Map<String, Bool> = [];
		for (e in caves.keys())
		{
			visited.set(e, false);
		}

		paths = followPaths("start", "end", paths, visited);

		return paths;
	}

	private function followPaths(From:String, To:String, Paths:Int, Visited:Map<String, Bool>):Int
	{
		var cave:Cave = caves.get(From);
		if (cave.size == Small && From != "end")
			Visited.set(From, true);

		trace('From: $From ');

		if (From == To)
		{
			Paths++;
		}
		else
		{
			for (c in cave.connections)
			{
				if (!Visited.get(c))
				{
					Paths = followPaths(c, To, Paths, Visited);
				}
			}
			Visited.set(From, false);
		}
		return Paths;
	}

	private function getAnswerB():Float
	{
		var lines:Array<String> = Assets.getText("assets/data/day12a.txt").split("\r\n");

		var cave:Cave = null;
		for (l in lines)
		{
			var splits:Array<String> = l.split("-");
			if (caves.exists(splits[0]))
			{
				cave = caves.get(splits[0]);
			}
			else
			{
				cave = new Cave(splits[0]);
			}
			cave.addConnection(splits[1]);
			caves.set(splits[0], cave);

			if (caves.exists(splits[1]))
			{
				cave = caves.get(splits[1]);
			}
			else
			{
				cave = new Cave(splits[1]);
			}
			cave.addConnection(splits[0]);
			caves.set(splits[1], cave);
		}

		var paths:Array<Array<String>> = [];
		var visited:Map<String, Bool> = [];
		for (e in caves.keys())
		{
			visited.set(e, false);
		}

		paths = followPathsB(caves, "start", "end", [], true);

		return paths.length;
	}

	private function followPathsB(Caves:Map<String, Cave>, Start:String, End:String, Path:Array<String>, CanDouble:Bool = false):Array<Array<String>>
	{
		Path.push(Start);
		if (Start == End)
		{
			return [Path];
		}
		else if (!Caves.exists(Start) || !Caves.exists(End))
		{
			return [];
		}
		var paths:Array<Array<String>> = [];

		var cave:Cave = Caves.get(Start);
		for (c in cave.connections)
		{
			var neighbor:Cave = Caves.get(c);
			if (!(Path.contains(c) && neighbor.size == Small))
				paths = paths.concat(followPathsB(Caves, c, End, Path.copy(), CanDouble));
			else if (Path.contains(c) && neighbor.size == Small && CanDouble && c != "start")
				paths = paths.concat(followPathsB(Caves, c, End, Path.copy(), false));
		}

		return paths;
	}
}

class Cave
{
	public var name:String = "";
	public var size:CaveSize = Small;
	public var connections:Array<String> = [];

	public function new(Name:String):Void
	{
		name = Name;
		size = name.toLowerCase() == name ? Small : Large;
	}

	public function addConnection(Conn:String):Void
	{
		if (!connections.contains(Conn))
		{
			connections.push(Conn);
		}
	}
}

enum CaveSize
{
	Small;
	Large;
}
