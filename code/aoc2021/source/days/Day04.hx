package days;

import openfl.Assets;

using StringTools;

class Day04 extends Day
{
	override public function start():Void
	{
		var answerA:Float = getAnswerA();

		PlayState.addOutput("Day 04 - Part A: " + Std.string(answerA));

		var answerB:Float = getAnswerB();

		PlayState.addOutput("Day 04 - Part B: " + Std.string(answerB));
	}

	private function getAnswerA():Float
	{
		var lines:String = Assets.getText("assets/data/day04a.txt");

		var rows:Array<String> = lines.split("\r\n");

		var r = ~/[,]+/g;

		var ballStrings:Array<String> = r.split(rows[0].trim());

		var balls:Array<Null<Int>> = ballStrings.map(Std.parseInt);

		var cards:Array<BingoCard> = [];

		var c:BingoCard = null;

		r = ~/[ ]+/g;

		for (i in 1...rows.length)
		{
			if (rows[i].trim() == "")
				cards.push(c = new BingoCard());
			else
			{
				c.spaces = c.spaces.concat(r.split(rows[i].trim()).map(Std.parseInt));
			}
		}

		var sum:Int = 0;
		var ballValue:Int = -1;

		for (b in balls)
		{
			trace('CHECKING BALL: $b');

			for (c in cards)
			{
				trace("CARD:", c.spaces);
				if (c.checkBall(b))
				{
					trace("FINISHED! Card:", c.spaces);

					sum = c.getRemaining();
					ballValue = b;
					break;
				}
			}
			if (ballValue > -1)
				break;
		}

		return sum * ballValue;
	}

	private function getAnswerB():Float
	{
		var lines:String = Assets.getText("assets/data/day04a.txt");

		var rows:Array<String> = lines.split("\r\n");

		var r = ~/[,]+/g;

		var ballStrings:Array<String> = r.split(rows[0].trim());

		var balls:Array<Null<Int>> = ballStrings.map(Std.parseInt);

		var cards:Array<BingoCard> = [];

		var c:BingoCard = null;

		r = ~/[ ]+/g;

		for (i in 1...rows.length)
		{
			if (rows[i].trim() == "")
				cards.push(c = new BingoCard());
			else
			{
				c.spaces = c.spaces.concat(r.split(rows[i].trim()).map(Std.parseInt));
			}
		}

		var sum:Int = 0;
		var ballValue:Int = -1;
		var allWon:Bool = false;

		var justWon:BingoCard = null;

		for (b in balls)
		{
			trace('CHECKING BALL: $b');
			allWon = true;
			justWon = null;
			for (c in cards)
			{
				if (!c.won)
				{
					trace("CARD:", c.spaces);
					if (c.checkBall(b))
						justWon = c;
					if (!c.won)
						allWon = false;
				}
			}

			if (allWon)
			{
				trace("FINISHED! Card:", justWon.spaces);

				sum = justWon.getRemaining();
				ballValue = b;
				trace('sum: $sum, ball: $ballValue');
				break;
			}
		}

		return sum * ballValue;
	}
}

class BingoCard
{
	public var spaces:Array<Null<Int>> = [];
	public var rows:Array<Int> = [0, 0, 0, 0, 0];
	public var cols:Array<Int> = [0, 0, 0, 0, 0];
	public var won:Bool = false;

	public function new():Void {}

	public function checkBall(B:Int):Bool
	{
		var index:Int = spaces.indexOf(B);
		if (index == -1)
			return false;
		else
		{
			trace('MATCHED AT $index');

			rows[Math.floor(index / 5)]++;
			cols[index % 5]++;
			spaces[index] = -1;
			trace(rows, cols);
			if (rows[Math.floor(index / 5)] >= 5 || cols[index % 5] >= 5)
			{
				trace("BINGO!");
				won = true;
				return true;
			}
		}
		return false;
	}

	public function getRemaining():Int
	{
		var value:Int = 0;
		for (i in spaces)
			value += i > 0 ? i : 0;
		return value;
	}
}
