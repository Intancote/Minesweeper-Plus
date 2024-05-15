import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;

class Tile extends FlxSprite
{
	public var isRevealed:Bool = false;
	public var isMine:Bool = false;
	public var adjacentMines:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/Tile-Unrevealed.png");
	}

	public function reveal()
	{
		if (!isRevealed)
		{
			if (isMine)
			{
				loadGraphic("assets/images/Exploded-Tile.png");
			}
			else
			{
				loadGraphic("assets/images/Tile-Empty.png");
				// Display the number of adjacent mines
				// This will depend on how you're displaying text in your game
			}
			isRevealed = true;
		}
	}

	public function countAdjacentMines()
	{
		// Implement this method to count the number of mines adjacent to this tile
		// This will involve checking the tiles around this one
	}
}

class PlayState extends FlxState
{
	// 2D array to store tile references
	private var tiles:Array<Array<Tile>>;

	override public function create()
	{
		super.create();

		// Define grid size
		var gridRows:Int = 9;
		var gridColumns:Int = 9;

		// Initialize the 2D array
		tiles = new Array<Array<Tile>>();
		for (i in 0...gridRows)
		{
			tiles[i] = new Array<Tile>();
			for (j in 0...gridColumns)
			{
				tiles[i][j] = null;
			}
		}

		// Define sprite size
		var spriteWidth:Int = 64;
		var spriteHeight:Int = 64;

		// Calculate the starting position for the first sprite
		var startX:Float = (FlxG.width - (gridColumns * spriteWidth)) / 2;
		var startY:Float = (FlxG.height - (gridRows * spriteHeight)) / 2;

		// Create sprites in a loop and store references in the 2D array
		for (i in 0...gridRows)
		{
			for (j in 0...gridColumns)
			{
				var tile = new Tile(startX + j * spriteWidth, startY + i * spriteHeight);
				add(tile);
				tiles[i][j] = tile; // Store the reference in the 2D array
			}
		}

		// Randomly place mines
		var totalMines:Int = 10; // Example number of mines
		var placedMines:Int = 0;
		while (placedMines < totalMines)
		{
			var randomRow:Int = Math.floor(Math.random() * gridRows);
			var randomColumn:Int = Math.floor(Math.random() * gridColumns);
			var tile = getTileAt(randomRow, randomColumn);
			if (tile != null && !tile.isMine)
			{
				tile.isMine = true;
				placedMines++;
			}
		}
	}

	function getTileAt(row:Int, column:Int):Tile
	{
		// Return the tile at the given row and column
		return tiles[row][column];
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Check if the mouse is pressed
		if (FlxG.mouse.justPressed)
		{
			for (tile in members)
			{
				if (FlxG.mouse.overlaps(tile))
				{
					if (cast(tile, Tile).isMine)
					{
						// End the game
						cast(tile, Tile).reveal();
						/* trace("Game Over"); */
					}
					else
					{
						cast(tile, Tile).reveal();
					}
					break;
				}
			}
		}
	}
}
