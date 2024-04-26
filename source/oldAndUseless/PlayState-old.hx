package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var gameGrid:GameGrid;
	var gameLogic:GameLogic;
	var cellWidth:Int = 30; // Example value
	var cellHeight:Int = 30; // Example value

	override public function create():Void
	{
		super.create();
		gameGrid = new GameGrid(10, 10); // 10x10 grid
		gameLogic = new GameLogic();
		// Add game objects to the state
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
		{
			var mouseX = FlxG.mouse.screenX;
			var mouseY = FlxG.mouse.screenY;
			// Convert mouse position to grid coordinates
			var gridX = Math.floor(mouseX / cellWidth); // Assuming cellWidth is the width of a cell
			var gridY = Math.floor(mouseY / cellHeight); // Assuming cellHeight is the height of a cell
			// Call gameLogic.revealCell or gameLogic.flagCell based on input
			if (FlxG.mouse.justPressedRight)
			{
				gameLogic.flagCell(gameGrid, gridX, gridY);
			}
			else if (FlxG.mouse.pressed)
			{
				gameLogic.revealCell(gameGrid, gridX, gridY);
			}
		}
		gameLogic.checkGameOver(gameGrid);
	}

	override public function draw():Void
	{
		super.draw();
		for (y in 0...gameGrid.grid.length)
		{
			for (x in 0...gameGrid.grid[y].length)
			{
				var cell = gameGrid.grid[y][x];
				// Draw cell based on its state
				switch (cell.state)
				{
					case Covered:
					// Draw covered cell
					case Revealed:
					// Draw revealed cell, showing the number of adjacent mines if not a mine
					case Flagged:
						// Draw flagged cell
				}
			}
		}
	}
}

class GameGrid
{
	public var grid:Array<Array<Cell>>;

	public function new(width:Int, height:Int)
	{
		grid = new Array<Array<Cell>>();
		for (i in 0...height)
		{
			var row = new Array<Cell>();
			for (j in 0...width)
			{
				row.push(new Cell());
			}
			grid.push(row);
		}
	}
}

class Cell
{
	public var state:CellState;
	public var hasMine:Bool;
	public var adjacentMines:Int;
	public var stateChanged:Bool = true; // Default to true to draw initially

	public function new()
	{
		state = Covered;
		hasMine = false;
		adjacentMines = 0;
	}
}

enum CellState
{
	Covered;
	Revealed;
	Flagged;
}

class GameLogic
{
	public function new()
	{
		// Initialization code here, if necessary
	}

	public function revealCell(grid:GameGrid, x:Int, y:Int):Void
	{
		var cell = grid.grid[y][x];
		if (cell.state == Covered)
		{
			cell.state = Revealed;
			if (cell.hasMine)
			{
				// Game over
			}
			else
			{
				// Reveal adjacent cells
			}
		}
	}

	public function flagCell(grid:GameGrid, x:Int, y:Int):Void
	{
		var cell = grid.grid[y][x];
		if (cell.state == Covered)
		{
			cell.state = Flagged;
		}
		else if (cell.state == Flagged)
		{
			cell.state = Covered;
		}
	}

	public function checkGameOver(grid:GameGrid):Bool
	{
		for (y in 0...grid.grid.length)
		{
			for (x in 0...grid.grid[y].length)
			{
				var cell = grid.grid[y][x];
				if (cell.hasMine && cell.state == Revealed)
				{
					return true; // Game over if a mine is revealed
				}
			}
		}
		// Check if all non-mine cells are revealed
		for (y in 0...grid.grid.length)
		{
			for (x in 0...grid.grid[y].length)
			{
				var cell = grid.grid[y][x];
				if (!cell.hasMine && cell.state != Revealed)
				{
					return false; // Game continues if there are unrevealed non-mine cells
				}
			}
		}
		return true; // Game over if all non-mine cells are revealed
	}
}
