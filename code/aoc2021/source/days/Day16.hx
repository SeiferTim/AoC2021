package days;

import haxe.Int64;
import openfl.Assets;

using StringTools;

class Day16 extends Day
{
	override public function start():Void
	{
		// var answerA:Float = getAnswerA();

		// PlayState.addOutput("Day 16 - Part A: " + Std.string(answerA));

		var answerB:Int64 = getAnswerB();

		PlayState.addOutput("Day 16 - Part B: " + Int64.toStr(answerB));
	}

	private function getAnswerA():Float
	{
		var input:String = SpecialMath.hexToBin(Assets.getText("assets/data/day16a.txt").trim());

		var packet:Packet = new Packet(input);

		var sum:Float = packet.getVersionSum();

		return sum;
	}

	private function getAnswerB():Int64
	{
		var input:String = SpecialMath.hexToBin(Assets.getText("assets/data/day16a.txt").trim());

		var packet:Packet = new Packet(input);

		return packet.evaluate();
	}
}

class Packet
{
	public var version:Int = 0;
	public var typeID:Int = 0;

	public var payload:Dynamic;

	public var data:String = "";

	public var dataLength:Int = 0;

	public function new(Input:String):Void
	{
		data = Input;

		version = Int64.toInt(SpecialMath.binToInt(data.substr(0, 3)));

		typeID = Int64.toInt(SpecialMath.binToInt(data.substr(3, 3)));

		var inPos:Int = 6;
		if (typeID == 4)
		{
			// packet of literal value

			var valueString:String = "";
			var checkCode:String = "";

			while (checkCode != "0")
			{
				var block:String = data.substr(inPos, 5);
				inPos += 5;
				valueString += block.substr(1);
				checkCode = block.charAt(0);
			}

			payload = SpecialMath.binToInt(valueString);
			dataLength = inPos;
		}
		else
		{
			// packet of packets
			if (data.charAt(inPos) == "0")
			{
				// length of bits
				var length:Int = Int64.toInt(SpecialMath.binToInt(data.substr(inPos + 1, 15)));
				inPos += 16;

				var subData:String = data.substr(inPos, length);
				var subPos:Int = 0;

				var packets:Array<Packet> = [];

				while (subPos < length)
				{
					var p:Packet = new Packet(subData.substr(subPos));
					subPos += p.dataLength;
					packets.push(p);
				}

				payload = packets;
				dataLength = inPos + length;
			}
			else if (data.charAt(inPos) == "1")
			{
				// number of packets
				var numPackets:Int = Int64.toInt(SpecialMath.binToInt(data.substr(inPos + 1, 11)));
				inPos += 12;

				var packets:Array<Packet> = [];
				while (packets.length < numPackets)
				{
					var p:Packet = new Packet(data.substr(inPos));
					inPos += p.dataLength;
					packets.push(p);
				}

				payload = packets;
				dataLength = inPos;
			}
		}
	}

	public function evaluate():Int64
	{
		var value:Int64 = 0;
		var e:Int64 = 0;

		switch (typeID)
		{
			case 0: // SUM
				for (p in 0...payload.length)
				{
					value += payload[p].evaluate();
				}

			case 1: // PRODUCT
				value = payload[0].evaluate();
				for (p in 1...payload.length)
				{
					value *= payload[p].evaluate();
				}

			case 2: // MINIMUM
				value = payload[0].evaluate();
				for (p in 1...payload.length)
				{
					e = payload[p].evaluate();
					if (Int64.compare(e, value) < 0)
					{
						value = e;
					}
				}

			case 3: // MAXIMUM
				value = payload[0].evaluate();
				for (p in 1...payload.length)
				{
					e = payload[p].evaluate();
					if (Int64.compare(e, value) > 0)
					{
						value = e;
					}
				}

			case 4: // LITERAL
				value = payload;

			case 5: // GREATER THAN

				if (Int64.compare(payload[0].evaluate(), payload[1].evaluate()) > 0)
				{
					value = 1;
				}

			case 6: // LESS THAN
				if (Int64.compare(payload[0].evaluate(), payload[1].evaluate()) < 0)
				{
					value = 1;
				}

			case 7: // EQUAL TO
				if (Int64.compare(payload[0].evaluate(), payload[1].evaluate()) == 0)
				{
					value = 1;
				}
		}

		return value;
	}

	public function toString():String
	{
		var str:String = "Packet: { version: " + version + ", typeID: " + typeID + ", payload: ";

		if (typeID == 4)
		{
			str += Std.string(payload);
		}
		else
		{
			str += " [ ";

			for (p in 0...payload.length)
			{
				str += payload[p].toString() + (p < payload.length - 1 ? ", " : "");
			}

			str += " ]";
		}

		return str + " }";
	}

	public function getVersionSum():Float
	{
		var sum:Float = version;

		if (typeID != 4)
		{
			for (p in 0...payload.length)
			{
				sum += payload[p].getVersionSum();
			}
		}

		return sum;
	}
}

class SpecialMath
{
	// function to take string of hex characters and return string of binary characters
	public static function hexToBin(hex:String):String
	{
		var bin:String = "";
		var hexArray:Array<String> = hex.split("");

		for (i in 0...hexArray.length)
		{
			var hexChar:String = hexArray[i];
			var binChar:String = "";

			switch (hexChar.toUpperCase())
			{
				case "0":
					binChar = "0000";

				case "1":
					binChar = "0001";

				case "2":
					binChar = "0010";

				case "3":
					binChar = "0011";

				case "4":
					binChar = "0100";

				case "5":
					binChar = "0101";

				case "6":
					binChar = "0110";

				case "7":
					binChar = "0111";

				case "8":
					binChar = "1000";

				case "9":
					binChar = "1001";

				case "A":
					binChar = "1010";

				case "B":
					binChar = "1011";

				case "C":
					binChar = "1100";

				case "D":
					binChar = "1101";

				case "E":
					binChar = "1110";

				case "F":
					binChar = "1111";
			}

			bin += binChar;
		}

		return bin;
	}

	// function that takes a string of binary characters and returns the  value
	public static function binToInt(bin:String):Int64
	{
		var intValue:Int64 = 0;
		var binArray:Array<String> = bin.split("");

		for (i in 0...binArray.length)
		{
			var binChar:String = binArray[i];

			if (binChar == "1")
			{
				intValue += Int64.fromFloat(Math.pow(2, binArray.length - i - 1));
			}
		}

		return intValue;
	}
}
