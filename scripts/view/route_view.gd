## Draws the planned route: a thick line through the points it is given, with
## a round dot on each one. It only LOOKS; the controller decides which
## points to show.
class_name RouteView
extends Node2D

const LINE_COLOR := Color("#1e88e5", 0.55)
const LINE_WIDTH: float = 14.0

var _points: PackedVector2Array = PackedVector2Array()


## Replaces the route being shown. `points` are pixel positions relative to
## this node's parent.
func show_route(points: PackedVector2Array) -> void:
	_points = points
	queue_redraw()


## Godot calls this after queue_redraw(). A route needs two points to be a line.
func _draw() -> void:
	if _points.size() < 2:
		return
	draw_polyline(_points, LINE_COLOR, LINE_WIDTH, true)
	for point in _points:
		draw_circle(point, LINE_WIDTH / 2.0, LINE_COLOR)
