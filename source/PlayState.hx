import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

// SECTION - Global Variables
var totalMines:Int = 10; // NOTE - Change this value to whatever difficulty is selected (Currently no difficulty selection implemented)
var totalFlagsPlaced:Int = 0;
var lose:Bool = false;
var win:Bool = false;

// !SECTION
// SECTION - Known BUGS
/*
	1. When you win or lose. When revealing the mines,
	the game will change the number of flags placed to the total number of mines again
	(unless the flag is not on a mine, in which case it will decrement the total flags placed).
	This is a bug because the total flags placed should not change when the game is over.

	2. Clicking on any of the texts in the game will cause the game to freeze/crash.

	3. On some very few occations, the amount of mines placed isn't the same as the total number of mines set in the code.
	I literally have no idea why this is happening. I've tried to debug it but I can't find the issue.

	If any more bugs are found, they will be added here.
 */
// !SECTION
class Tile extends FlxSprite
{
	// Reveal state
	public var isRevealed:Bool = false;
	public var isMine:Bool = false;
	public var isEmpty:Bool = false;
	public var adjacentMines:Int = 0;

	// Flagging
	public var isFlagged:Bool = false;

	// Initialize the tile sprite
	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/Tile-Unrevealed.png");
	}

	// Toggle the flag on the tile
	public function toggleFlag():Void
	{
		// NOTE: Might add ? tiles to the game later for suspected mine tiles

		// Only allow flagging if the tile is not already revealed
		if (!isRevealed)
		{
			if (isFlagged)
			{
				// Removing a flag
				isFlagged = false;
				loadGraphic("assets/images/Tile-Unrevealed.png");
				totalFlagsPlaced--; // Decrement the total flags placed
			}
			else if (totalFlagsPlaced < totalMines)
			{
				// Placing a flag
				isFlagged = true;
				loadGraphic("assets/images/Tile-Flagged.png");
				totalFlagsPlaced++; // Increment the total flags placed
			}
		}
	}

	// Reveal the tile
	public function reveal(mineCountSprites:Array<String>):Void
	{
		if (!isRevealed)
		{
			isRevealed = true;
			if (isFlagged)
			{
				// If the tile was flagged, decrement the total flags placed
				totalFlagsPlaced--;
			}

			if (isMine)
			{
				// If the tile is a mine, show the mine with or without the explosion

				// If the game is lost, show the mine with the explosion
				if (lose == false)
				{
					loadGraphic("assets/images/Tile-Exploded.png");
					lose = true;
				}
				else
				{
					// If the game is already lost (or fake lost), show the other mines without the explosion
					if (isFlagged)
					{
						loadGraphic("assets/images/Tile-Flagged.png");
					}
					else
					{
						loadGraphic("assets/images/Tile-Mine.png");
					}
				}
			}
			else
			{
				var index = adjacentMines;

				// If the tile is not a mine, show the number of adjacent mines (if any)
				if (index < mineCountSprites.length)
				{
					loadGraphic(mineCountSprites[index]);
				}
				else
				{
					loadGraphic("assets/images/Tile-Empty.png"); // Fallback for more than 8 mines (Shouldn't be possible)
				}
			}
		}
	}
}

class PlayState extends FlxState
{
	// Time, flag count, and game condition text
	public var time:Int;
	public var timeText:FlxText;
	public var flagCounter:FlxText;
	public var gameTextWin:FlxText;
	public var gameTextLose:FlxText;

	// Array of mine count sprites
	private var mineCountSprites:Array<String> = [
		"assets/images/Tile-Empty.png",
		"assets/images/Tile-1.png",
		"assets/images/Tile-2.png",
		"assets/images/Tile-3.png",
		"assets/images/Tile-4.png",
		"assets/images/Tile-5.png",
		"assets/images/Tile-6.png",
		"assets/images/Tile-7.png",
		"assets/images/Tile-8.png"
	];

	// 2D array to store tile references
	private var tiles:Array<Array<Tile>>;
	private var numMines:Int = 0;

	// Define grid size
	var gridRows:Int = 9;
	var gridColumns:Int = 9;

	// Initialize the game state
	override public function create()
	{
		#if web
		FlxG.stage.showDefaultContextMenu = false; // Disable the right-click menu
		#end

		super.create();

		// Initialize the time
		time = 0;

		// Time text
		timeText = new FlxText(0, 0, FlxG.width);
		timeText.setFormat(null, 20, FlxColor.WHITE, "center");
		add(timeText);

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

		// Flag count text
		flagCounter = new FlxText(0, 0, FlxG.width);
		flagCounter.setFormat(null, 30, FlxColor.RED, "left", SHADOW, FlxColor.WHITE);
		add(flagCounter);

		// Game win text
		gameTextWin = new FlxText(0, 320, FlxG.width, "You Win!");
		gameTextWin.setFormat(null, 80, FlxColor.WHITE, "center", OUTLINE_FAST, FlxColor.BLACK);
		gameTextWin.visible = false;
		add(gameTextWin);

		// Game lose text
		gameTextLose = new FlxText(0, 320, FlxG.width, "You Lose!");
		gameTextLose.setFormat(null, 80, FlxColor.WHITE, "center", OUTLINE_FAST, FlxColor.BLACK);
		gameTextLose.visible = false;
		add(gameTextLose);

		// Call placeMines after initializing the grid
		placeMines(totalMines);
	}

	// Count the number of revealed non-mine tiles
	private function countRevealedNonMineTiles():Int
	{
		var count = 0;
		for (row in tiles) // Loop through all rows
		{
			for (tile in row) // Loop through all tiles
			{
				if (!tile.isMine && tile.isRevealed) // Check if the tile is not a mine and is revealed
				{
					count++; // Increment the count
				}
			}
		}
		return count;
	}

	// Place mines randomly on the grid
	private function placeMines(Mines:Int):Void
	{
		var x:Int = 0;
		var y:Int = 0;

		for (m in 0...Mines) // Loop through the number of mines (does it though???)
		{
			// Generate random coordinates
			x = Math.floor(Math.random() * gridColumns);
			y = Math.floor(Math.random() * gridRows);

			// Ensure the tile is not already marked as a mine
			if (tiles[y][x].isMine)
				continue;

			// Mark the tile as a mine
			tiles[y][x].isMine = true;
			numMines++;

			// Generate numbers for surrounding tiles using a loop
			for (i in -1...2)
			{
				for (j in -1...2)
				{
					if (i == 0 && j == 0)
						continue;
					generateNumber(x + i, y + j);
				}
			}
		}
	}

	// Generate a number for a tile
	private function generateNumber(TileX:Int, TileY:Int):Void
	{
		// Check if the tile is within the grid
		if (TileX >= 0 && TileX < gridColumns && TileY >= 0 && TileY < gridRows)
		{
			// Get the tile reference
			var tile = getTileAt(TileY, TileX);

			// Increment the adjacent mines count if the tile is not a mine
			if (tile != null && !tile.isMine)
			{
				tile.adjacentMines++;
			}
		}
	}

	// Get a tile at a specific row and column
	function getTileAt(row:Int, column:Int):Tile
	{
		return tiles[row][column];
	}

	// Update the game state
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Show all mines if the player loses or wins
		if (lose == true)
		{
			// Reveal all mines
			for (row in tiles)
			{
				for (tile in row)
				{
					if (tile.isMine)
					{
						tile.reveal(mineCountSprites);
					}
				}
			}
		}

		// Update the time and flag count displays continuously
		updateTimeDisplay();
		updateFlagCountDisplay();

		// Check if the game is won
		if (countRevealedNonMineTiles() == (gridRows * gridColumns) - numMines)
		{
			// Assuming all non-mine tiles are revealed
			win = true;
			gameTextWin.visible = true;

			// Enable a fake lose condition to reveal mines as not exploded (Won't show lose text)
			lose = true;

			// Reveal all mines
			for (row in tiles)
			{
				for (tile in row)
				{
					if (tile.isMine)
					{
						tile.reveal(mineCountSprites);
					}
				}
			}
		}

		// Check if the mouse is pressed
		if (lose == false)
		{
			if (win == false)
			{
				time += 1; // Increment the time if the player has not lost or won

				// Check if the left mouse button is pressed
				if (FlxG.mouse.justReleased)
				{
					for (tile in members)
					{
						if (FlxG.mouse.overlaps(tile))
						{
							if (cast(tile, Tile).isMine)
							{
								// End the game
								gameTextLose.visible = true;
								cast(tile, Tile).reveal(mineCountSprites);
							}
							else
							{
								cast(tile, Tile).reveal(mineCountSprites);
							}
							break;
						}
					}
				}

				// Check if the right mouse button is pressed
				if (FlxG.mouse.justPressedRight)
				{
					for (tile in members)
					{
						if (FlxG.mouse.overlaps(tile))
						{
							cast(tile, Tile).toggleFlag();
							break;
						}
					}
				}
			}
		}
	}

	// Update the flag count display
	private function updateFlagCountDisplay():Void
	{
		// Calculate the number of flags left
		var flagCount:Int = Math.floor(totalMines - totalFlagsPlaced);

		// Format the flag count display
		flagCounter.text = "Flags Left: " + Std.string(flagCount);
	}

	// Update the time display
	private function updateTimeDisplay():Void
	{
		// Calculate seconds
		var seconds:Int = Math.floor(time / 60);

		// Format the time display
		timeText.text = "Time: " + Std.string(seconds);
	}
}
