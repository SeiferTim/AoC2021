package days;

class Day implements IDay
{
	public function new():Void {};

	public function start():Void {};
}

interface IDay
{
	public function start():Void;
}
