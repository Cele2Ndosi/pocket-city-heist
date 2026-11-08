## The Level MODEL: what the world IS (size, walls, where things start).
## Rules and state only. It never draws and never reads input.
##
## Cells are grid coordinates stored as Vector2i:
## x = column, y = row, and (0, 0) is the top-left cell.
class_name Level
extends RefCounted

## The kinds of tile a cell can be.
enum Tile { FLOOR, WALL }

var width: int = 0
var height: int = 0
## Cell where the thief begins.
var thief_start: Vector2i = Vector2i.ZERO
## Cell where the loot is.
var loot: Vector2i = Vector2i.ZERO

## Tiles stored row by row: _tiles[y][x] holds a Tile value.
var _tiles: Array = []


## Builds a Level from text rows (see data/levels.gd for the legend).
static func from_rows(rows: Array) -> Level:
	var level := Level.new()
	level.height = rows.size()
	level.width = rows[0].length()

	for y in range(level.height):
		var row: String = rows[y]
		assert(row.length() == level.width, "Level row %d is not the same length as row 0." % y)
		var tile_row: Array = []
		for x in range(level.width):
			match row[x]:
				"#":
					tile_row.append(Tile.WALL)
				"T":
					level.thief_start = Vector2i(x, y)
					tile_row.append(Tile.FLOOR)
				"L":
					level.loot = Vector2i(x, y)
					tile_row.append(Tile.FLOOR)
				_:
					tile_row.append(Tile.FLOOR)
		level._tiles.append(tile_row)
	return level


## True if the cell is inside the level's grid.
func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < width and cell.y < height


## The Tile at a cell. Only call this for cells that are in bounds.
func tile_at(cell: Vector2i) -> int:
	return _tiles[cell.y][cell.x]


## True if something can stand on this cell (inside the grid and not a wall).
func is_walkable(cell: Vector2i) -> bool:
	return in_bounds(cell) and tile_at(cell) == Tile.FLOOR
