import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;

class PlayState extends FlxState
{
	private var tileURSprite:FlxSprite;

	override public function create()
	{
		super.create();

		var testSprite = new FlxSprite();
		testSprite.loadGraphic("assets/images/Unrevealed-Tile.png",);
		add(testSprite);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
