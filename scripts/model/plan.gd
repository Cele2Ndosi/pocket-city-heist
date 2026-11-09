## The PLAN: the route the player has drawn for the thief.
## It is a list of cells that starts at the thief's start cell. Every new cell
## must touch the previous one (up, down, left or right) and be walkable.
## Rules only: no drawing, no input, no timers.
class_name Plan
extends RefCounted

## Emitted whenever the route changes, so others can react (redraw, reset...).
signal changed

var _level: Level
## Route cells in walking order. Index 0 is always the thief's start cell.
var _cells: Array[Vector2i] = []


func _init(level: Level) -> void:
	_level = level
	_cells.append(level.thief_start)


## A copy of the route, start cell first.
func get_cells() -> Array[Vector2i]:
	var copy: Array[Vector2i] = []
	copy.assign(_cells)
	return copy


## How many steps the thief will take (the start cell is not a step).
func step_count() -> int:
	return _cells.size() - 1


## Adds `cell` to the end of the route if the rules allow it.
## Returns true if the route changed.
func try_extend(cell: Vector2i) -> bool:
	if not _level.is_walkable(cell) or not _is_next_to(_cells.back(), cell):
		return false
	_cells.append(cell)
	changed.emit()
	return true


## Removes the last step. The start cell can never be removed.
func undo() -> void:
	if step_count() > 0:
		_cells.pop_back()
		changed.emit()


## Removes every step, leaving only the start cell.
func clear() -> void:
	if step_count() > 0:
		_cells.resize(1)
		changed.emit()


## True if the two cells share an edge (diagonals do not count).
func _is_next_to(a: Vector2i, b: Vector2i) -> bool:
	var distance := (a - b).abs()
	return distance.x + distance.y == 1
