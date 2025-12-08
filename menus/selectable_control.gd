extends MarginContainer
class_name SelectableControl

signal clicked()

@export var highlight_stylebox: StyleBoxFlat = preload("uid://c8ppw2slr6gpa")
@export var autofocus: bool = false

var _pressed: bool = false

func _init() -> void:
	focus_mode = Control.FOCUS_ALL
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(_on_mouse_entered)
	set_process(false)

func _ready() -> void:
	var highlight_tween = highlight_stylebox.get_meta("highlight_tween", null) if highlight_stylebox.has_meta("highlight_tween") else null
	if not highlight_tween:
		highlight_tween = get_tree().create_tween().set_loops()
		highlight_tween.tween_property(highlight_stylebox, "bg_color", Color(0.8, 0.753, 0.012, 0.486), 0.5)
		highlight_tween.tween_property(highlight_stylebox, "bg_color", Color(0.8, 0.752, 0.0, 1.0), 0.5)
		highlight_stylebox.set_meta("highlight_tween", highlight_tween)
	if autofocus:
		grab_focus()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if has_focus():
		draw_style_box(highlight_stylebox, Rect2(Vector2.ZERO, size))

func _gui_input(event: InputEvent) -> void:
	var is_click := event.is_action("ui_accept") or event.is_action("ui_select")
	
	if not is_click:
		return
	
	accept_event()
	
	if event.is_pressed():
		_pressed = true
	elif _pressed and event.is_released():
		_pressed = false
		clicked.emit()

func _on_focus_entered() -> void:
	set_process(true)

func _on_focus_exited() -> void:
	set_process(false)
	queue_redraw()

func _on_mouse_entered() -> void:
	grab_focus()
