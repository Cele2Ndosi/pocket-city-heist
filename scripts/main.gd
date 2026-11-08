## Entry point. It only WIRES the layers together:
##   Levels (data)  ->  Level (model)  ->  LevelView (drawing)
## It contains no game rules and no drawing code.
extends Node2D

## Which entry of Levels.ALL to play (0 = first level).
const LEVEL_INDEX: int = 0

## Empty space above the level, in pixels. The score/HUD will live here later.
const TOP_MARGIN: float = 100.0

const THIEF_COLOR := Color("#1e88e5")
const LOOT_COLOR := Color("#fbc02d")


## Godot calls _ready() once, when this node enters the scene.
func _ready() -> void:
	var level := Level.from_rows(Levels.ALL[LEVEL_INDEX])

	var view := LevelView.new()
	view.level = level  # Must be set BEFORE add_child().
	add_child(view)

	# Centre the level horizontally and leave room at the top.
	var screen_size := get_viewport_rect().size
	view.position = Vector2((screen_size.x - view.pixel_size().x) / 2.0, TOP_MARGIN)

	view.spawn_actor(level.loot, LOOT_COLOR)
	view.spawn_actor(level.thief_start, THIEF_COLOR)
