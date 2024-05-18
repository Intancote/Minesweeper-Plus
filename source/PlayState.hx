import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

var totalMines:Int = 10; // Example value, adjusting later
var totalFlagsPlaced:Int = 0;
var lose:Bool = false;
var win:Bool = false;

class Tile extends FlxSprite
{
	public var isRevealed:Bool = false;
	public var isMine:Bool = false;
	public var isEmpty:Bool = false;
	public var adjacentMines:Int = 0;

	public var isFlagged:Bool = false;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic("assets/images/Tile-Unrevealed.png");
	}

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
				if (lose == false)
				{
					loadGraphic("assets/images/Tile-Exploded.png");
					lose = true;
				}
				else
				{
					loadGraphic("assets/images/Tile-Mine.png");
				}
			}
			else
			{
				var index = adjacentMines;
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
	public var time:Int;
	public var timeText:FlxText;
	public var gameTextWin:FlxText;
	public var gameTextLose:FlxText;

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

	override public function create()
	{
		super.create();

		time = 0;

		// Time text
		timeText = new FlxText(0, 0, FlxG.width, Std.string(time));
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
		placeMines(totalMines); // Adjust the number of mines as needed
	}

	private function countRevealedNonMineTiles():Int
	{
		var count = 0;
		for (row in tiles)
		{
			for (tile in row)
			{
				if (!tile.isMine && tile.isRevealed)
				{
					count++;
				}
			}
		}
		return count;
	}

	private function placeMines(Mines:Int):Void
	{
		var x:Int = 0;
		var y:Int = 0;

		for (m in 0...Mines)
		{
			x = Math.floor(Math.random() * gridColumns);
			y = Math.floor(Math.random() * gridRows);

			if (tiles[y][x].isMine)
				continue; // Ensure the tile is not already marked as a mine

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

	private function generateNumber(TileX:Int, TileY:Int):Void
	{
		if (TileX >= 0 && TileX < gridColumns && TileY >= 0 && TileY < gridRows)
		{
			var tile = getTileAt(TileY, TileX);
			if (tile != null && !tile.isMine)
			{
				tile.adjacentMines++;
			}
		}
	}

	function getTileAt(row:Int, column:Int):Tile
	{
		return tiles[row][column];
	}

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

		// Update the time display
		updateTimeDisplay();

		// Check if the game is won
		if (countRevealedNonMineTiles() == (gridRows * gridColumns) - numMines)
		{
			// Assuming all non-mine tiles are revealed
			win = true;
			gameTextWin.visible = true;

			// Fake lose condition to reveal mines as not exploded
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
				// Increment the time if the player has not lost
				time += 1;

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

	private function updateTimeDisplay():Void
	{
		// Calculate seconds
		var seconds:Int = Math.floor(time / 60);

		// Format the time display
		timeText.text = "Time: " + Std.string(seconds);
	}
}
