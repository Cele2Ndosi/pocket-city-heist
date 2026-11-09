## The SIMULATION: plays a route tick by tick and tracks what happens.
## One tick = the thief walks one cell. Rules only: no drawing and no timers
## (whoever owns the simulation decides when to call tick()).
class_name Simulation
extends RefCounted

## Where the thief is right now.
var thief_cell: Vector2i
## True once the thief has stepped on the loot.
var loot_collected: bool = false
## How many ticks have been played so far (= steps walked).
var tick_count: int = 0

var _level: Level
var _route: Array[Vector2i] = []
## Index in _route of the cell the thief walks to next.
var _next_index: int = 1


func _init(level: Level, route: Array[Vector2i]) -> void:
	_level = level
	_route.assign(route)
	thief_cell = _route[0]


## True when the run is over: the loot was taken or the route has run out.
func is_finished() -> bool:
	return loot_collected or _next_index >= _route.size()


## Plays one tick: the thief walks to the next cell of the route.
func tick() -> void:
	if is_finished():
		return
	thief_cell = _route[_next_index]
	_next_index += 1
	tick_count += 1
	if thief_cell == _level.loot:
		loot_collected = true
