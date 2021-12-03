package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class MyScrollText extends FlxText
{
	public var setHeight(default, null):Int = 4;

	public function new(X:Float, Y:Float, Width:Float, Height:Float)
	{
		super(X, Y, Width, "", 8, true);

		setHeight = Std.int(Height);
		autoSize = false;
		color = FlxColor.WHITE;
		wordWrap = true;

		textField.mouseWheelEnabled = true;
		textField.multiline = true;
		textField.selectable = true;
		textField.opaqueBackground = FlxColor.BLACK;
		textField.type = TextFieldType.DYNAMIC;
		textField.wordWrap = true;
		textField.autoSize = TextFieldAutoSize.NONE;
		textField.mouseEnabled = true;
	}

	override private function regenGraphic():Void
	{
		if (textField == null || !_regen)
			return;

		var oldWidth:Int = 0;
		var oldHeight:Int = 4;

		if (graphic != null)
		{
			oldWidth = graphic.width;
			oldHeight = graphic.height;
		}

		var newWidth:Float = textField.width;
		// Account for gutter
		var newHeight:Float = setHeight + 4;

		// prevent text height from shrinking on flash if text == ""
		if (textField.textHeight == 0)
		{
			newHeight = setHeight;
		}

		if (oldWidth != newWidth || oldHeight != newHeight)
		{
			// Need to generate a new buffer to store the text graphic
			height = newHeight;
			var key:String = FlxG.bitmap.getUniqueKey("text");
			makeGraphic(Std.int(newWidth), Std.int(newHeight), FlxColor.TRANSPARENT, false, key);

			if (_hasBorderAlpha)
				_borderPixels = graphic.bitmap.clone();
			frameHeight = Std.int(height);
			textField.height = height; // * 1.2;
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = newWidth;
			_flashRect.height = newHeight;
		}
		else // Else just clear the old buffer before redrawing the text
		{
			graphic.bitmap.fillRect(_flashRect, FlxColor.TRANSPARENT);
			if (_hasBorderAlpha)
			{
				if (_borderPixels == null)
					_borderPixels = new BitmapData(frameWidth, frameHeight, true);
				else
					_borderPixels.fillRect(_flashRect, FlxColor.TRANSPARENT);
			}
		}

		if (textField != null && textField.text != null && textField.text.length > 0)
		{
			// Now that we've cleared a buffer, we need to actually render the text to it
			copyTextFormat(_defaultFormat, _formatAdjusted);

			_matrix.identity();

			applyBorderStyle();
			applyBorderTransparency();
			applyFormats(_formatAdjusted, false);
			textField.scrollV = textField.maxScrollV;
			drawTextFieldTo(graphic.bitmap);
		}

		_regen = false;
		resetFrame();
	}
}
