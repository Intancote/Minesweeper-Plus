import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;

// Define grid size
var gridRows:Int = 9;
var gridColumns:Int = 9;

// Define sprite size
var spriteWidth:Int = 64;
var spriteHeight:Int = 64;
var numMines:Int = 0;
var width:Int = gridColumns;
var height:Int = gridRows;
private var tiles:Array<Array<Tile>>;

class Tile extends FlxSprite
{
	private var mineCountSprites:Array<String> = [
		"assets/images/Tile-Empty.png", // 0 mines
		"assets/images/Tile-1.png", // 1 mine
		"assets/images/Tile-2.png", // 2 mines
		"assets/images/Tile-3.png", // 3 mines
		"assets/images/Tile-4.png", // 4 mines
		"assets/images/Tile-5.png", // 5 mines
		"assets/images/Tile-6.png", // 6 mines
		"assets/images/Tile-7.png", // 7 mines
		"assets/images/Tile-8.png" // 8 mines
	];

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
			isRevealed = true;
			var spriteName:String = getSpriteName();
			loadGraphic(spriteName);

			if (isMine)
			{
				loadGraphic("assets/images/Exploded-Tile.png");
			}
			else
			{
				// Load the sprite based on the number of adjacent mines
				loadGraphic(spriteName);
			}
		}
	}

	private function getSpriteName():String
	{
		var adjacentMines:Int = countAdjacentMines();
		return mineCountSprites[adjacentMines];
	}

	private function countAdjacentMines():Int
	{
		var adjacentMines:Int = 0;
		var adjacentTiles:Array<Tile> = getAdjacentTiles();

		for (adjacentTile in adjacentTiles)
		{
			if (adjacentTile.isMine)
			{
				adjacentMines++;
			}
		}

		return adjacentMines;
	}

	private function getAdjacentTiles():Array<Tile>
	{
		var adjacentTiles:Array<Tile> = [];
		var row:Int = Math.floor(this.y / spriteHeight - 1);
		var column:Int = Math.floor(this.x / spriteWidth - 1);

		// Offsets for the 8 surrounding tiles
		var offsets:Array<{x:Int, y:Int}> = [
			{x: -1, y: -1},
			{x: 0, y: -1},
			{x: 1, y: -1},
			{x: -1, y: 0},
			{x: 1, y: 0},
			{x: -1, y: 1},
			{x: 0, y: 1},
			{x: 1, y: 1}
		];

		// Get the valid adjacent tiles
		for (offset in offsets)
		{
			var adjacentRow:Int = row + offset.y;
			var adjacentColumn:Int = column + offset.x;

			// Ensure we're within the grid bounds
			if (adjacentRow >= 0 && adjacentRow < gridRows && adjacentColumn >= 0 && adjacentColumn < gridColumns)
			{
				var adjacentTile = tiles[adjacentRow][adjacentColumn];
				adjacentTiles.push(adjacentTile);
			}
		}

		return adjacentTiles;
	}
}

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

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

		/* // Randomly place mines
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
		}*/

		// Call placeMines with the desired number of mines
		placeMines(10); // Example: placing 10 mines
	}

	private function placeMines(Mines:Int):Void
	{
		var x = 0;
		var y = 0;

		for (m in 0...Mines)
		{
			x = Math.floor(Math.random() * width);
			y = Math.floor(Math.random() * height);

			// Assuming tiles is your 2D array and MINE is a constant representing a mine
			tiles[y][x].isMine = true;
			numMines++;

			// Generate numbers for surrounding tiles
			generateNumber(x - 1, y);
			generateNumber(x + 1, y);
			generateNumber(x, y - 1);
			generateNumber(x, y + 1);
			generateNumber(x + 1, y + 1);
			generateNumber(x - 1, y + 1);
			generateNumber(x - 1, y - 1);
			generateNumber(x + 1, y - 1);
		}
	}

	private function generateNumber(TileX:Int, TileY:Int):Void
	{
		if (TileX >= 0 && TileX < width && TileY >= 0 && TileY < height)
		{
			var tile = tiles[TileY][TileX];
			if (tile != null && !tile.isMine)
			{
				tile.adjacentMines++; // Increment the adjacent mine count
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
