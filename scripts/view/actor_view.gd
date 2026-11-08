## Draws ONE actor (thief, loot, later guards) as a coloured circle.
## It only knows how to LOOK. Where it stands is set by whoever owns it
## (see LevelView.spawn_actor) and it knows nothing about game rules.
class_name ActorView
extends Node2D

## Circle radius in pixels. Keep it under half a tile (LevelView.TILE_SIZE / 2).
const RADIUS: float = 28.0

## Fill colour. Set this before adding the actor to the scene.
var color: Color = Color.WHITE


## Godot calls _draw() whenever the node needs painting. Everything is drawn
## around the node's own origin (0, 0), so moving the node moves the circle.
func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, color)
	draw_arc(Vector2.ZERO, RADIUS, 0.0, TAU, 32, color.darkened(0.4), 4.0, true)
