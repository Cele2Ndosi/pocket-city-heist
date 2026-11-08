## Level layouts. DATA ONLY: no logic lives in this file.
##
## A level is an Array of strings, one string per row (top to bottom).
## Every row in a level must have the same length.
##
## Legend:
##   #  wall
##   .  floor
##   T  thief start (floor)
##   L  loot (floor)
##
## To add a level later, append another Array to ALL.
class_name Levels
extends RefCounted

const ALL: Array = [
	# Level 1
	[
		"#########",
		"#T..#...#",
		"#.#.#.#.#",
		"#.#...#.#",
		"#.#####.#",
		"#.......#",
		"#.#####.#",
		"#...#...#",
		"###.#.#.#",
		"#L..#...#",
		"#########",
	],
]
