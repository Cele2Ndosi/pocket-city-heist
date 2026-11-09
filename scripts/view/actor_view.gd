## Draws ONE actor (thief, loot, later guards) as a coloured circle and can
## slide to a new position. It only knows how to LOOK and MOVE VISUALLY;
## it knows nothing about game rules.
class_name ActorView
extends Node2D

## Circle radius in pixels. Keep it under half a tile (LevelView.TILE_SIZE / 2).
const RADIUS: float = 28.0

## Fill colour. Set this before adding the actor to the scene.
var color: Color = Color.WHITE

## The walk animation that is playing right now, if any.
var _tween: Tween


## Godot calls _draw() whenever the node needs painting. Everything is drawn
## around the node's own origin (0, 0), so moving the node moves the circle.
func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, color)
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 32, color.darkened(0.4), 4.0, true)


## Slides the actor to `target` (pixels, relative to its parent) over `seconds`.
func walk_to(target: Vector2, seconds: float) -> void:
	_stop_walking()
	_tween = create_tween()
	_tween.tween_property(self, "position", target, seconds)


## Puts the actor on `target` immediately and cancels any walk in progress.
func teleport_to(target: Vector2) -> void:
	_stop_walking()
	position = target


func _stop_walking() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
