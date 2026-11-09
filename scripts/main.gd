## Entry point and COMPOSITION ROOT: it builds every object once, plugs them
## together, and then leaves the running of the game to the GameController.
##   Levels (data) -> Level (model) -> views -> GameController
## It contains no game rules and no drawing code.
extends Node2D

## Which entry of Levels.ALL to play (0 = first level).
const LEVEL_INDEX: int = 0

## Empty space above the level, in pixels. The status text lives here.
const TOP_MARGIN: float = 100.0

const THIEF_COLOR := Color("#1e88e5")
const LOOT_COLOR := Color("#fbc02d")


## Godot calls _ready() once, when this node enters the scene.
func _ready() -> void:
	var level := Level.from_rows(Levels.ALL[LEVEL_INDEX])

	var level_view := LevelView.new()
	level_view.level = level  # Must be set BEFORE add_child().
	add_child(level_view)

	# Centre the level horizontally and leave room at the top.
	var screen_size := get_viewport_rect().size
	level_view.position = Vector2((screen_size.x - level_view.pixel_size().x) / 2.0, TOP_MARGIN)

	# Children are drawn in the order they are added: route first, actors on top.
	var route_view := RouteView.new()
	level_view.add_child(route_view)
	level_view.spawn_actor(level.loot, LOOT_COLOR)
	var thief_view := level_view.spawn_actor(level.thief_start, THIEF_COLOR)

	var hud := Hud.new()
	add_child(hud)

	var controller := GameController.new()
	add_child(controller)
	controller.setup(level, Plan.new(level), level_view, route_view, thief_view, hud)
