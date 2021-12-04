package;

import days.Day01;
import days.Day02;
import days.Day03;
import days.Day04;
import days.Day;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public static final DAYS:Int = 4;
	private static var txtField:MyScrollText;

	override public function create():Void
	{
		FlxG.autoPause = false;

		var t:FlxText = new FlxText(10, 10, "Select a Day to Run:");
		add(t);

		for (i in 0...DAYS)
		{
			addDayButton(i);
		}

		txtField = new MyScrollText(10, FlxG.height - 120, FlxG.width - 20, 110);

		var back:FlxSprite = new FlxSprite(txtField.x - 1, txtField.y - 1);
		back.makeGraphic(Std.int(txtField.width + 2), Std.int(txtField.height + 2), FlxColor.WHITE);
		add(back);

		add(txtField);

		super.create();
	}

	public static function addOutput(Message:String = ""):Void
	{
		txtField.text += '$Message\n';
		trace("$Message\n");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function addDayButton(Number:Int):Void
	{
		var b:FlxButton = new FlxButton(10, 10, Std.string(Number + 1), callDay.bind(Number));
		b.x = 10 + ((b.width + 10) * ((Number) % 7));
		b.y = 30 + ((b.height + 10) * Std.int((Number) / 7));
		add(b);
	}

	private function callDay(Number:Int):Void
	{
		var cName:String = "days.Day" + StringTools.lpad(Std.string(Number + 1), "0", 2);
		var c = Type.resolveClass(cName);

		var day:Day = Type.createInstance(c, []);

		var time:Float = Sys.time();
		day.start();
		addOutput("Time taken: " + Std.string(Sys.time() - time) + "s");
	}
}
