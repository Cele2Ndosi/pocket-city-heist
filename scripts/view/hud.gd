## The HUD (heads-up display): a status line at the top and the buttons at the
## bottom. It only shows things and announces button presses through signals;
## it does not know what the buttons DO.
##
## Positions are in the game's 720 x 1280 canvas (see Project Settings).
class_name Hud
extends CanvasLayer

## Signals are Godot's way of saying "something happened". Others connect to
## them to react (see GameController.setup).
signal undo_pressed
signal clear_pressed
signal go_pressed

const BUTTON_SIZE := Vector2(200, 110)
const BUTTON_FONT_SIZE: int = 40
const BUTTON_ROW_Y: float = 1060.0
const STATUS_FONT_SIZE: int = 30

var _status_label: Label
var _buttons: Array[Button] = []


## Godot calls _ready() once, when the HUD enters the scene: build the widgets.
func _ready() -> void:
	_status_label = Label.new()
	_status_label.position = Vector2(20, 10)
	_status_label.size = Vector2(680, 80)
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.add_theme_font_size_override("font_size", STATUS_FONT_SIZE)
	add_child(_status_label)

	_add_button("UNDO", 30.0, undo_pressed)
	_add_button("CLEAR", 260.0, clear_pressed)
	_add_button("GO", 490.0, go_pressed)


## Shows `text` in the status line.
func set_status(text: String) -> void:
	_status_label.text = text


## Enables or disables all the buttons at once.
func set_buttons_enabled(enabled: bool) -> void:
	for button in _buttons:
		button.disabled = not enabled


## Creates one button at column `x` that emits `pressed_signal` when pressed.
func _add_button(text: String, x: float, pressed_signal: Signal) -> void:
	var button := Button.new()
	button.text = text
	button.position = Vector2(x, BUTTON_ROW_Y)
	button.size = BUTTON_SIZE
	button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	button.pressed.connect(pressed_signal.emit)
	add_child(button)
	_buttons.append(button)
