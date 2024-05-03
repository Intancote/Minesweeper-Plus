import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;

class PlayState extends FlxState
{
	private var tileURSprite:FlxSprite;

	override public function create()
	{
		super.create();

		// Define grid size
		var gridRows:Int = 9;
		var gridColumns:Int = 9;

		// Define sprite size
		var spriteWidth:Int = 64;
		var spriteHeight:Int = 64;

		// Calculate the starting position for the first sprite
		var startX:Float = (FlxG.width - (gridColumns * spriteWidth)) / 2;
		var startY:Float = (FlxG.height - (gridRows * spriteHeight)) / 2;

		// Create sprites in a loop
		for (i in 0...gridRows)
		{
			for (j in 0...gridColumns)
			{
				var sprite = new FlxSprite(startX + j * spriteWidth, startY + i * spriteHeight);
				sprite.loadGraphic("assets/images/Tile-Unrevealed.png");
				add(sprite);
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check if the mouse is pressed
		if (FlxG.mouse.justPressed)
		{
			// Get the mouse position
			var mouseX:Float = FlxG.mouse.screenX;
			var mouseY:Float = FlxG.mouse.screenY;

			// Loop through all the sprites (tiles) in the state
			for (sprite in members)
			{
				if (FlxG.mouse.overlaps(sprite))
				{
					/* sprite.loadGraphic("assets/images/Tile-Empty.png"); */
					// Perform an action when a tile is clicked, e.g., reveal the tile
					// This is a placeholder for your actual logic
					/* trace("Tile clicked: " + sprite.x + ", " + sprite.y); */
					// You can add your logic here to reveal the tile or perform other actions
				}
			}
		}
	}
}
