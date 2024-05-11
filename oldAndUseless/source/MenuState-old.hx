package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}

	override public function create()
	{
		var playButton:FlxButton;
		playButton = new FlxButton(0, 0, "Play", clickPlay);
		add(playButton);
		playButton.screenCenter();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
