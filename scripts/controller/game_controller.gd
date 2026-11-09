## The CONTROLLER: connects input and buttons to the model, and the model to
## the views. It owns no game rules (those live in Plan and Simulation) and
## does no drawing (that lives in the views).
##
## States: "editing" (the timer is stopped: you can change the plan) and
## "running" (the timer is running: the thief is walking, input is ignored).
class_name GameController
extends Node

## Seconds between ticks. The thief also takes this long to walk one tile.
const TICK_SECONDS: float = 0.4

var _level: Level
var _plan: Plan
var _level_view: LevelView
var _route_view: RouteView
var _thief_view: ActorView
var _hud: Hud

## The run in progress (or the last finished run). Null while editing.
var _simulation: Simulation = null
var _timer: Timer
var _dragging: bool = false
var _last_pointer_cell: Vector2i = Vector2i(-1, -1)


## Plugs the collaborators in. Call it once, after adding this node to the scene.
func setup(
	level: Level,
	plan: Plan,
	level_view: LevelView,
	route_view: RouteView,
	thief_view: ActorView,
	hud: Hud
) -> void:
	_level = level
	_plan = plan
	_level_view = level_view
	_route_view = route_view
	_thief_view = thief_view
	_hud = hud

	_timer = Timer.new()
	_timer.wait_time = TICK_SECONDS
	_timer.timeout.connect(_on_tick)
	add_child(_timer)

	_plan.changed.connect(_on_plan_changed)
	_hud.undo_pressed.connect(_plan.undo)
	_hud.clear_pressed.connect(_plan.clear)
	_hud.go_pressed.connect(_on_go_pressed)

	_on_plan_changed()  # Show the empty route and the first status text.


## Godot calls this for mouse/touch events nobody else (like a button) used.
## Press or drag across tiles to extend the route. Touches arrive here as
## mouse events because Godot converts them by default.
func _unhandled_input(event: InputEvent) -> void:
	if _is_running():
		return
	if event is InputEventMouseButton:
		var click := event as InputEventMouseButton
		if click.button_index != MOUSE_BUTTON_LEFT:
			return
		_dragging = click.pressed
		_last_pointer_cell = Vector2i(-1, -1)  # So pressing on the same tile again counts.
		if _dragging:
			_extend_plan_to_pointer(click)
	elif event is InputEventMouseMotion and _dragging:
		_extend_plan_to_pointer(event as InputEventMouseMotion)


## Tries to extend the route to the tile under the pointer.
func _extend_plan_to_pointer(event: InputEventMouse) -> void:
	var local_event := _level_view.make_input_local(event) as InputEventMouse
	var cell := _level_view.pixel_to_cell(local_event.position)
	if cell == _last_pointer_cell:
		return  # Still on the same tile: nothing new.
	_last_pointer_cell = cell
	_plan.try_extend(cell)


## The route changed (by dragging, UNDO or CLEAR): redraw it and start over.
func _on_plan_changed() -> void:
	_reset_run()
	_route_view.show_route(_route_points())
	_refresh_hud()


## GO: play the plan from the very beginning.
func _on_go_pressed() -> void:
	if _is_running():
		return
	_reset_run()
	_simulation = Simulation.new(_level, _plan.get_cells())
	_timer.start()
	_refresh_hud()


## One beat of the clock. The tick after the last move ends the run, so the
## result appears once the thief has arrived.
func _on_tick() -> void:
	if _simulation.is_finished():
		_timer.stop()
	else:
		_simulation.tick()
		_thief_view.walk_to(_level_view.cell_center(_simulation.thief_cell), TICK_SECONDS)
	_refresh_hud()


## Stops any run and puts the thief back on the start tile.
func _reset_run() -> void:
	_timer.stop()
	_simulation = null
	_thief_view.teleport_to(_level_view.cell_center(_level.thief_start))


func _is_running() -> bool:
	return not _timer.is_stopped()


## The route as pixel positions for the RouteView.
func _route_points() -> PackedVector2Array:
	var points := PackedVector2Array()
	for cell in _plan.get_cells():
		points.append(_level_view.cell_center(cell))
	return points


## Updates the status text and the buttons to match the current state.
func _refresh_hud() -> void:
	var running := _is_running()
	_hud.set_buttons_enabled(not running and _plan.step_count() > 0)
	_hud.set_status(_status_text(running))


func _status_text(running: bool) -> String:
	if running:
		return "Running..."
	if _simulation != null:
		if _simulation.loot_collected:
			return "Loot grabbed in %d steps!" % _simulation.tick_count
		return "Never reached the loot. Edit the route and press GO."
	if _plan.step_count() == 0:
		return "Draw a route from the thief to the loot."
	return "%d steps planned. Press GO!" % _plan.step_count()
