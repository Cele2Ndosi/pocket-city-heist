## Draws a Level on screen (floor and walls) and converts between grid
## cells and pixels. It only LOOKS at the Level; it never changes it.
##
## Usage: set `level` FIRST, then add this node to the scene
## (drawing happens the moment it enters the scene).
class_name LevelView
extends Node2D

## Side length of one grid cell, in pixels.
const TILE_SIZE: int = 80

const FLOOR_COLOR := Color("#cfd8dc")
const WALL_COLOR := Color("#37474f")
const GRID_LINE_COLOR := Color("#b0bec5")

## The level to draw. Must be set before add_child().
var level: Level


## Fails early, with a clear message, if the level was forgotten.
func _ready() -> void:
	assert(level != null, "LevelView.level must be set before add_child().")


## Size of the whole level in pixels.
func pixel_size() -> Vector2:
	return Vector2(level.width, level.height) * TILE_SIZE


## Pixel position (relative to this node) of the centre of a grid cell.
func cell_center(cell: Vector2i) -> Vector2:
	return (Vector2(cell) + Vector2(0.5, 0.5)) * TILE_SIZE


## Creates an ActorView standing on `cell` and adds it as a child of this node.
## Children draw on top of the tiles and move together with the level.
func spawn_actor(cell: Vector2i, color: Color) -> ActorView:
	var actor := ActorView.new()
	actor.color = color
	actor.position = cell_center(cell)
	add_child(actor)
	return actor


## Paints every tile. Godot calls this automatically.
func _draw() -> void:
	for y in range(level.height):
		for x in range(level.width):
			var cell := Vector2i(x, y)
			var rect := Rect2(Vector2(cell) * TILE_SIZE, Vector2(TILE_SIZE, TILE_SIZE))
			var fill: Color = WALL_COLOR if level.tile_at(cell) == Level.Tile.WALL else FLOOR_COLOR
			draw_rect(rect, fill)
			draw_rect(rect, GRID_LINE_COLOR, false, 1.0)
